//
//  Settings.swift
//  StudyHall v2
//
//  Created by Kathryn Jerez on 12/20/21.
//

import SwiftUI
import Foundation

struct Settings: View {
    
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollView(.vertical, showsIndicators: false){
                    NavigationLink(destination: EmptyView()){
                        HStack{
                            ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color("tan"))
                                .frame(width: 40, height: 40)
                                .padding(.leading, 20)
                            Image(systemName: "bell.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("orange"))
                                    .padding(.leading, 18)
                            }
                        
                            Text("Notifications")
                                .font(Font.custom(FontNameManager.Montserrat.bold, size: 18))
                                .foregroundColor(Color("dark"))
                                .padding()
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("orange"))
                                .padding()
                        }
                    }
                    NavigationLink(destination: EmptyView()){
                        HStack{
                            ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color("tan"))
                                .frame(width: 40, height: 40)
                                .padding(.leading, 20)
                            Image(systemName: "paintpalette.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("orange"))
                                    .padding(.leading, 18)
                            }
                        
                            Text("Appearance")
                                .font(Font.custom(FontNameManager.Montserrat.bold, size: 18))
                                .foregroundColor(Color("dark"))
                                .padding()
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("orange"))
                                .padding()
                        }
                    }
                    Divider()
                    NavigationLink(destination: EmptyView()){
                        HStack{
                            ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color("tan"))
                                .frame(width: 40, height: 40)
                                .padding(.leading, 20)
                            Image(systemName: "questionmark.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("orange"))
                                    .padding(.leading, 18)
                            }
                        
                            Text("Help")
                                .font(Font.custom(FontNameManager.Montserrat.bold, size: 18))
                                .foregroundColor(Color("dark"))
                                .padding()
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("orange"))
                                .padding()
                        }
                    }
                    NavigationLink(destination: EmptyView()){
                        HStack{
                            ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color("tan"))
                                .frame(width: 40, height: 40)
                                .padding(.leading, 20)
                            Image(systemName: "bell.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("orange"))
                                    .padding(.leading, 18)
                            }
                        
                            Text("About")
                                .font(Font.custom(FontNameManager.Montserrat.bold, size: 18))
                                .foregroundColor(Color("dark"))
                                .padding()
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("orange"))
                                .padding()
                        }
                    }
                }
                Spacer()
            }.navigationTitle("Settings")
        }
    }
}

struct Settings_Previews: PreviewProvider {
    
    
    static var previews: some View {
        Settings()
    }
}

struct Appearance: View{
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack{
            HStack{
                Text("Theme")
                    .font(Font.custom(FontNameManager.Montserrat.bold, size: 20))
                    .foregroundColor(Color("dark"))
                    .padding()
                Spacer()
            }
            Spacer()
            HStack{
            ForEach(0..<themeManager.themes.count){themeCount in
                Button(action: {
                    withAnimation{
                        themeManager.applyTheme(themeCount)
                        }
                    }, label: {
                    Circle()
                            .foregroundColor(themeManager.themes[themeCount].primaryColor)
                        .frame(width: 30, height: 30)
                    })
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle)
                .tint(.gray)
            }
            Spacer()
        }
    }
}

protocol Theme{
    var primaryColor: Color {get set}
    var secondaryColor: Color {get set}
    var thirdColor: Color {get set}
    var forthColor: Color {get set}
    var themeName: String {get set}
}

final class OrangeTheme: Theme{
    var primaryColor: Color = Color("orange")
    var secondaryColor: Color = Color("lightorange")
    var thirdColor: Color = Color("burntorange")
    var forthColor: Color = Color("lightbrown")
    var themeName: String = "Orange Theme"
}

final class RedTheme: Theme{
    var primaryColor: Color = Color("red")
    var secondaryColor: Color = Color("rose")
    var thirdColor: Color = Color("burntred")
    var forthColor: Color = Color("magenta")
    var themeName: String = "Red Theme"
}

class ThemeManager:ObservableObject{
    
    @AppStorage("selectedTheme") var themeSelected = 0
    
    static let shared = ThemeManager()
    public var themes:[Theme] = [OrangeTheme(),RedTheme()]
    @Published var selectedTheme:Theme = OrangeTheme()
    
    init(){
        getTheme()
    }
    
    public func applyTheme(_ theme:Int){
        self.selectedTheme = self.themes[theme]
        self.themeSelected = theme
    }
    
    func getTheme(){
        self.selectedTheme = self.themes[themeSelected]
    }
    
}
