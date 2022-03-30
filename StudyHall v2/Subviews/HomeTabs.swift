//
//  HomeTabs.swift
//  StudyHall v2
//
//  Created by Kathryn Jerez on 3/11/22.
//

import SwiftUI

struct HomeTabs: View{
    
    @StateObject var developers = Developer()
    @State var image : Data = .init(count: 0)
    @State var selected = false
    
    var body: some View{
        VStack{
            if developers.icon != "photo", image.count == 0 {
                    ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 65, height: 65)
                        .foregroundColor(Color("tan"))
                    Image(systemName: developers.icon ?? "")
                        .foregroundColor(Color("lightorange"))
                        .font(.system(size: 28))
                        .padding()
                    }
                
                }
            else if developers.imageD != nil{
            Image(uiImage: UIImage(data: developers.imageD ?? self.image)!)
                .resizable()
              .frame(width: 65, height: 65)
              .clipShape(RoundedRectangle(cornerRadius: 20))
              .onTapGesture {
                  selected.toggle()
              }
            }
            else{
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 65, height: 65)
                    .foregroundColor(.gray)
                   // .onTapGesture {
                     //   self.selected.toggle()
                    //}
            }
            Text("\(developers.username ?? "")")
                .font(Font.custom(FontNameManager.Montserrat.bold, size: 18))
                .foregroundColor(Color.gray)

           // Text("\(developers.descriptions ?? "")")
             //   .font(Font.custom(FontNameManager.Montserrat.semibold, size: 15))
               // .foregroundColor(.gray)
            //if self.selected {
              //  Circle()
                //    .frame(width: 5, height: 5)
                  //  .foregroundColor(Color("orange"))
            //}
        
        }
        
    }
}

struct HomeTabs_Previews: PreviewProvider {
    static let persistenceController = PersistenceController.shared
    
    static var developers: Developer = {
                let context = persistenceController.container.viewContext
                let developers = Developer(context: context)
                developers.username = "Math"
                developers.descriptions = "Calculus"
                //developers.imageD = 0
                return developers
            }()
    static var previews: some View {
        HomeTabs(developers: developers)
    }
}
