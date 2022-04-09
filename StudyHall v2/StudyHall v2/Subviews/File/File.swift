//
//  FileFix.swift
//  StudyHall v2
//
//  Created by Kathryn Jerez on 12/25/21.
//

import SwiftUI
import CoreData

struct File: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Developer.entity(), sortDescriptors:
        [NSSortDescriptor(keyPath: \Developer.username, ascending: true),
        NSSortDescriptor(keyPath: \Developer.descriptions, ascending: true),
        NSSortDescriptor(keyPath: \Developer.imageD, ascending: true),
         NSSortDescriptor(keyPath: \Developer.icon, ascending: true)
        ]) var developers : FetchedResults<Developer>
    
    
    @State public var image : Data = .init(count: 0)
    @State var showclass = false
    @State var delete = false
    @State var edit = false
    //@State var icon = ""
    @State private var animationAmount = 1.0
    var countDev: Int {
        developers
            .count
    }
    static let persistenceController = PersistenceController.shared
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Classes").font(Font.custom(FontNameManager.Montserrat.bold, size: 25))
                    
                    Spacer()
                    
                }
                .padding([.leading,.trailing], 15)
                .padding(.top, 10)
                HStack {
                    Text("\(countDev) classes")
                        .font(Font.custom(FontNameManager.Montserrat.semibold, size: 18))
                    
                    Spacer()
                }.padding([.leading, .trailing], 20)
                    
                Rectangle()
                    .foregroundColor(Color("lightorange"))
                    .frame(width: 5, height: 5, alignment: .center)
                
                ZStack{
                    
                    Color.white
                        .clipShape(CustomCorners(corners: [.topLeft, .topRight], size: 45))
                        .ignoresSafeArea(.all, edges: .bottom)
                
                    VStack {
                        Spacer()
                        HStack {
                            
                        Spacer()
                            Button(action: {
                                showclass.toggle()
                                
                            }) {
                                Image(systemName: "plus").resizable().frame(width: 25, height: 25).padding()
                            }.foregroundColor(.white)
                                .background(Color("orange"))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding()
                        }
                    }.zIndex(1)
                    
                ScrollView (.vertical, showsIndicators: false) {
                    ForEach(developers, id:\.self) { dev in
                        NavigationLink(destination:
                                        DetailsView(developers: dev).navigationBarBackButtonHidden(true).navigationBarHidden(true)){
                                       
                        
                                HStack (alignment: .center) {
                                    
                                    if dev.icon != "photo", image.count == 0 {
                                            ZStack{
                                            RoundedRectangle(cornerRadius: 20)
                                                .frame(width: 68, height: 68)
                                                .foregroundColor(Color("tan"))
                                                .padding(15)
                                            Image(systemName: dev.icon ?? "")
                                                .foregroundColor(Color("lightorange"))
                                                .font(.system(size: 28))
                                                .padding()
                                            }
                                        
                                        }
                                    
                                    else if dev.imageD != nil {
                                    Image(uiImage: UIImage(data: dev.imageD ?? self.image)!)
                                        .resizable()
                                        .frame(width: 68, height: 68)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .padding(15)
                                    }
                                    else {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 68, height: 68)
                                            .foregroundColor(.gray)
                                            .padding(15)
                                    }
                                
                                VStack (alignment: .leading) {
                                    Text("\(dev.username ?? "")")
                                        .font(Font.custom(FontNameManager.Montserrat.bold, size: 18))
                                        .foregroundColor(Color("dark"))
                                    
                                    Text("\(dev.descriptions ?? "")")
                                        .font(Font.custom(FontNameManager.Montserrat.semibold, size: 15))
                                        .foregroundColor(.gray)
                                    
                                }.padding()
                                        .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.white)                                .shadow(color: Color("tan"), radius: 10, x: 10, y: 5).frame(width: 230, height: 95), alignment: .leading)
                                    Spacer()
                                  Image(systemName: "chevron.right")
                                        .foregroundColor(Color("orange"))
                                        .padding()
                                
                                Spacer()
                                }
                            
                        }
                }
                .onDelete(perform: delete)
                .contextMenu {
                    Button (action: {
                        
                        edit.toggle()
                        
                    }) {
                        Label("Edit", systemImage: "square.and.pencil")
                    }
                    Button (action: {
                        
                        delete.toggle()
                        
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                    
                }
                .alert(isPresented: $delete) {
                    Alert(title: Text("Delete Class"), message: Text("This action cannot be undone."), primaryButton: .destructive(Text("Delete")) {
                        delete(at: IndexSet.init(arrayLiteral : 0))
                    }, secondaryButton: .cancel())
                }
                .frame(maxWidth: .infinity)
                .padding(.all, 10)
                .padding()
                    
                }.sheet(isPresented: $showclass) {
                    SenderView().environment(\.managedObjectContext, moc)
                }
                    
                }.animation(.easeInOut(duration: 2), value: animationAmount)
                
                
                    
            }.navigationBarHidden(true)
                .background(Color("lightorange"))
            
                
        }
    }
    
    func delete(at offsets: IndexSet) {
        
        for index in offsets {
            let developers = developers[index]
            moc.delete(developers)
        }
        try? moc.save()
    }
}

struct File_Previews: PreviewProvider {

    static var previews: some View {
        
        let persistenceController = PersistenceController.shared
        
        File().environment(\.managedObjectContext, persistenceController.container.viewContext)

    }
    
}

struct CustomCorners : Shape {
    
    var corners : UIRectCorner
    var size : CGFloat
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: size, height: size))
        
        return Path(path.cgPath)
    }
}

