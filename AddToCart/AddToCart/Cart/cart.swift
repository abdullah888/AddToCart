//
//  cart.swift
//  super1
//
//  Created by abdullah FH  on 10/03/1443 AH.
//

import Foundation
//order
struct cart : Identifiable {
    
    var id : String
    var name : String
    var quantity : NSNumber
    var price : Double?
    var image : String
    var totale_price : String?
}
