//
//  ProductDetail.swift
//  AddToCart
//
//  Created by abdullah on 07/04/1443 AH.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI


struct ProductDetail: View {
    
   
    @State private var offset: CGFloat = .zero
    var product : Product
    @ObservedObject var ProductData : ProductViewModel
    @State var Counter : Int = 1
    @State var IsOdered = false
    @State var height = UIScreen.main.bounds.height
 
    @Environment(\.presentationMode) var presentationMode
   
    var white = Color.white.opacity(0.85)
    var body: some View{
        
        ZStack{
            
            Color("bg").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0){
                
        if product.product_image != "" {
            
            WebImage(url: URL(string: product.product_image!)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 450)
                    .background(Color.black)
               
                    .edgesIgnoringSafeArea(.all)
                    .overlay(ImageOverlay(), alignment: .topTrailing)
          
          
                ZStack(alignment: .topTrailing) {
                    
                    if self.height > 750 {
                        
                        VStack{
                          //
                            
                            VStack{
                                VStack(alignment: .leading){
                                    Text(product.product_name!)
                                        .font(.title)
                                        .fontWeight(.bold)
                                    
                                    Text("السعر كامل : \(product.product_price!, specifier: "%.2f") ريال")
                                        .foregroundColor(.secondary)
                                }
                                .padding(.top)
                                .frame(maxWidth: .infinity, alignment: .leading)
                              
                                Text("بالهناء والعافية")
                                    .font(.title)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                                Text(product.product_details!)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                                    .padding()
                              
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(30)

                        }
                        .padding(.bottom, 40)
                        .padding(.horizontal,20)
                        .background(CustomShape().fill(Color.white))
                        .clipShape(Corners())
                    }
                        
                    VStack(spacing : 15){
                        
                        Button(action: {
                        
                      
                            self.Counter += 1
                            
                        }) {
                            
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color("bg"))
                                .font(.title)
                        }
                        
                        Text("\(self.Counter)")
                        .foregroundColor(white)
                        .padding(10)
                        .background(Color.black)
                        .clipShape(Circle())
                        
                        Button(action: {
                            
                            if self.Counter != 0{
                                self.Counter -= 1
                              
                            }
                            
                        }) {
                            
                            Image(systemName: "minus.circle")
                                .foregroundColor(Color("bg"))
                                .font(.title)
                        }
                    }
                    .padding()
                    .background(white)
                    .cornerRadius(10)
                    .shadow(radius: 4)
                    .padding(.trailing,25)
                    .offset(y: -55)
                }
                .zIndex(40)
                .offset(y: -40)
                .padding(.bottom, -40)
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 15) {
                        
                        Text("عدد الوجبات")
                            .fontWeight(.bold)
                        
                        HStack(spacing : 18){
                            
                            VStack(spacing: 8){
                                
                                Text("\(self.Counter)")
                                    .fontWeight(.bold)
                                    .padding()
                               
                            }
                          
                        }
                    }
                    .foregroundColor(white)
                    .padding(.leading, 20)
                    
                    Spacer(minLength: 0)
                    
                    VStack {
                        
                        VStack{
                            Button(action: {
                              
                                addtoCart()
                                
                             
                            }, label: {
                               Text("انتهى")
                                    .fontWeight(.bold)
                            })
                        }
                        .foregroundColor(white)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 25)
                        .background(Color("bg"))
                        .cornerRadius(15)
                        .shadow(radius: 8)
                    }
                    .padding(.trailing, 25)
                    .offset(y: -55)
                }
                .zIndex(40)
                .padding(.bottom, 10)
              }
                
            }
            .edgesIgnoringSafeArea(.top)
            .animation(.default, value: offset)
          
        }.navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    func addtoCart(){
     
        let db = Firestore.firestore()
        db.collection("cart")
            .document()
            .setData(["Order_name":product.product_name!,
                      "Order_quantity":Counter,
                      "Order_price":product.product_price!,
                      "Order_Image":product.product_image!,
                   
                      
            ]) { (err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
                
                // it will dismiss the recently presented modal....
                
                presentationMode.wrappedValue.dismiss()
            
        }
    }
 
}


struct CustomShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in

            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height - 40))
            
        }
    }
}

struct Corners : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 35, height: 35))
        
        return Path(path.cgPath)
    }
}

class Host: UIHostingController<ContentView> {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool{
        
        return true
    }
}


struct ImageOverlay: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
   
           Image(systemName: "x.circle.fill")
                .font(.largeTitle)
                .foregroundColor(Color.red)
                .padding(50)
        }

    }
}


