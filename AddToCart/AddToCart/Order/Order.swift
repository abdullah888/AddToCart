//
//  Order.swift
//  myownshop
//
//  Created by abdullah FH  on 10/02/1443 AH.
//

import SwiftUI

struct Order : Identifiable {
    
    var id : String
    var Order_name : String
    var Order_quantity : NSNumber
    var Order_price : Double?
    var Order_Image : String
    var total_Order_Price : String
}
