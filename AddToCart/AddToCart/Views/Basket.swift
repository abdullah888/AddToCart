//
//  Basket.swift
//  AddToCart
//
//  Created by abdullah on 07/04/1443 AH.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct Basket : View {
    
    

  

    @ObservedObject var cartdata = getCartData()
    @Environment(\.presentationMode) var presentationMode
    var white = Color.white.opacity(0.85)
    init() {
       UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor =  UIColor(Color("bg"))
       UITableView.appearance().backgroundColor = UIColor(Color("bg"))
    }
    func Header(title: String) -> HStack<TupleView<(Text, Spacer)>> {
        return
            HStack{
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(white)
                Spacer()
            }
    }
    var body : some View{
    NavigationView{
        VStack{
            ZStack{
                HStack{
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                       Image(systemName: "house.fill")
                            .font(.title)
                            .foregroundColor(white)
                    }
                    Spacer()
                    Button {
                        cartdata.reset()
                        cartdata.deleteCollection(collection: "cart")
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                       Image(systemName: "trash.fill")
                            .font(.title)
                            .foregroundColor(white)
                    }.disabled(cartdata.datas.isEmpty)
                    Spacer()
            
           
                    Button {
                        
                        
                        cartdata.addOrder()
                        cartdata.reset()
                        cartdata.deleteCollection(collection: "cart")
                            presentationMode.wrappedValue.dismiss()
                    } label: {
    Text(self.cartdata.datas.count != 0 ? "اتمام الطلب" : "لايوجد طلبات")
                            .font(.title)
                            .padding()
                            .foregroundColor(white)
                    }.disabled(cartdata.datas.isEmpty)
                    
                    
                    
                    
                }
            }
            .padding([.horizontal,.bottom])
            .padding(.top,10)
            Spacer()
            
        VStack(alignment: .leading){
         
            if self.cartdata.datas.count != 0{
                
                List{
                    
                    ForEach(self.cartdata.datas){i in
                        
                        HStack(spacing: 15){
                            
                            AnimatedImage(url: URL(string: i.image))
                                .resizable()
                                .frame(width: 150, height: 150)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading){
                                
                                HStack{
                                Text(i.name)
                                        .foregroundColor(white)
                                    Spacer()
                                Text("\(i.quantity)")
                                        .foregroundColor(white)
                                }
                                Text("\(i.price!, specifier: "%.2f")")
                                    .foregroundColor(white)
                                    .padding()
                            }
                        }.border(white, width: 0.1)
                        .onTapGesture {
                         
                            UIApplication.shared.windows.last?.rootViewController?.present(textFieldAlertView(id: i.id), animated: true, completion: nil)
                        }
                        
                    }
                    .onDelete { (index) in
                        
                        let db = Firestore.firestore()
                        db.collection("cart").document(self.cartdata.datas[index.last!].id).delete { (err) in
                            
                            if err != nil{
                                
                                print((err?.localizedDescription)!)
                                return
                            }
                            
                            self.cartdata.datas.remove(atOffsets: index)
                            
                        }
                    }.listRowBackground(Color("bg").ignoresSafeArea())
                    
                }
                
            }
            
        }
            VStack{
                HStack{
                    
                    Text("الدفع عند الاستلام")
                        .font(.title)
                        .foregroundColor(white)
                        .padding()
                    Text(cartdata.calculateTotalPrice())
                        .font(.headline)
                        .foregroundColor(white)
                        .padding()
                }

                Text("الموقع")
                    .font(.headline)
                    .foregroundColor(white)
                    .padding()
               
            }
            .padding([.horizontal,.bottom])
            .padding(.bottom,10)
                Spacer()
        
       }.navigationBarHidden(true)
        .accentColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("bg").ignoresSafeArea())
       }
     .navigationBarTitle("", displayMode: .inline)
     .navigationBarBackButtonHidden(true)
    }
}

struct Basket_Previews: PreviewProvider {
    static var previews: some View {
        Basket()
    }
}


func textFieldAlertView(id: String)->UIAlertController{
    
    let alert = UIAlertController(title: "Update", message: "Enter The Quantity", preferredStyle: .alert)
    
    alert.addTextField { (txt) in
        
        txt.placeholder = "Quantity"
        txt.keyboardType = .numberPad
    }
    
    let update = UIAlertAction(title: "Update", style: .default) { (_) in
        
        let db = Firestore.firestore()
        
        let value = alert.textFields![0].text!
            
        db.collection("cart").document(id).updateData(["Order_quantity":Int(value)!]) { (err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    
    alert.addAction(cancel)
    
    alert.addAction(update)
    
    return alert
}
