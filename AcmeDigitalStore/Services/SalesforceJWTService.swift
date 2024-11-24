//
//  SalesforceJWTService.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/22/24.
//

import Foundation
import Security

final class SalesforceJWTService {
    static let shared = SalesforceJWTService()
    private init() {}
    
    // MARK: - Configuration
    private struct JWTConfig {
        static let tokenEndpoint = "https://login.salesforce.com/services/oauth2/token"
        static let audience = "https://login.salesforce.com"
        static let expirationTime: TimeInterval = 300 // 5 minutes
    }
    
    // MARK: - Public Interface
    func authenticate(
        clientId: String,
        username: String,
        privateKey: SecKey,
        completion: @escaping (Result<String, JWTError>) -> Void
    ) {
        createJWTToken(
            clientId: clientId,
            username: username,
            privateKey: privateKey
        ) { result in
            switch result {
            case .success(let token):
                self.exchangeJWTForAccessToken(token: token, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private Methods
    private func createJWTToken(
        clientId: String,
        username: String,
        privateKey: SecKey,
        completion: @escaping (Result<String, JWTError>) -> Void
    ) {
        let header = [
            "alg": "RS256",
            "typ": "JWT"
        ]
        
        let now = Date()
        let payload: [String: Any] = [
            "iss": clientId,
            "sub": username,
            "aud": JWTConfig.audience,
            "exp": Int(now.addingTimeInterval(JWTConfig.expirationTime).timeIntervalSince1970),
            "iat": Int(now.timeIntervalSince1970)
        ]
        
        guard
            let headerData = try? JSONSerialization.data(withJSONObject: header),
            let payloadData = try? JSONSerialization.data(withJSONObject: payload)
        else {
            completion(.failure(.invalidData))
            return
        }
        
        let headerString = headerData.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        
        let payloadString = payloadData.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        
        let signingInput = "\(headerString).\(payloadString)"
        
        guard let signature = sign(input: signingInput, with: privateKey) else {
            completion(.failure(.signatureError))
            return
        }
        
        let token = "\(signingInput).\(signature)"
        completion(.success(token))
    }
    
    private func exchangeJWTForAccessToken(
        token: String,
        completion: @escaping (Result<String, JWTError>) -> Void
    ) {
        var request = URLRequest(url: URL(string: JWTConfig.tokenEndpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters = [
            "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
            "assertion": token
        ]
        
        request.httpBody = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let accessToken = json["access_token"] as? String
            else {
                completion(.failure(.invalidResponse))
                return
            }
            
            completion(.success(accessToken))
        }.resume()
    }
    
    private func sign(input: String, with privateKey: SecKey) -> String? {
        guard let inputData = input.data(using: .utf8) else { return nil }
        
        var error: Unmanaged<CFError>?
        guard let signedData = SecKeyCreateSignature(
            privateKey,
            .rsaSignatureMessagePKCS1v15SHA256,
            inputData as CFData,
            &error
        ) as Data? else {
            return nil
        }
        
        return signedData.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

enum JWTError: Error {
    case invalidData
    case signatureError
    case networkError(Error)
    case invalidResponse
}
