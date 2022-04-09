//
//  SenderView.swift
//  StudyHall v2
//
//  Created by Kathryn Jerez on 12/21/21.
//

import SwiftUI
import SymbolPicker
import CoreData

struct SenderView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presen
    
    @State var username = ""
    @State var descriptions = ""
    @State var userid = UUID()
    @State var image : Data = .init(count: 0)
    @State var show = false
    @State var showAlert = false
    @State var icon = "photo"
    @State var iconPickerPresented = false
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 14) {
                
            if icon != "photo", image.count == 0 {
                Button(action: {
                    showAlert.toggle()
                }){
                    ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 85, height: 85)
                        .foregroundColor(Color("tan"))
                        .padding(.bottom, 50)
                    Image(systemName: icon)
                        .foregroundColor(Color("lightorange"))
                        .font(.system(size: 28))
                        .padding(.bottom, 45)
                        }
                    }
                
                }
                
               else if image.count != 0 {
                    Button(action: {
                        showAlert.toggle()
                    }) {
                    Image(uiImage: UIImage(data: self.image)!)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 85, height: 85)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.bottom, 50)
                        
                    }
                    
                } else {
                    Button(action: {
                        showAlert.toggle()
                    }) {
                        ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 85, height: 85)
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 50)
                        Image(systemName: "photo")
                            .foregroundColor(Color.white)
                            .font(.system(size: 28))
                            .padding(.bottom, 45)
                            
                        }
                    }
                }
                TextField("Class Name...",text: $username)
                    .padding()
                    .background(Color("tan"))
                    .cornerRadius(5)
                    .font(Font.custom(FontNameManager.Montserrat.semibold, size: 15))
                    .padding(.bottom, 20)
                TextField("Description...",text: $descriptions)
                    .padding()
                    .background(Color("tan"))
                    .cornerRadius(5)
                    .font(Font.custom(FontNameManager.Montserrat.semibold, size: 15))
                    .padding(.bottom, 20)
                
                Button(action: {
                    let send = Developer(context: moc)
                    send.username = username
                    send.descriptions = descriptions
                    send.imageD = image
                    send.userid = userid
                    send.icon = icon
                    
                    try? moc.save()
                    
                    self.username = ""
                    self.descriptions = ""
                    self.icon = ""
                    self.image.count = 0
                    self.userid = UUID()
                    
                    
                    self.presen.wrappedValue.dismiss()
                    
                    
                }) {
                    Text("Add Class")
                        .font(Font.custom(FontNameManager.Montserrat.bold, size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color("orange"))
                        .cornerRadius(15)
                        
                }
            }.keyboardType(.default)
            .padding()
                .navigationBarItems(trailing: Button(action: {
                    presen.wrappedValue.dismiss()
                }) {
                    HStack{
                        
                        Text("Cancel")
                            .font(Font.custom(FontNameManager.Montserrat.semibold, size: 18))
                            .foregroundColor(Color("orange"))
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color("orange"))
                            
                    }
                })
        }
        .alert("Choose Library", isPresented: $showAlert){
            Button("Icon Library"){
                iconPickerPresented.toggle()
            }
            Button("Image Library"){
                self.show.toggle()
            }
        }
        .sheet(isPresented: self.$show, content: {
            ImagePicker(show: self.$show, image: self.$image)
        })
        .sheet(isPresented: $iconPickerPresented) {
            SymbolPicker(symbol: $icon)
        }
    }
}

struct SenderView_Previews: PreviewProvider {
    static var previews: some View {
        SenderView()
    }
}
