//
//  EngagementTrackingService.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/21/24.
//

import Foundation
import SFMCSDK
import Combine

final class EngagementTrackingService {
    static let shared = EngagementTrackingService()
    private let trackingSubject = PassthroughSubject<EngagementTrackingResult, Never>()
    
    private init() {}
    
    // MARK: - Public Interface
    var trackingPublisher: AnyPublisher<EngagementTrackingResult, Never> {
        trackingSubject.eraseToAnyPublisher()
    }
    
    func trackEvent(type: EngagementEventType, attributes: [String: Any]) {
        switch type {
        case .cart(let cartEventType):
            trackCartEvent(type: cartEventType, attributes: attributes)
        case .catalog(let catalogEventType): trackCatalogEvent(type: catalogEventType, attributes: attributes)
        case .custom(let eventName):
            trackCustomEvent(name: eventName, attributes: attributes)
        }
    }
    
    // MARK: - Private Methods
    private func trackCartEvent(type: CartEventType, attributes: [String: Any]) {
        guard let lineItem = createLineItem(from: attributes) else {
            trackingSubject.send(.failure(EngagementError.invalidAttributes))
            return
        }
        
        let event: Event
        switch type {
        case .addToCart:
            event = AddToCartEvent(lineItem: lineItem)
        case .removeFromCart:
            event = RemoveFromCartEvent(lineItem: lineItem)
        }
        
        SFMCSdk.track(event: event)
        trackingSubject.send(.success("Cart event tracked successfully"))
    }
    
    private func trackCustomEvent(name: String, attributes: [String: Any]) {
        guard let event = CustomEvent(name: name, attributes: attributes) else {
            trackingSubject.send(.failure(EngagementError.eventCreationFailed))
            return
        }
        
        SFMCSdk.track(event: event)
        trackingSubject.send(.success("Custom event tracked successfully"))
    }
    
    private func createLineItem(from attributes: [String: Any]) -> LineItem? {
        guard
            let catalogObjectId = attributes["catalogObjectId"] as? String,
            let price = attributes["price"] as? Double,
            let quantity = attributes["quantity"] as? Int,
            let currency = attributes["currency"] as? String
        else {
            return nil
        }
        
        return LineItem(
            catalogObjectType: "Product",
            catalogObjectId: catalogObjectId,
            quantity: quantity,
            price: NSDecimalNumber(value: price),
            currency: currency,
            attributes: attributes
        )
    }
    
    // MARK: - Private Methods
    private func trackCatalogEvent(type: CatalogEventType, attributes: [String: Any]) {
        guard let catalogObject = createCatalogObject(from: attributes) else {
            trackingSubject.send(.failure(EngagementError.invalidAttributes))
            return
        }
        
        let event: Event
        switch type {
        case .view:
            event = ViewCatalogObjectEvent(catalogObject: catalogObject)
        case .comment:
            event = CommentCatalogObjectEvent(catalogObject: catalogObject)
        }
        
        SFMCSdk.track(event: event)
        trackingSubject.send(.success("Catalog event tracked successfully"))
    }
    
    private func createCatalogObject(from attributes: [String: Any]) -> CatalogObject? {
        guard
            let id = attributes["catalogObjectId"] as? String,
            let type = attributes["type"] as? String
        else {
            return nil
        }
        
        // Filter out internal attributes to create clean catalog attributes
        var catalogAttributes = attributes
        catalogAttributes.removeValue(forKey: "catalogObjectId")
        catalogAttributes.removeValue(forKey: "type")
        
        // Create related catalog objects if available
        var relatedObjects: [String: [String]] = [:]
        if let sizes = attributes["sizes"] as? [String] {
            relatedObjects["size"] = sizes
        }
        if let skus = attributes["skus"] as? [String] {
            relatedObjects["sku"] = skus
        }
        
        return CatalogObject(
            type: type,
            id: id,
            attributes: catalogAttributes,
            relatedCatalogObjects: relatedObjects
        )
    }

}

// MARK: - Supporting Types
enum EngagementEventType {
    case cart(CartEventType)
    case catalog(CatalogEventType)
    case custom(String)
}

enum CartEventType {
    case addToCart
    case removeFromCart
}

enum CatalogEventType {
    case view
    case comment
}

enum EngagementTrackingResult {
    case success(String)
    case failure(Error)
}

enum EngagementError: Error {
    case invalidAttributes
    case eventCreationFailed
}
