//
//  CowriterVM.swift
//  cowriter
//
//  Created by Aditya Cahyo on 13/04/23.
//

import Foundation
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
    
    @Published var history: [ChatModel] = []
    @Published var histories: [ChatType] = []
    
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
        histories = ChatType.getAll()
    }
    
    @MainActor
    func request(_ id: UUID?) {
        cancel()
        task = Task {
            
            let isNew = id == nil
            let newChatId = UUID()
            let context = PersistenceController.viewContext
            
            if userMessage.isEmpty {
                return
            }
            
            guard let client = client else {
                errorMessage = "Please configure with API Key"
                return
            }
            
            withAnimation {
                self.isLoading = true
            }
            
            defer { /// The defer keyword in Swift is used to execute code just before a function or a block of code returns.
                withAnimation {
                    self.isLoading = false
                    userMessage = ""
                }
                print(histories)
            }
            
            self.textToDisplay = ""

            
            func saveChat(_ newId: UUID) {
                let result = ResultType(context: context)
                result.id = UUID()
                result.date = Date()
                result.prompt = userMessage
                result.answer = ""

                let chat = ChatType(context: context)
                chat.id = newId
                chat.userId = ""
                chat.results = [result]
                
                PersistenceController.save()
            }
            
            if isNew {
                saveChat(newChatId)
            } else if histories.filter({ $0.id == id }).first != nil {
                let result = ResultType(context: context)
                result.id = UUID()
                result.date = Date()
                result.prompt = userMessage
                result.answer = ""
                
                let asf = histories.filter({ $0.id == id }).first!
                asf.addToResults(result)
            }
            
            var messages: [ChatCompletion.Request.Message] = [
                .init(role: "system", content: "I'm a writing assistant. I'm not allowed to answer questions"),
            ]

            if isNew {
                messages.append(.init(role: "user", content: userMessage))
            } else if histories.filter({ $0.id == id }).first != nil {
                print("2")
                histories.filter({ $0.id == id }).first!.resultsArray.map {$0.wrappedPrompt}.forEach { item in
                    messages.append(.init(role: "user", content: item))
                }
                
                histories.filter({ $0.id == id }).first!.resultsArray.map {$0.wrappedAnswer}.forEach { item in
                    messages.append(.init(role: "assistant", content: item))
                }
                
            }
            
            let chatRequest = ChatCompletion.Request(.init(messages: messages))
            
            let stream = client.chatCompletion.stream(request: chatRequest) { response in
                response.choices.first?.delta.content ?? ""
            }
            
            do {
                for try await result in stream {
                    self.textToDisplay += result
                }
                if isNew {
                    let currentChat = ChatType.getById(with: newChatId)
                    if currentChat != nil {
                        currentChat!.resultsArray[currentChat!.resultsArray.count - 1].answer = textToDisplay
                    }
                } else if histories.filter({ $0.id == id }).first != nil {
                    let asf = histories.filter({ $0.id == id }).first!
                    asf.resultsArray[asf.resultsArray.count - 1].answer = textToDisplay
                    PersistenceController.save()
                }
            } catch {
                print("error \(error)")
                self.errorMessage = String(describing: error)
            }
        }
    }
}
