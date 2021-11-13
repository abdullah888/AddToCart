//
//  ProductViewModel.swift
//  AddToCart
//
//  Created by abdullah on 07/04/1443 AH.
//

import SwiftUI
import Firebase

class ProductViewModel : ObservableObject{
    
    @Published var products : [Product] = []
    @Published var noProdcuts = false
    @Published var newProdcut = false
    @Published var updateId = ""
    let ref = Firestore.firestore()
    
    init() {
     
       getAllProduct()
        self.login()
    }
    
   
    
    
    func getAllProduct(){
     
        ref.collection("Prodcuts").addSnapshotListener { (snap, err) in
            guard let docs = snap else{
                self.noProdcuts = true
                return
                
            }
            
            if docs.documentChanges.isEmpty{
                
                self.noProdcuts = true
                return
            }
            
            docs.documentChanges.forEach { (doc) in
                
                // Checking If Doc Added...
                if doc.type == .added{
                    // Retreving And Appending...
                    let product_name = doc.document.data()["product_name"] as! String
                    let product_price = doc.document.data()["product_price"] as? Double
                  
                    let product_details = doc.document.data()["product_details"] as! String
                    let product_ratings = doc.document.data()["product_ratings"] as! String
                    let time = doc.document.data()["time"] as! Timestamp
                    let product_image = doc.document.data()["url"] as! String
                    
                    
                    // getting user Data...
                   
                
                        self.products.append(Product(id: doc.document.documentID, product_name: product_name, product_price: product_price, product_details: product_details, product_image: product_image, product_ratings: product_ratings, time: time.dateValue()))
                       
                        // Sorting All Model..
                        // you can also doi while reading docs...
                        self.products.sort { (p1, p2) -> Bool in
                            return p1.time! > p2.time!
                        
                    }
                }
                
                // removing post when deleted...
                
                if doc.type == .removed{
                    
                    let id = doc.document.documentID
                    
                    self.products.removeAll { (product) -> Bool in
                        return product.id == id
                    }
                }
                
                if doc.type == .modified{
                    
                    // firebase is firing modifed when a new doc writed
                    // I dont know Why may be its bug...
                    
                    print("Updated...")
                    // Updating Doc...
                    
                    let id = doc.document.documentID
                    let product_name = doc.document.data()["product_name"] as! String
                    let product_price = doc.document.data()["product_price"] as? Double
                   
                    let product_details = doc.document.data()["product_details"] as! String
                    let product_ratings = doc.document.data()["product_ratings"] as! String
                    let index = self.products.firstIndex { (product) -> Bool in
                        return product.id == id
                    } ?? -1
                    
                    // safe Check...
                    // since we have safe check so no worry
                    
                    if index != -1{
                        self.products[index].product_name = product_name
                        self.products[index].product_details = product_details
                        self.products[index].product_ratings = product_ratings
                        self.products[index].product_price = product_price
                        self.updateId = ""
                        
                    }
                }
            }
        }
    }
    
    // deleting Product...
    
    func deleteProduct(id: String){
        
        ref.collection("Prodcuts").document(id).delete { (err) in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
        }
    }
    
    func editProduct(id: String){
        
        updateId = id
        // Poping New Post Screen
        newProdcut.toggle()
    }
    
    func login(){
        
        Auth.auth().signInAnonymously { (res, err) in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            print("Success = \(res!.user.uid)")
            
            // After Logging in Fetching Data
            
//            self.fetchData()
        }
    }
}


