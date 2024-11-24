//
//  ReviewService.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/23/24.
//

import Foundation
import Combine

final class ReviewService {
    static let shared = ReviewService()
    let logger = DataCloudLoggingService.shared
    private init() {}
    
    func submitReview(
        _ payload: ReviewPayload,
        token: TokenResponse.Token
    ) -> AnyPublisher<Void, Error> {
        let endpoint = "https://\(token.instanceUrl)/api/v1/ingest/sources/customer_reviews/customer_reviews"
        
        logger.debug("\(token.accessToken)")
        logger.debug("\(token.instanceUrl)")
        
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(payload) else {
            return Fail(error: URLError(.cannotParseResponse)).eraseToAnyPublisher()
        }
        
        request.httpBody = data
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map { _ in () }
            .mapError { $0 as Error }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
