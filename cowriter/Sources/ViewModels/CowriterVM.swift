//
//  CowriterVM.swift
//  cowriter
//
//  Created by Aditya Cahyo on 13/04/23.
//

import Foundation
import SwiftUI
import PhotonOpenAIKit
import PhotonOpenAIAlamofireAdaptor

class CowriterVM: ObservableObject {
    @Published var userMessage: String = "" // prompt
    @Published var text: String = "" // result
    
    @Published var prevPrompt: String = ""
    @Published var prevResult: String = ""
    
    @Published var errorMessage: String = ""
    @Published var isLoading = false
    
    @Published var history: [Prompts] = []
    
    private var client: PhotonAIClient? = PhotonAIClient(apiKey: Keychain.getApiKey() ?? "", withAdaptor: AlamofireAdaptor())
    private var task: Task<Void, Never>? = nil
    
    func cancel() {
        task?.cancel()
    }
    
    @MainActor
    func request() {
        cancel()
        task = Task {
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
            
            defer {
                withAnimation {
                    self.isLoading = false
                }
            }
            
            self.text = ""
            
            history.append(Prompts(prompt: userMessage, result: ""))
            
            let request = ChatCompletion.Request(.init(userMessage: userMessage))
            let stream = client.chatCompletion.stream(request: request) { response in
                response.choices.first?.delta.content ?? ""
            }
            
            do {
                for try await result in stream {
                    self.text += result
                }
                history[history.count - 1].result = text
                userMessage = ""
            } catch {
                print("error \(error)")
                self.errorMessage = String(describing: error)
            }
        }
    }
}
