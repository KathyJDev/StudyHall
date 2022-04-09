//
//  FirstOnboard.swift
//  StudyHall
//
//  Created by Kathryn Jerez on 12/8/21.
//

import SwiftUI

struct FirstOnboard: View {
    
    @AppStorage("onboarding") var onboarding = true
    
    var screenSize: CGSize
    @State var offset: CGFloat = 0
    
    
    var body: some View {
        
        VStack{
            
            Button{
                
            } label : {
                Image(systemName: "doc")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color("orange"))
                    .frame(width: 30, height: 30)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            OffsetPageTabView(offset: $offset) {
                    
                    HStack(spacing: 0){
                        
                        ForEach(intros){intro in
                          
                            VStack{
                                
                                Image(intro.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: screenSize.height / 3)
                                
                                VStack(alignment: .leading, spacing: 20) {
                                    
                                    Text(intro.title)
                                        .font(.largeTitle.bold())
                                    Text(intro.description)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                }
                                .foregroundStyle(.black)
                                .padding(.top, 50)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .frame(width: screenSize.width)
                        }
                    }

            }
            
            HStack(alignment: .bottom){
                
                HStack(spacing: 12){
                    
                    ForEach(intros.indices,id: \.self){index in
                        
                        Capsule()
                            .fill(.black)
                            .frame(width: getIndex() == index ? 20 : 7, height: 7)
                            
                    }
                }
                .overlay(
                
                    Capsule()
                        .fill(.black)
                        .frame(width: 20, height: 7)
                        .offset(x: getIndicatorOffset())
                    
                    ,alignment: .leading
                )
                .offset(x: -10, y: -15)
                
                Spacer()
                
                
                    Button {
                        
                        let index = min(getIndex() + 1, intros.count - 1)
                        
                        offset = CGFloat(index) * screenSize.width
                        
                        
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(10)
                            .background(
                                intros[getIndex()].color,
                                in: Circle()
                            )
                    
                        Button {
                          onboarding = false
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.title2.bold())
                                .foregroundColor(.red)
                                .padding(10)
                                .background(
                                    intros[getIndex()].color,
                                    in: Circle()
                                )
                    }
                }
                
            }
            .padding()
            .offset(y: -20)
            .background(Color(.white))
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .animation(.easeInOut, value: getIndex())
    }
    
    func getIndicatorOffset()->CGFloat{
        
        let progress = offset / screenSize.width
        
        let maxWidth: CGFloat = 12 + 7
        
        return progress * maxWidth
    }
    
    func getIndex()->Int{
        
        let progress = round(offset / screenSize.width)
        
        let index = min(Int(progress), intros.count - 1)
        return index
    }
    
}

struct FirstOnboard_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
