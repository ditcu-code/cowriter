//
//  GrammarActionsVM.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import Foundation

class GrammarVM: ObservableObject {
    @Published var inputText: String = ""
    @Published var texts: [UserText] = []
    @Published var responseCompletion: CompletionResponseType? = nil
    @Published var responseChat: ChatResponseChatType? = nil
    @Published var loading: Bool = false
    @Published var textLang: String = ""
    
    func insertGrammarText(_ text: String) -> String {
        return "Correct this to standard English: [\(text)]"
    }
    
    func insertRephraseText(_ text: String) -> String {
        return "Rephrase this sentence: [\(text)]"
    }
    
    func check() {
        loading = true
        textLang = inputText.detectLanguage()
        let raw = CompletionRequestType(prompt: insertGrammarText(inputText))
        let dictionary = Utils.toDictionary(raw)
        
        APIRequest.postRequestWithToken(url: APIEndpoint.completions, dataModel: CompletionResponseType.self, body: dictionary) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    print("Success! Response data: \(data)")
                    self.loading.toggle()
                    self.responseCompletion = data.self
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.loading.toggle()
                }
            }
        }
    }
    
    func rephrase() {
        loading = true
        textLang = inputText.detectLanguage()
        let raw = ChatRequestType(messages: [ChatMessageType(role: "user", content: insertRephraseText(inputText))])
        let dictionary = Utils.toDictionary(raw)
        
        APIRequest.postRequestWithToken(url: APIEndpoint.chatCompletions, dataModel: ChatResponseChatType.self, body: dictionary) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    print("Success! Response data: \(data)")
                    self.loading.toggle()
                    self.responseChat = data.self
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.loading.toggle()
                }
            }
        }
    }
}
