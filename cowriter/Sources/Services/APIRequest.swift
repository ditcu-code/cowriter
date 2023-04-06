//
//  APIRequest.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/04/23.
//

import Foundation
import SwiftUI
import Combine

class APIRequest {
    static func postRequestWithToken<T: Codable>(
        dataModel: T.Type,
        body: [String: Any],
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
        let url = APIEndpoint.chatCompletions
        let token = Keychain.getApiKey() ?? ""
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data returned", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseObject = try decoder.decode(T.self, from: data)
                completion(.success(responseObject))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}
