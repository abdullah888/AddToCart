//
//  Home.swift
//  AddToCart
//
//  Created by abdullah on 07/04/1443 AH.
//

import SwiftUI
import Firebase

struct Home: View {
    
    
    
    
    
    var white = Color.white.opacity(0.85)
    @StateObject var ProductData = ProductViewModel()

    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    
    var body: some View {
      
        NavigationView{
            VStack{
                HStack{
                   
                    NavigationLink(destination: Basket()) {
                        Image(systemName: "cart.fill")
                            .font(.title)
                            .foregroundColor(white)
                            .padding()
                    }
                    Spacer()
                
                   
                    
                    NavigationLink(destination: AddProduct( updateId: $ProductData.updateId)) {
                        Text("اضافة منتج")
                            .font(.title)
                            .foregroundColor(white)
                            .padding()
                    }
                }
                .padding()
                VStack{
                    if ProductData.products.isEmpty{
                        
                        Spacer(minLength: 0)
                        
                        if ProductData.noProdcuts{
                            Image("crying")
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                         
                        }
                        else{
                            
                            ProgressView()
                        }
                        
                       
                    } else{
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            VStack(spacing: 25){
                                ForEach(ProductData.products){product in
                                    ProductRow(product: product, ProductData: ProductData)
                                 
                                  
                                }
                            }
                            .padding()
                            .padding(.horizontal,4)
                        }
    
                    }
                }
                Spacer()
            }.navigationBarHidden(true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("bg").ignoresSafeArea())
                
            
        }
        
        .fullScreenCover(isPresented: $ProductData.newProdcut) {
            AddProduct(updateId: $ProductData.updateId)
            
        }
        
    }
    
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
