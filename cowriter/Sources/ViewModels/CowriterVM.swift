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
    
    @Published var allChats: [ChatType] = []
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
        allChats = ChatType.getAll()
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
                if let chat = currentChat, chat.title == nil {
                    self.getChatTitle(results: chat.resultsArray, completion: { string in
                        chat.title = Utils.removeNewlineAtBeginning(string ?? "Cowriter").capitalized
                        PersistenceController.save()
                    })
                }
                withAnimation {
                    self.isLoading = false
                    if self.errorMessage.isEmpty {
                        self.userMessage = ""
                    }
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
                if !self.errorMessage.isEmpty { /// delete prev error message if last req is success
                    withAnimation {
                        errorMessage = ""
                    }
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
                if String(describing: error).contains("429") {
                    self.errorMessage = "Uh oh, it seems like you're firing off too many requests too quickly! Hang tight for a bit and try again later, okay? "
                } else {
                    withAnimation(.easeInOut) {
                        self.errorMessage = String(describing: error)
                    }
                }
            }
        }
    }
    
    func getChatTitle(results: [ResultType], completion: @escaping (String?) -> Void) {
        var title = ""
        var message = ""
        
        if let result = results.first, let prompt = result.prompt, let answer = result.answer {
            let resultString = "Human: \(prompt)\n\nAI: \(answer)\n\n\nchat title is about "
            message = resultString
        }
        let raw = CompletionRequestType(model: GPTModelType.babbage.rawValue, prompt: message, max_tokens: 20)
        let dictionary = Utils.toDictionary(raw)
        
        APIRequest.postRequestWithToken(url: APIEndpoint.completions, dataModel: CompletionResponseType.self, body: dictionary) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    print("Success! Response data: \(data)")
                    print(data.choices)
                    title = data.choices[0].text
                    completion(title)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
    }
    
}
