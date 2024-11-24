//
//  CartItem.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//

import Foundation

struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
}
