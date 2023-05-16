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
    
    private var task: Task<Void, Never>? = nil
    private var cancellable: AnyCancellable?
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
            var client: PhotonAIClient? = PhotonAIClient(apiKey: Keychain.getSwift() ?? "", withAdaptor: AlamofireAdaptor())
            var currentMessage: Message? = nil
            var messages: [ChatCompletion.Request.Message] = [
                .init(role: ChatRoleEnum.system.rawValue, content: "My name is Cowriter, your kindly writing assistant"),
            ]
            
            func createNewMessage(
                _ userMessage: String = self.userMessage,
                role: ChatRoleEnum = .user
            ) -> Message {
                let message = Message(context: context)
                message.id = UUID()
                message.date = Date()
                message.content = userMessage
                message.role = role.rawValue
                
                return message
            }
            
            if userMessage.isEmpty {
                return
            }
            
            withAnimation {
                self.isLoading = true
                self.textToDisplay = ""
            }
            
            if let chat = chat {
                let newMessage = createNewMessage()
                currentMessage = newMessage
                chat.addToMessages(newMessage)
                // token count for userMessage
                chat.tokenUsage += Int32(userMessage.tokenize())
                currentChat = chat
            } else {
                let newChat = Chat(context: context)
                let newMessage = createNewMessage()
                currentMessage = newMessage
                newChat.id = UUID()
                newChat.owner = User.fetchFirstUser(in: context)
                newChat.messages = [newMessage]
                // initial token count for userMessage + system message
                newChat.tokenUsage += Int32(userMessage.tokenize()) + 10
                currentChat = newChat
            }
            
            guard let client = client else {
                errorMessage = "Please configure with API Key"
                return
            }
            
            /// The defer keyword in Swift is used to execute code just before a function or a block of code returns.
            defer {
                if let chat = currentChat, let message = chat.wrappedMessages.first?.content, chat.title == nil {
                    self.getChatTitle(prompt: message, completion: { result in
                        chat.title = result.title.capitalized.removeNewLines()
                        chat.tokenUsage += Int32(result.token)
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
                messages += chat.wrappedMessages.map { .init(role: $0.wrappedRole, content: $0.wrappedContent) }
            } else {
                messages.append(.init(role: ChatRoleEnum.user.rawValue, content: userMessage))
            }
            
            let chatRequest = ChatCompletion.Request(.init(messages: messages))
            
            let stream = client.chatCompletion.stream(request: chatRequest) { response in
                response.choices.first?.delta.content ?? ""
            }
            
            do {
                if let chat = chat ?? currentChat {
                    // create empty message prompt as container to accomodate future completed message
                    let newMessage = createNewMessage("", role: .assistant)
                    currentMessage = newMessage
                    chat.addToMessages(newMessage)
                    
                    for try await result in stream {
                        self.textToDisplay += result
                    }
                    
                    // add future completed message
                    if let lastMessage = chat.wrappedMessages.last {
                        lastMessage.content = textToDisplay
                    }
                    chat.tokenUsage += Int32(textToDisplay.tokenize())
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
    
    func getChatTitle(prompt: String, completion: @escaping (ChatTitle) -> Void) {
        guard prompt.containsOneWord() else {
            let message = "He: \"\(prompt)\"\n\n\nHe asked for "
            let rawRequest = CompletionRequestType(model: GPTModelType.babbage.rawValue, prompt: message, temperature: 0, max_tokens: 8)
            let dictionaryRequest = Utils.toDictionary(rawRequest)
            
            APIRequest.postRequestWithToken(url: APIEndpoint.completions, dataModel: CompletionResponseType.self, body: dictionaryRequest) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        //                    print("Success! Response data: \(data.choices)")
                        let title = data.choices.first?.text ?? "A chat"
                        completion(ChatTitle(title: title, token: message.tokenize()))
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
            return
        }
        completion(ChatTitle(title: prompt, token: 0))
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
