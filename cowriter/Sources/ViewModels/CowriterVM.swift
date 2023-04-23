//
//  CowriterVM.swift
//  cowriter
//
//  Created by Aditya Cahyo on 13/04/23.
//

import SwiftUI
import Combine
import CoreData
import PhotonOpenAIKit
import PhotonOpenAIAlamofireAdaptor

class CowriterVM: ObservableObject {
    @Published var userMessage: String = "" // prompt
    @Published var textToDisplay: String = "" // result
    
    @Published var errorMessage: String = ""
    @Published var isLoading = false
    
    @Published var oldChats: [ChatType] = []
    @Published var currentChat: ChatType?
    
    private var client: PhotonAIClient? = PhotonAIClient(apiKey: Keychain.getApiKey() ?? "", withAdaptor: AlamofireAdaptor())
    private var task: Task<Void, Never>? = nil
    
    private var cancellable: AnyCancellable?
    
    init() {
        getAllChats()
        cancellable = NotificationCenter.default.publisher(for: NSManagedObjectContext.didSaveObjectsNotification, object: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.getAllChats()
            })
    }
    
    func cancel() {
        task?.cancel()
    }
    
    func getAllChats() {
        oldChats = ChatType.getAll()
    }
    
    @MainActor
    func request(_ chat: ChatType?) {
        cancel()
        task = Task {
            let context = PersistenceController.viewContext
            var currentResult: ResultType?
            var messages: [ChatCompletion.Request.Message] = [
                .init(role: "system", content: "My name is Cowriter, your kindly writing assistant"),
            ]
            
            func createResult() -> ResultType {
                let result = ResultType(context: context)
                result.id = UUID()
                result.date = Date()
                result.prompt = userMessage
                result.answer = ""
                
                return result
            }
            
            if userMessage.isEmpty {
                return
            }
            
            withAnimation {
                self.isLoading = true
            }
            
            self.textToDisplay = ""
            
            if let chat = chat {
                let newResult = createResult()
                currentResult = newResult
                chat.addToResults(newResult)
                currentChat = chat
                PersistenceController.save()
            } else {
                let newResult = createResult()
                currentResult = newResult
                let newChat = ChatType(context: context)
                newChat.id = UUID()
                newChat.userId = ""
                newChat.results = [newResult]
                currentChat = newChat
                PersistenceController.save()
            }
            
            guard let client = client else {
                errorMessage = "Please configure with API Key"
                return
            }
            
            defer { /// The defer keyword in Swift is used to execute code just before a function or a block of code returns.
                withAnimation {
                    self.isLoading = false
                    self.userMessage = ""
//                    self.textToDisplay = ""
                }
            }

            if let chat = chat {
                messages += chat.resultsArray.map { .init(role: "user", content: $0.wrappedPrompt) }
                messages += chat.resultsArray.map { .init(role: "assistant", content: $0.wrappedAnswer) }
            } else {
                messages.append(.init(role: "user", content: userMessage))
            }
            
            let chatRequest = ChatCompletion.Request(.init(messages: messages))
            
            let stream = client.chatCompletion.stream(request: chatRequest) { response in
                response.choices.first?.delta.content ?? ""
            }
            
            do {
                for try await result in stream {
                    self.textToDisplay += result
                }
                if let chat = chat ?? currentChat,
                    let lastResult = chat.resultsArray.last {
                        lastResult.answer = textToDisplay
                        PersistenceController.save()
                }
            } catch {
                if let currentChat = currentChat {
                   if currentChat.resultsArray.count == 1 {
                       context.delete(currentChat)
                       PersistenceController.save()
                   } else if let currentResult = currentResult {
                       currentChat.removeFromResults(currentResult)
                   }
                }
                print("error \(error)")
                self.errorMessage = String(describing: error)
            }
        }
    }
}
