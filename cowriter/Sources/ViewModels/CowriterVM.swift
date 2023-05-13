//
//  CowriterVM.swift
//  cowriter
//
//  Created by Aditya Cahyo on 13/04/23.
//

import SwiftUI
import Combine
import CoreData
import GPT3_Tokenizer
import PhotonOpenAIKit
import PhotonOpenAIAlamofireAdaptor

class CowriterVM: ObservableObject {
    @Published var userMessage: String = "" /// prompt
    @Published var textToDisplay: String = "" /// answer
    
    @Published var errorMessage: String = ""
    @Published var isLoading = false
    
    @Published var allChats: [Chat] = []
    @Published var currentChat: Chat?
    
    // UI
    @Published var showSideBar: Bool = false
    @Published var showToolbar: Bool = false
    @Published var isFocusOnPrompter: Bool = false
    @Published var favoriteFilterIsOn: Bool = false
    
    private var client: PhotonAIClient? = PhotonAIClient(apiKey: Keychain.getApiKey() ?? "", withAdaptor: AlamofireAdaptor())
    private var task: Task<Void, Never>? = nil
    private var cancellable: AnyCancellable?
    private let gpt3Tokenizer = GPT3Tokenizer()
    private let context = PersistenceController.viewContext
    
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
        allChats = Chat.getAll()
    }
    
    @MainActor
    func request(_ chat: Chat?) {
        cancel()
        task = Task {
            var currentMessage: Message? = nil
            var messages: [ChatCompletion.Request.Message] = [
                .init(role: "system", content: "My name is Cowriter, your kindly writing assistant"),
            ]
            
            func createNewMessage(
                _ userMessage: String = self.userMessage,
                isPrompt: Bool = true
            ) -> Message {
                let message = Message(context: context)
                message.id = UUID()
                message.date = Date()
                message.content = userMessage
                message.isPrompt = isPrompt
                
                return message
            }
            
            if userMessage.isEmpty {
                return
            }
            
            withAnimation {
                self.isLoading = true
            }
            
            self.textToDisplay = ""
            
            if let chat = chat {
                let newMessage = createNewMessage()
                currentMessage = newMessage
                chat.addToMessages(newMessage)
                // token count for userMessage
                chat.usage += Int32(gpt3Tokenizer.encoder.enconde(text: userMessage).count)
                currentChat = chat
            } else {
                let newChat = Chat(context: context)
                let newMessage = createNewMessage()
                currentMessage = newMessage
                newChat.id = UUID()
                newChat.ownerId = ""
                newChat.messages = [newMessage]
                // initial token count for userMessage + system message
                newChat.usage += Int32(gpt3Tokenizer.encoder.enconde(text: userMessage).count) + 10
                currentChat = newChat
            }
            
            guard let client = client else {
                errorMessage = "Please configure with API Key"
                return
            }
            
            /// The defer keyword in Swift is used to execute code just before a function or a block of code returns.
            defer {
                if let chat = currentChat, chat.title == nil {
                    self.getChatTitle(messages: chat.wrappedMessages, completion: { result in
                        chat.title = result.title.removeNewLines()
                        chat.usage += Int32(result.token)
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
                messages += chat.wrappedMessages.map { .init(role: $0.isPrompt ? "user" : "assistant", content: $0.wrappedContent) }
            } else {
                messages.append(.init(role: "user", content: userMessage))
            }
            
            let chatRequest = ChatCompletion.Request(.init(messages: messages))
            
            let stream = client.chatCompletion.stream(request: chatRequest) { response in
                response.choices.first?.delta.content ?? ""
            }
            
            do {
                if let chat = chat ?? currentChat {
                    // create empty message prompt as container to accomodate future completed message
                    let newMessage = createNewMessage("", isPrompt: false)
                    currentMessage = newMessage
                    chat.addToMessages(newMessage)
                    
                    for try await result in stream {
                        self.textToDisplay += result
                    }
                    
                    // add future completed message
                    if let lastMessage = chat.wrappedMessages.last {
                        lastMessage.content = textToDisplay
                    }
                    chat.usage += Int32(gpt3Tokenizer.encoder.enconde(text: textToDisplay).count)
                    PersistenceController.save()
                }
                
                // delete prev error message if last req is success
                if !self.errorMessage.isEmpty {
                    withAnimation {
                        errorMessage = ""
                    }
                }
                
            } catch {
                if let chat = currentChat {
                    if chat.wrappedMessages.count == 1 {
                        context.delete(chat)
                        currentChat = nil
                    } else if let currentMessage = currentMessage {
                        chat.removeFromMessages(currentMessage)
                        if let last = chat.wrappedMessages.last {
                            chat.removeFromMessages(last)
                        }
                    }
                    PersistenceController.save()
                }
                switch String(describing: error) {
                case let errorStr where errorStr.contains("429"):
                    errorMessage = "Uh oh, you're sending too many requests! Take a breather and try again later, okay?"
                case let errorStr where errorStr.contains("-1"):
                    errorMessage = "Oops! It seems like you're having connection issues. Please check your internet connection and try again later."
                default:
                    withAnimation(.easeInOut) {
                        errorMessage = String(describing: error)
                    }
                }
            }
        }
    }
    
    func getChatTitle(messages: [Message], completion: @escaping (ChatTitle) -> Void) {
        var title = ""
        var message = ""
        
        if let prompt = messages.first?.content, let answer = messages[1].content {
            let messageString = "Human: \(prompt)\n\nAI: \(answer)\n\n\nchat title is about "
            message = messageString
        }
        let raw = CompletionRequestType(model: GPTModelType.babbage.rawValue, prompt: message, max_tokens: 8)
        let dictionary = Utils.toDictionary(raw)
        
        APIRequest.postRequestWithToken(url: APIEndpoint.completions, dataModel: CompletionResponseType.self, body: dictionary) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    //                    print("Success! Response data: \(data.choices)")
                    title = data.choices.first?.text ?? "A chat"
                    completion(ChatTitle(title: title, token: self.gpt3Tokenizer.encoder.enconde(text: message).count))
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func removeChat(at offsets: IndexSet) {
        for index in offsets {
            Task {
                let chat = self.allChats[index]
                PersistenceController.viewContext.delete(chat)
                DispatchQueue.main.async {
                    self.getAllChats()
                    self.currentChat = nil
                }
            }
        }
    }
    
    // UI
    
    func closeSideBar() {
        if showSideBar {
            withAnimation(.interpolatingSpring(stiffness: 150, damping: 20)){
                self.showSideBar = false
            }
        }
    }
    
    func removePrompterFocus() {
        if isFocusOnPrompter {
            self.isFocusOnPrompter = false
        }
    }
    
}

struct ChatTitle {
    var title: String
    var token: Int
}
