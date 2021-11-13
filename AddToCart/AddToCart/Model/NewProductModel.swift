//
//  NewProductModel.swift
//  AddToCart
//
//  Created by abdullah on 07/04/1443 AH.
//

import SwiftUI
import Firebase

class NewProductModel : ObservableObject{
    let ref = Firestore.firestore()
  //  @Published var postTxt = ""
    @Published  var product_name = ""
    @Published  var product_price = ""
    @Published  var product_details = ""
    @Published var product_ratings = ""
    // Image Picker...
    @Published var picker = false
    @Published var img_Data = Data(count: 0)
    
    // disabling all controls while posting...
    @Published var isProductsIN = false
    
    let uid = Auth.auth().currentUser!.uid
    
    func product(updateId: String,present : Binding<PresentationMode>){
        
        // Products Data...
        
        isProductsIN = true
        
        if updateId != ""{
            
            // Updating Data...
            
            ref.collection("Prodcuts").document(updateId).updateData([
                "product_name" : product_name,
                "product_price" :  Double(self.product_price) ?? 0.0,
                "product_details" : product_details,
                "product_ratings" : product_ratings,
                
            ]) { (err) in
                
                self.isProductsIN = false
                if err != nil{return}
                
                present.wrappedValue.dismiss()
            }
            
            return
        }
        
        if img_Data.count == 0{
            
            ref.collection("Prodcuts").document().setData([
                "product_name" : product_name,
                "product_price" : Double(self.product_price) ?? 0.0,
                "product_details" : product_details,
                "product_ratings" : product_ratings,
                "url": "",
                "time": Date()
                
            ]) { (err) in
                
                if err != nil{
                    self.isProductsIN = false
                    return
                }
                
                self.isProductsIN = false
                // closing View When Succssfuly Posted...
                present.wrappedValue.dismiss()
            }
        }
        else{
            
            UploadImage(imageData: img_Data, path: "Products_Image") { (url) in
                
                self.ref.collection("Prodcuts").document().setData([
                
                    "product_name" : self.product_name,
                    "product_price" : Double(self.product_price) ?? 0.0,
                    "product_details" : self.product_details,
                    "product_ratings" : self.product_ratings,
                    "url": url,
                    
                    "time": Date()
                    
                ]) { (err) in
                    
                    if err != nil{
                        self.isProductsIN = false
                        return
                    }
                    
                    self.isProductsIN = false
                    // closing View When Succssfuly Posted...
                    present.wrappedValue.dismiss()
                }
            }
        }
    }
}
