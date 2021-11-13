//
//  AddProduct.swift
//  AddToCart
//
//  Created by abdullah on 07/04/1443 AH.
//

import SwiftUI

struct AddProduct: View {
    @StateObject var newProductData = NewProductModel()
    @Environment(\.presentationMode) var present
    @State var color = Color.black.opacity(0.7)
    @State var product : Product!
    @State var picker = false
    @State var img_Data = Data(count: 0)
    @Binding var updateId : String
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    HStack(spacing: 15){
                        
                        Button(action: {
                            
                            self.updateId = ""
                            present.wrappedValue.dismiss()
                            
                        }) {
                            
                            Text("Cancel")
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                        }
                        
                        Spacer(minLength: 0)
                        
                        
                        
                        
                        if updateId == ""{
                            
                            // Only FOr New Posts....
                            Button(action: {newProductData.picker.toggle()}) {
                                
                                Image(systemName: "photo.fill")
                                    .font(.title)
                                    .foregroundColor(Color.black)
                            }
                        }
                        
                        Button(action: {
                            newProductData.product(updateId: updateId,present: present)
                            
                        }) {
                            
                            Text("Done")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.vertical,10)
                                .padding(.horizontal,25)
                                .foregroundColor(Color.black)
                                .clipShape(Capsule())
                        }
                        
                        
                    }
                    .padding()
                    
                    
                    VStack{
                        if newProductData.img_Data.count != 0{
                            Image(uiImage: UIImage(data: newProductData.img_Data)!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width - 30 , height: 180)
                            
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(20)
                                .padding()
                        } else {
                            
                            Image(systemName: "photo.fill")
                                .resizable()
                                .foregroundColor(Color.black)
                                .frame(width: UIScreen.main.bounds.width - 30 , height: 180)
                                .cornerRadius(20)
                                .padding()
                        }
                        VStack{
                            HStack{
                                TextField("Name", text: self.$newProductData.product_name)
                                    .autocapitalization(.none)
                                    .frame(width: 130, height: 30)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.newProductData.product_name != "" ? Color("Color") : self.color, lineWidth: 2))
                                
                                
                                
                                TextField("Price", text:self.$newProductData.product_price)
                                    .autocapitalization(.none)
                                    .frame(width: 130, height: 30)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.newProductData.product_price != "" ? Color("Color") : self.color, lineWidth: 2))
                                
                            }
                            
                            HStack{
                                TextField("Company", text: self.$newProductData.product_ratings)
                                    .autocapitalization(.none)
                                    .frame(width: 130, height: 30)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.newProductData.product_ratings != "" ? Color("Color") : self.color, lineWidth: 2))
                                
                                
                                TextField("Description", text: self.$newProductData.product_details)
                                    .autocapitalization(.none)
                                    .frame(width: 130, height: 30)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.newProductData.product_details != "" ? Color("Color") : self.color, lineWidth: 2))
                                
                            }
                            .padding()
                        }
                        
                    }
                    
                    
                    
                    Spacer()
                        .padding()
                    Spacer()
                }.sheet(isPresented: $newProductData.picker) {
                    ImagePicker(picker: $newProductData.picker, img_Data: $newProductData.img_Data)
                }
                
            }.navigationBarHidden(true)
            
            
        } .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
        
    }
    
}




