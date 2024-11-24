//
//  ProfileService.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/23/24.
//

import Foundation
import Combine

// First, create proper response models matching the JSON structure
struct ProfileResponseWrapper: Codable {
    let data: [ProfileData]
    let done: Bool
}

// First, create proper response models matching the JSON structure
struct ProfileData: Codable {
    let birthDateYear: String?
    let locale: String?
    let primaryAccountNumber: String?
    let birthDate: String?
    let birthPlace: String?
    let createdDate: String?
    let currentEmployerName: String?
    let externalRecordId: String?
    let externalSourceId: String?
    let firstName: String?
    
    enum CodingKeys: String, CodingKey {
        case birthDateYear = "Birth_Date_Year__c"
        case locale = "Locale__c"
        case primaryAccountNumber = "Primary_Account_Number__c"
        case birthDate = "ssot__BirthDate__c"
        case birthPlace = "ssot__BirthPlace__c"
        case createdDate = "ssot__CreatedDate__c"
        case currentEmployerName = "ssot__CurrentEmployerName__c"
        case externalRecordId = "ssot__ExternalRecordId__c"
        case externalSourceId = "ssot__ExternalSourceId__c"
        case firstName = "ssot__FirstName__c"
    }
}

// Update ProfileService to use the new response type
final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    func fetchProfile(
        id: String,
        accessToken: String,
        instanceUrl: String
    ) -> AnyPublisher<ProfileResponseWrapper, Error> {
        let baseUrl = "https://\(instanceUrl)/api/v1/profile/UnifiedssotIndividualI1__dlm/\(id)"
        guard let url = URL(string: baseUrl) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ProfileResponseWrapper.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
