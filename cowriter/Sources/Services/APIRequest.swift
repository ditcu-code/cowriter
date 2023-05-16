//
//  APIRequest.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/04/23.
//

import Foundation
import Alamofire

class APIRequest {
    static func postRequestWithToken<T: Codable>(
        url: URL,
        dataModel: T.Type,
        body: [String: Any],
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let token = Keychain.getSwift() ?? ""
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(url,
                   method: .post,
                   parameters: body,
                   encoding: JSONEncoding.prettyPrinted,
                   headers: headers
        )
        .validate()
        .responseDecodable(of: dataModel, decoder: decoder) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
