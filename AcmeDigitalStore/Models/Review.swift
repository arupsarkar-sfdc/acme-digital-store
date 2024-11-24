//
//  Review.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/24/24.
//

// ReviewModels.swift
import Foundation

enum ReviewCategory: String, Codable, CaseIterable {
    case product = "product"
    case purchase = "purchase"
    case customerService = "customer_service"
    case generalHelp = "general_help"
}

// Add proper Codable conformance
struct ReviewPayload: Encodable, Decodable {
    let data: [CustomerReview]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct CustomerReview: Encodable, Decodable {
    let category: String
    let review_date_time: String
    let data_source: String
    let data_source_object: String
    let device_id: String
    let device_type: String
    let internal_org: String
    let rating: Int
    let feedback: String
    let review_id: String
    let unified_individual_id: String
    
    enum CodingKeys: String, CodingKey {
        case category
        case review_date_time
        case data_source
        case data_source_object
        case device_id
        case device_type
        case internal_org
        case rating
        case feedback
        case review_id
        case unified_individual_id
    }
}
