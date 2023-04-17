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
    @Published var loading: Bool = false
    @Published var textPrompt: String = ""
    
    @Published var text: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoading = false
    
    private var client: PhotonAIClient? = PhotonAIClient(apiKey: Keychain.getApiKey() ?? "", withAdaptor: AlamofireAdaptor())
    private var task: Task<Void, Never>? = nil
    
//    func configureClient(apiKey: String) {
//        client = PhotonAIClient(apiKey: apiKey, withAdaptor: AlamofireAdaptor())
//    }
    
    func cancel() {
        task?.cancel()
    }
    
    @MainActor
    func request(userMessage: String) {
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
            
            let request = ChatCompletion.Request(.init(userMessage: userMessage))
            let stream = client.chatCompletion.stream(request: request) { response in
                response.choices.first?.delta.content ?? ""
            }
            
            do {
                for try await result in stream {
                    self.text += result
                }
            } catch {
                print("error \(error)")
                self.errorMessage = String(describing: error)
            }
        }
    }
}
