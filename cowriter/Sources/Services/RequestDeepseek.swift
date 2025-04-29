//
//  RequestDeepseek.swift
//  cowriter
//
//  Created by Aditya Cahyo on 29/04/25.
//

import Foundation
import Alamofire

// Define the response model based on DeepSeek's API response structure
struct DeepSeekCompletionResponse: Codable {
    let id: String
    let choices: [Choice]
    let created: Int
    let model: String
    let systemFingerprint: String
    let object: String
    let usage: Usage

    struct Choice: Codable {
        let text: String
        let index: Int
        let logprobs: String?
        let finishReason: String

        enum CodingKeys: String, CodingKey {
            case text
            case index
            case logprobs
            case finishReason = "finish_reason"
        }
    }

    struct Usage: Codable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int
        let promptTokensDetails: PromptTokensDetails
        let promptCacheHitTokens: Int
        let promptCacheMissTokens: Int

        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
            case promptTokensDetails = "prompt_tokens_details"
            case promptCacheHitTokens = "prompt_cache_hit_tokens"
            case promptCacheMissTokens = "prompt_cache_miss_tokens"
        }

        struct PromptTokensDetails: Codable {
            let cachedTokens: Int

            enum CodingKeys: String, CodingKey {
                case cachedTokens = "cached_tokens"
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case choices
        case created
        case model
        case systemFingerprint = "system_fingerprint"
        case object
        case usage
    }
}


extension DeepSeekCompletionResponse {
    func firstTextChoice() -> String {
        return choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}

class RequestDeepSeek {
    static func postCompletion(
        prompt: String,
        model: String = "deepseek-chat",
        temperature: Double = 1.0,
        maxTokens: Int = 100,
        topP: Double = 1.0,
        completion: @escaping (Result<DeepSeekCompletionResponse, Error>) -> Void
    ) {
        guard let token = CowriterLinks.getSwift(), !token.isEmpty else {
            completion(.failure(NSError(domain: "Missing API token", code: 401, userInfo: nil)))
            return
        }

        let url = URL(string: "https://api.deepseek.com/beta/completions")!
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]

        let body: [String: Any] = [
            "model": model,
            "prompt": prompt,
            "temperature": temperature,
            "max_tokens": maxTokens,
            "top_p": topP
        ]

        let decoder = JSONDecoder()

        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoded = try decoder.decode(DeepSeekCompletionResponse.self, from: data)
                        completion(.success(decoded))
                    } catch {
                        print("❌ Decoding error: \(error.localizedDescription)")
                        if let raw = String(data: data, encoding: .utf8) {
                            print("🔎 Raw response:\n\(raw)")
                        }
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("❌ Request failed: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}

