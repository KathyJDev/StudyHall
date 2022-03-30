//
//  MenuButton.swift
//  StudyHall v2
//
//  Created by Kathryn Jerez on 12/20/21.
//

import SwiftUI

struct MenuButton: View {
    
    var name: String
    var image: String
    @Binding var selectedMenu: String
    
    var animation: Namespace.ID
    
    var body: some View {
        
        Button(action: {
            withAnimation(.spring()){
                selectedMenu = name
            }
        }, label: {
            
            HStack(spacing: 15){
                
                Image(systemName: image)
                    .font(.title2)
                    .foregroundColor(selectedMenu == name ? Color("orange") : Color("lightorange"))
                
            }
            .padding(.horizontal)
            .padding(.vertical, 15)
            .background(
                
                ZStack{
                    if selectedMenu == name{
                        Color(.white)
                            .cornerRadius(25)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                    else{
                        Color.clear
                    }
                }
            )
        })
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
