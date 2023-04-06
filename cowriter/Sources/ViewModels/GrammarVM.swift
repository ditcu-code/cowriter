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
    @Published var response: ChatResponse? = nil
    @Published var loading: Bool = false
    
    func check() {
        loading = true
        let raw = ChatCompletionReq(messages: [ChatMessage(role: "user", content: inputText)])
        let dictionary = Utils.toDictionary(raw)
        
        APIRequest.postRequestWithToken(dataModel: ChatResponse.self, body: dictionary) { result in
            DispatchQueue.main.async {
            switch result {
                case .success(let data):
                    print("Success! Response data: \(data)")
                    
                    self.loading.toggle()
                    self.response = data.self
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.loading.toggle()
                }
            }
        }
    }
}
