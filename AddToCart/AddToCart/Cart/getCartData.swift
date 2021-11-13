//
//  getCartData.swift
//  super1
//
//  Created by abdullah FH  on 10/03/1443 AH.
//

import SwiftUI
import Firebase

class getCartData : ObservableObject{
  
    @Published var IsOdered = false
    @Published var datas = [cart]()
    
    init(){
        GetCatr()
    }
   func GetCatr() {
        
        let db = Firestore.firestore()
    
        db.collection("cart").addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
           
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    
                    let id = i.document.documentID
                    let name = i.document.get("Order_name") as! String
                    let quantity = i.document.get("Order_quantity") as! NSNumber
                    let price = i.document.get("Order_price") as? Double
                    let image = i.document.get("Order_Image") as! String

                    self.datas.append(cart(id: id, name: name, quantity: quantity, price: price, image: image))
                }
                
                if i.type == .modified{
                    
                    let id = i.document.documentID
                    let quantity = i.document.get("Order_quantity") as! NSNumber
                    
                    for j in 0..<self.datas.count{
                        
                        if self.datas[j].id == id{
                            
                            self.datas[j].quantity = quantity
                        }
                    }
                }
            }
        }
    }
    
    
    
    func calculateTotalPrice()->String{
        
        var price : Float = 0
        
        datas.forEach { (cartt) in
            price += Float(truncating: cartt.quantity) * Float(truncating: cartt.price! as NSNumber)
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
        for i in 0..<self.datas.count {
            self.datas[i].quantity = 0
        }
        self.datas.removeAll()
    }
}
    //باقي تجرب هل الطلبات تخص نفس المستخدم
    
    
    
    
    
    func addOrder(){
        let id = Auth.auth().currentUser?.uid
        datas.forEach { (Cart) in
  
                let db = Firestore.firestore()
                db.collection("Orders")
                    .document()
                    .setData(["Order_name":Cart.name,
                              "Order_quantity":Cart.quantity,
                              "Order_Price":Cart.price!,
                              "Order_image":Cart.image,
                              "total_Order_Price":calculateTotalPrice(),
                              "User_Id": id!,
                    ]) { (err) in
                        
                        if err != nil{
                            
                            print((err?.localizedDescription)!)
                            return
                        }
                    
                    }
            
       
        }
    }
    
    func Cech(){
        Auth.auth().addStateDidChangeListener { auth, user in
            if let userid = user?.uid{
                UserApi.GetUser(ID: userid) { User in
                    
                }
               
            }
        }
    }

    
    
    
}





