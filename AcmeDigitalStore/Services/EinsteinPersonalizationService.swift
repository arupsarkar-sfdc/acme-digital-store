//
//  EinsteinPersonalizationService.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 12/9/24.
//


import Combine
import Foundation
import SFMCSDK
import Cdp

//Request models to match the exact API structure
struct PersonalizationRequest: Encodable {
    let context: PersonalizationContext
    let personalizationPoints: [PersonalizationPoint]
    let profile: [String: String]
    let executionFlags: [String]
    
    struct PersonalizationContext: Encodable {
        let individualId: String
        let unifiedIndividualId: String
        let dataspace: String
        let anchorId: String
        let anchorType: String
        let correlationId: String
        let messageId: String
        let requestUrl: String
    }
    
    struct PersonalizationPoint: Encodable {
        let id: String
        let name: String
        let decisionId: String
    }
}

//Response models to match the exact API response
struct PersonalizationResponse: Decodable {
    let personalizations: [Personalization]
    let diagnostics: [String]
    let requestId: String
    
    struct Personalization: Decodable {
        let personalizationId: String
        let personalizationPointId: String
        let personalizationPointName: String
        let data: [String]
        let attributes: [String: String]
        let diagnostics: [String]
    }
}

final class EinsteinPersonalizationService{
    
    
    static let shared = EinsteinPersonalizationService()
    private let logger = DataCloudLoggingService.shared
    private init() {}
    
    func fetchNotifications(
        token: TokenResponse.Token,
        individualId: String,
        decisionId: String //Added parameter to be passed from productcarview
    ) -> AnyPublisher<PersonalizationResponse, Error> {
        let endpoint = "https://\(token.instanceUrl)/personalization/authenticated/decisions"
        
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let individualId = "0B803C90-8BCC-4821-AE1C-EBC1387B4EC2"
        logger.debug("Individual Id \(individualId)")
        logger.debug("token \(token)")
        logger.debug("instance url \(token.instanceUrl)")
        logger.debug("decisioin id \(decisionId)")

        
        
        
        // Match the exact request structure from cURL
        let request = PersonalizationRequest(
            context: .init(
                individualId: individualId,
                unifiedIndividualId: "",
                dataspace: "default",
                anchorId: "",
                anchorType: "",
                correlationId: "",
                messageId: "",
                requestUrl: ""
            ),
            personalizationPoints: [
                .init(
                    id: "",
                    name: "Mobile_App_Header",
                    decisionId: decisionId
                )
            ],
            profile: [:],
            executionFlags: ["TestMode"]
        )
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(request) else {
            return Fail(error: URLError(.cannotParseResponse)).eraseToAnyPublisher()
        }
        
        urlRequest.httpBody = data
        // Add debug logging for request payload
        if let requestString = String(data: data, encoding: .utf8) {
            logger.debug("Request payload: \(requestString)")
        }
        

        
        return URLSession.shared
                    .dataTaskPublisher(for: urlRequest)
                    .map(\.data)
                    .handleEvents(receiveOutput: { [weak self] data in
                        // Add debug logging for raw response
                        if let responseString = String(data: data, encoding: .utf8) {
                            self?.logger.debug("Raw response: \(responseString)")
                        }
                    })
                    .decode(type: PersonalizationResponse.self, decoder: JSONDecoder())
                    .handleEvents(
                        receiveOutput: { [weak self] response in
                            self?.logger.debug("Personalization response: \(response)")
                        },
                        receiveCompletion: { [weak self] completion in
                            if case .failure(let error) = completion {
                                self?.logger.debug("Personalization error: \(error)")
                            }
                        }
                    )
                    .receive(on: DispatchQueue.main)
                    .eraseToAnyPublisher()
        
    }
}
