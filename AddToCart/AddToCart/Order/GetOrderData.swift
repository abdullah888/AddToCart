//
//  GetOrderData.swift
//  super1
//
//  Created by abdullah FH  on 18/03/1443 AH.
//

import SwiftUI
import Firebase

class GetOrderData : ObservableObject{
  
    @Published var IsOdered = false
    @Published var order = [Order]()
    
    init(){
        GetOrder()
    }
   func GetOrder() {
        
        let db = Firestore.firestore()
    
        db.collection("Orders").addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
           
            for i in snap!.documentChanges{
                
                if i.type == .added{
                  
                    let id = i.document.documentID
                    let Order_name = i.document.get("Order_name") as! String
                    let Order_quantity = i.document.get("Order_quantity") as! NSNumber
                    let Order_price = i.document.get("Order_price") as? Double
                    let total_Order_Price = i.document.get("total_Order_Price") as! String
                    let Order_Image = i.document.get("Order_image") as! String
                    self.order.append(Order(id: id, Order_name: Order_name, Order_quantity: Order_quantity, Order_price:Order_price,Order_Image: Order_Image, total_Order_Price: total_Order_Price))
               
                }
                
                if i.type == .modified{
                    
                    let id = i.document.documentID
                    let Order_quantity = i.document.get("Order_quantity") as! NSNumber
                    
                    for j in 0..<self.order.count{
                        
                        if self.order[j].id == id{
                            
                            self.order[j].Order_quantity = Order_quantity
                        }
                    }
                }
            }
        }
    }
    func calculateTotalPrice()->String{
        
        var price : Float = 0
        
        order.forEach { (orderr) in
            price += Float(truncating: orderr.Order_quantity) * Float(truncating: orderr.Order_price! as NSNumber)
        }
        
        return getPrice(value: price)
    }
    
    func getPrice(value: Float)->String{
        
        let format = NumberFormatter()
        format.numberStyle = .currency
        format.currencySymbol = "SR"
        return format.string(from: NSNumber(value: value)) ?? ""
    }
    
    //???
    func deleteCollection(collection: String) {
      
        let db = Firestore.firestore()
           db.collection(collection).getDocuments() { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
                   return
               }

               for document in querySnapshot!.documents {
                   
                   print("Deleting \(document.documentID) => \(document.data())")
                   document.reference.delete()
               }
           }
       }
   
    func reset() {
    DispatchQueue.main.async {
        for i in 0..<self.order.count {
            self.order[i].Order_quantity = 0
        }
        self.order.removeAll()
    }
}
 
    
    
    
}
    
    
    
    
