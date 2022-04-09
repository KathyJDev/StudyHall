//
//  Home.swift
//  StudyHall v2
//
//  Created by Kathryn Jerez on 12/20/21.
//

import SwiftUI
import SDWebImageSwiftUI


struct Home: View {
    
    @State var showSidebar: Bool = false
    @StateObject var menuData = MenuViewModel()
    @Namespace var animation
    
    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        
        let persistenceController = PersistenceController.shared
        
            SideBarStack(sidebarWidth: 125, showSidebar: $showSidebar) {
                
                VStack(alignment: .leading){
                    Group{
                        MenuButton(name: "HomeView", image: "house.fill", selectedMenu: $menuData.selectedMenu, animation: animation)
                        
                        MenuButton(name: "File", image: "wallet.pass.fill", selectedMenu: $menuData.selectedMenu, animation: animation)
                        
                        MenuButton(name: "Settings", image: "gearshape.fill", selectedMenu: $menuData.selectedMenu, animation: animation)
                        }
                    .padding(.leading)
                    .padding(.top, 30)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor(named: "tan")!))
                .edgesIgnoringSafeArea(.all)
                
            }
        
            content: {
                NavigationView{
                VStack{

                    TabView(selection: $menuData.selectedMenu){
                        
                        HomeView()
                            .tag("HomeView")
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        
                        File()
                            .tag("File")
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        
                        Settings()
                            .tag("Settings")
                        
                        }
                    
                }.navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                    HStack{
                        Button(action: {
                            withAnimation {
                                self.showSidebar = true
                            }
                                                    
                            }, label: {
                                Image("menu")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.black)
                                    .padding(.leading, 1)
                            })
                        Spacer()
                    })
                    
                }
            }
            .environmentObject(menuData)
            
                
            }
        }
    
struct Home_Previews: PreviewProvider {
    
    static var previews: some View {
        Home()
    }
}

struct HomeView: View{
    
    @State var currentDate: Date = Date()
    @State var username = ""
    @State var descriptions = ""
    //@State var assignCompleted = false
    //@State var assignDate = Date()
    @State var assignName = ""
    //@ObservedObject var assign : Assignments
   // @StateObject var developers : Developer
    @Environment(\.managedObjectContext) var moc
    @Environment(\.editMode) var editButton
    
    @State var currentClass : Developer?
    
    @State var showAssignmentView: Bool = false
    
    @FetchRequest(entity: Developer.entity(), sortDescriptors:
        [NSSortDescriptor(keyPath: \Developer.username, ascending: true),
        NSSortDescriptor(keyPath: \Developer.descriptions, ascending: true),
        NSSortDescriptor(keyPath: \Developer.imageD, ascending: true)
        ]) var developers : FetchedResults<Developer>
    
    
    @FetchRequest(sortDescriptors:
         [NSSortDescriptor(keyPath: \Assignments.assignName, ascending: true),
         NSSortDescriptor(keyPath: \Assignments.assignDate, ascending: true),
         NSSortDescriptor(keyPath: \Assignments.assignCompleted, ascending: true),
          NSSortDescriptor(keyPath: \Assignments.assignid, ascending: true)
         ]) private var assignment : FetchedResults<Assignments>
    
   // var tasks : [Assignments]
    @State var selectedTab = 0
    @State var show: Bool = false
    
    
    // Checking dates
    func isSameDay(date1: Date, date2: Date)->Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func getDateFormatString(date:Date) -> String
    {
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM. dd"
        
        dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func delete(at offsets: IndexSet) {
        
        for index in offsets {
            let assignment = assignment[index]
            self.moc.delete(assignment)
        }
        try? self.moc.save()
    }
    
    var body: some View {
        
                VStack{
                    
                    CustomDatePicker(currentDate: $currentDate)
                        .padding()
                        .background(Color(UIColor(named: "tan")!))
                        .cornerRadius(20)
                        .frame(maxWidth: 350)
                    
                    HStack{
                    
                        Text("Due this Week")
                            .font(Font.custom(FontNameManager.Montserrat.bold, size: 18))
                            .padding()
                        Spacer(minLength: 0)
                        
                        EditButton()
                            .foregroundColor(Color("orange"))
                            .font(Font.custom(FontNameManager.Montserrat.semibold, size: 15))
                            .padding()
                        
                    }
                    VStack{
                        if let currentClass = currentClass, showAssignmentView {
                            if (currentClass.assignmentArray.first(where: { task in
                            return isSameDay(date1: task.assignDate ?? Date(), date2: currentDate)
                        }) != nil) {
                            List{
                                ForEach(currentClass.assignmentArray) {assign in
                                VStack {
                                    HStack {
                                        Button(action : {
                                            
                                            assign.assignCompleted.toggle()
                                            
                                            try? moc.save()
                                            
                                        }){
                                            if assign.assignCompleted {
                                            Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(Color("orange"))
                                                    .font(.title2)
                                                    
                                            }
                                            else {
                                                Image(systemName: "circle")
                                                    .foregroundColor(Color("lightorange"))
                                                    .font(.title2)
                                                    
                                                    
                                            }
                                        }
                                        .padding(4)
                                    VStack (alignment: .leading, spacing: 2){
                                       // Text("\(assign.assignName ?? "")")
                                        Text(assign.unwrappedName)
                                        .font(Font.custom(FontNameManager.Montserrat.bold, size: 18))
                                        .foregroundColor(Color("dark"))
                                        .padding([.leading, .trailing], 1)
                                        
                                        if assign.assignCompleted {
                                            Text("Completed")
                                                .font(Font.custom(FontNameManager.Montserrat.bold, size: 12))
                                                .foregroundColor(Color("burntorange"))
                                                .frame(width: 95, height: 20)
                                                .background(Color("lightorange"))
                                                .cornerRadius(4)
                                        }
                                        
                                        else if currentDate > assign.assignDate ?? Date() {
                                            Text("Late")
                                                .font(Font.custom(FontNameManager.Montserrat.semibold, size: 12))
                                                .foregroundColor(.white)
                                                .frame(width: 95, height: 18)
                                                .background(Color("lightbrown"))
                                                .cornerRadius(4)
                                                
                                        }
                                        
                                        else {
                                            let diffs = Calendar.current.dateComponents([.day], from: currentDate, to: assign.assignDate ?? Date())
                                            
                                            Text("\(diffs.day!) days left")
                                                .font(Font.custom(FontNameManager.Montserrat.semibold, size: 12))
                                                .foregroundColor(Color("burntorange"))
                                                .frame(width: 95, height: 20)
                                                .background(Color("lightorange"))
                                                .cornerRadius(4)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Text(getDateFormatString(date: assign.assignDate ?? Date()))
                                        .font(Font.custom(FontNameManager.Montserrat.medium, size: 12))
                                        .padding()
                                        }
                                }.listRowSeparator(.hidden)
                            
                                }.onDelete(perform: delete)
                            
                            }.listStyle(InsetListStyle())
                        }
                        }
                        else if (assignment.first(where: { task in
                            return isSameDay(date1: currentDate, date2: task.assignDate ?? Date())
                        }) != nil) {
                            List{
                                ForEach(assignment) {assign in
                                VStack {
                                    HStack {
                                        Button(action : {
                                            
                                            assign.assignCompleted.toggle()
                                            
                                            try? moc.save()
                                            
                                        }){
                                            if assign.assignCompleted {
                                            Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(Color("orange"))
                                                    .font(.title2)
                                                    
                                            }
                                            else {
                                                Image(systemName: "circle")
                                                    .foregroundColor(Color("lightorange"))
                                                    .font(.title2)
                                                    
                                                    
                                            }
                                        }
                                        .padding(4)
                                    VStack (alignment: .leading, spacing: 2){
                                       // Text("\(assign.assignName ?? "")")
                                        Text(assign.unwrappedName)
                                        .font(Font.custom(FontNameManager.Montserrat.bold, size: 18))
                                        .foregroundColor(Color("dark"))
                                        .padding([.leading, .trailing], 1)
                                        
                                        if assign.assignCompleted {
                                            Text("Completed")
                                                .font(Font.custom(FontNameManager.Montserrat.bold, size: 12))
                                                .foregroundColor(Color("burntorange"))
                                                .frame(width: 95, height: 20)
                                                .background(Color("lightorange"))
                                                .cornerRadius(4)
                                        }
                                        
                                        else if currentDate > assign.assignDate ?? Date() {
                                            Text("Late")
                                                .font(Font.custom(FontNameManager.Montserrat.semibold, size: 12))
                                                .foregroundColor(.white)
                                                .frame(width: 95, height: 18)
                                                .background(Color("lightbrown"))
                                                .cornerRadius(4)
                                                
                                        }
                                        
                                        else {
                                            let diffs = Calendar.current.dateComponents([.day], from: currentDate, to: assign.assignDate ?? Date())
                                            
                                            Text("\(diffs.day!) days left")
                                                .font(Font.custom(FontNameManager.Montserrat.semibold, size: 12))
                                                .foregroundColor(Color("burntorange"))
                                                .frame(width: 95, height: 20)
                                                .background(Color("lightorange"))
                                                .cornerRadius(4)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Text(getDateFormatString(date: assign.assignDate ?? Date()))
                                        .font(Font.custom(FontNameManager.Montserrat.medium, size: 12))
                                        .padding()
                                        }
                                }.listRowSeparator(.hidden)
                            
                                }.onDelete(perform: delete)
                            
                            }.listStyle(InsetListStyle())
                        }
                        else{
                            Text("No Assignments Found!")
                                .font(Font.custom(FontNameManager.Montserrat.bold, size: 15))
                                .foregroundColor(Color("burntorange"))
                        }
                        Spacer()
                    }
                    
                    
                    VStack{
                        
                        HStack{
                            
                            Text("Classes")
                                .font(Font.custom(FontNameManager.Montserrat.bold, size: 18))
                                .padding()
                           
                            Spacer(minLength: 0)
                            
                        }
                        ScrollView(.horizontal, showsIndicators: false){
                        VStack{

                        HStack{
                            ForEach(developers) { dev in
                                HomeTabs(developers: dev)
                                    .padding(.leading, 20)
                                    .onTapGesture {
                                        withAnimation(
                                            .easeInOut(duration: 0.35)){
                                                currentClass = dev
                                                showAssignmentView.toggle()
                                                show.toggle()
                                            }
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                }.edgesIgnoringSafeArea(.all)
            }
        }
    }

