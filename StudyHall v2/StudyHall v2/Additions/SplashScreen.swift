//
//  SplashScreen.swift
//  StudyHall v2
//
//  Created by Kathryn Jerez on 12/20/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SplashScreen: View {
    
    @AppStorage("onboarding") var onboarding = true
    @State var animationFinished: Bool = false
    @State var animationStarted: Bool = false
    @State var removeGIF = false
    
    var body: some View {
        
        ZStack{
            
            if onboarding {
                GeometryReader{proxy in
                    
                    let size = proxy.size
                    
                    FirstOnboard(screenSize: size)
                    
                }
                
            } else {
                Home()
            }
        
            ZStack{
                
                Color("lightorange")
                    .ignoresSafeArea()
                
                if !removeGIF{
                
                ZStack{
                    
                    if animationStarted{
                        
                        if animationFinished{
                            
                            Image("logo")
                                
                        }
                        else{
                            AnimatedImage(url: getLogoURL())
                                .aspectRatio(contentMode: .fit)
                        
                        }
                    }
                    else{
                        
                        Image("logoStarting")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        }
                    }
                    .animation(.none, value: animationFinished)
                }
            }
            .opacity(animationFinished ? 0 : 1)
        }
        .onAppear{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                
                animationStarted = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    
                    withAnimation(.easeInOut(duration: 0.9)){
                        animationFinished = true
                        
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        removeGIF = true
                    }
                }
            }
        }
    }
    
    func getLogoURL()->URL{
        let bundle = Bundle.main.path(forResource: "logo", ofType: "gif")
        let url = URL(fileURLWithPath: bundle ?? "")
        
        return url
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
