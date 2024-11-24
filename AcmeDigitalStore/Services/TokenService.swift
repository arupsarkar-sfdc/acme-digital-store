//
//  TokenService.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/23/24.
//

import Foundation
import Combine

struct TokenResponse: Codable {
    let token: Token
    
    struct Token: Codable {
        let accessToken: String
        let expiresIn: Int
        let instanceUrl: String
        let issuedTokenType: String
        let tokenType: String
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case expiresIn = "expires_in"
            case instanceUrl = "instance_url"
            case issuedTokenType = "issued_token_type"
            case tokenType = "token_type"
        }
    }
}

final class TokenService {
    static let shared = TokenService()
    private init() {}
    
    func fetchToken() -> AnyPublisher<TokenResponse, Error> {
        guard let url = URL(string: "http://localhost:8081/get-token") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: TokenResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
