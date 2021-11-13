//
//  ProductRow.swift
//  AddToCart
//
//  Created by abdullah on 07/04/1443 AH.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct ProductRow: View {
    var product : Product
    @ObservedObject var ProductData : ProductViewModel
   
   // let uid = Auth.auth().currentUser!.uid
    var white = Color.white.opacity(0.85)
  
    func Header(title: String) -> HStack<TupleView<(Text, Spacer)>> {
        return // since both are same so were going to make it as reuable...
            HStack{
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(white)
                
                Spacer()
            }
    }
    var body: some View {
        NavigationLink(destination: ProductDetail(product: product, ProductData: ProductData)) {
        VStack(spacing: 35){
            if product.product_image != "" {
                WebImage(url: URL(string: product.product_image!)!)
                .resizable()
                .scaledToFill()
                .frame(width: 350, height: 220)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(20)
            
            HStack{
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text(product.product_name!)
                        .foregroundColor(white)
                    Text("\(product.product_price!, specifier: "%.2f")")

                
                        .fontWeight(.bold)
                        .foregroundColor(white)
                }
                
                Spacer(minLength: 0)
                VStack{
                Text(product.product_details!)
                        .foregroundColor(white)
                
                Text(product.product_ratings!)
                    .fontWeight(.bold)
                    .foregroundColor(white)
               
                }
            }
            .padding(.horizontal)
           }
        }
        
        .padding(.bottom)
        .background(
            
            LinearGradient(gradient: .init(colors: [Color.white.opacity(0.1),Color.black.opacity(0.35)]), startPoint: .top, endPoint: .bottom)
                .cornerRadius(25)
                .padding(.top,55))
             
          }.navigationBarHidden(true)
        .frame(width: 380, height: 330)
    }
}


