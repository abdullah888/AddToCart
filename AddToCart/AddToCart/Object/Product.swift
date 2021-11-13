//
//  Product.swift
//  AddToCart
//
//  Created by abdullah on 07/04/1443 AH.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Product: Identifiable {
    
    var id: String?
    var product_name: String?
    var product_price: Double?
    var product_Quantitiy : Int?
    var product_details: String?
    var product_image: String?
    var product_ratings: String?
    var time : Date?
    var user: UserModel?
    // to identify whether it is added to cart...
    var isAdded: Bool = false

}

