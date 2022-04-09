//
//  DetailsView.swift
//  StudyHall v2
//
//  Created by Kathryn Jerez on 1/7/22.
//

import SwiftUI
import Foundation
import CoreData

struct DetailsView: View {
    
    
    @StateObject var developers : Developer
    
    @Environment(\.presentationMode) var presen
    @Environment(\.editMode) var editButton
    @Environment(\.managedObjectContext) var moc
    
    @State var show = false
    @State var showSearch = false
    @State var txt = ""
    @State var currentDate: Date = Date()
    @State var image : Data = .init(count: 0)
    @State var indices : [Int] = []
    //@State var assignCompleted : Bool = false
    //@State var assignDate = Date()
    @State var showAssign = false
    @State var assignName = ""
    
   @FetchRequest(sortDescriptors:
        [NSSortDescriptor(keyPath: \Assignments.assignName, ascending: true),
        NSSortDescriptor(keyPath: \Assignments.assignDate, ascending: true),
        NSSortDescriptor(keyPath: \Assignments.assignCompleted, ascending: true),
         NSSortDescriptor(keyPath: \Assignments.assignid, ascending: true)
        ]) private var assignment : FetchedResults<Assignments>
    
    
    func getDateFormatString(date:Date) -> String
    {
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM. dd"
        
        dateString = dateFormatter.string(from: date)
        return dateString
    }
    var countAssignments: Int {
        developers.assignmentArray
            .count
    }
    func delete(at offsets: IndexSet) {
        
        for index in offsets {
            let assignment = developers.assignmentArray[index]
            self.moc.delete(assignment)
        }
        try? self.moc.save()
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
            ZStack{
                VStack{
                    Color("lightorange")
                        .clipShape(CustomCorners(corners: [.bottomLeft, .bottomRight], size: 70))
                        .ignoresSafeArea(.all, edges: .top)
                        .frame(width: .infinity, height: 175)
                    Spacer()
                }
                
                VStack{
                    HStack {
                        
                        if !self.showSearch{
                        Button(action: {
                            
                            withAnimation(.spring()){
                                self.presen.wrappedValue.dismiss()
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(Color("dark"))
                                .padding(.leading, 20)
                        }
                        }
                        
                        Spacer()
                       
                        HStack {

                            if self.showSearch{
                                
                                Image(systemName: "magnifyingglass")
                                    .font(.title2)
                                    .foregroundColor(Color("dark"))
                                    .padding(.trailing, 20)
                                    
                                
                                TextField("Search", text: self.$txt , onEditingChanged: { (isBegin) in
                                   if isBegin {
                                        showSearch = true
                                    } else {
                                        showSearch = false
                                    }
                                })
                                
                                Button(action: {
                                    withAnimation{
                                    self.showSearch.toggle()
                                    }
                                }) {
                                    
                                    Image(systemName: "xmark").foregroundColor(.black).padding(.horizontal, 8)
                                }
                            }
                            
                            else {
                        Button(action: {
                            withAnimation {
                                
                            self.showSearch.toggle()
                            
                        }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(Color("dark"))
                                .padding(.trailing, 20)
                        }
                        }
                        }.padding(self.showSearch ? 10 : 0)
                            .background(Color("lightorange"))
                            .cornerRadius(20)
                        
                    
                    }
                    ZStack{
                      RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(Color("tan"))
                            .frame(width: 335, height: 130)
                        HStack {
                            VStack (alignment: .leading){
                                
                                if developers.icon != "photo", image.count == 0 {
                                        ZStack{
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 68, height: 68)
                                            .foregroundColor(Color.white)
                                        Image(systemName: developers.icon ?? "")
                                                .foregroundColor(Color("orange"))
                                            .font(.system(size: 28))
                                        }
                                    
                                    }
                                else if developers.imageD != nil{
                                Image(uiImage: UIImage(data: developers.imageD ?? self.image)!)
                                    .resizable()
                                  .frame(width: 70, height: 70)
                                  .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                                else{
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 70, height: 70)
                                        .foregroundColor(.gray)
                                }
                                Text("\(developers.username ?? "")")
                                    .font(Font.custom(FontNameManager.Montserrat.bold, size: 24))
                                    .foregroundColor(Color("dark"))

                                Text("\(developers.descriptions ?? "")")
                                    .font(Font.custom(FontNameManager.Montserrat.semibold, size: 18))
                                    .foregroundColor(.gray)
                                
                            }
                            .padding([.leading, .trailing], 70)
                            .padding(.bottom, 80)
                            
                            Spacer()
                        }
                    }
                    
                    HStack{
                        Text("\(countAssignments) Assignments")
                            .font(Font.custom(FontNameManager.Montserrat.bold, size: 20))
                        
                        Spacer(minLength: 0)
                        
                        EditButton()
                            .foregroundColor(Color("orange"))
                            .font(Font.custom(FontNameManager.Montserrat.semibold, size: 15))
                           // .disabled(taskVM.tasks.isEmpty)
                           // .onChange(of: taskVM.sortType, perform: { _ in
                             //   guard !taskVM.tasks.isEmpty else { return }
                               // withAnimation() {taskVM.sort()}
                            //})
                    }
                    .padding([.leading, .trailing], 20)
                    Spacer()
                    
                    List {
                        
                       // ForEach(developers.assignmentArray, id:\.self) {assign in
                        
                        ForEach(developers.assignmentArray.filter {
                            txt.isEmpty ? true : $0.assignName!.localizedCaseInsensitiveContains(self.txt)
                                        }, id: \.self) { assign in
                            
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
                                
                            }.buttonStyle(BorderlessButtonStyle())
                            .padding()
                            
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
                        
                        }.listRowSeparator(.hidden)
                        
                        }.onDelete(perform: delete)
                }
                .listStyle(InsetListStyle())
                    
                  
                }
            }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showAssign.toggle()
                            
                        }) {
                            Image(systemName: "plus").resizable().frame(width: 25, height: 25).padding()
                        }.foregroundColor(.white)
                            .background(Color("orange"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.trailing, 25)
                    
                    }
                }.sheet(isPresented: $showAssign) {
                    NewAssignmentView(developers: developers).environment(\.managedObjectContext, self.moc)
                }
                
            }.navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}


struct DetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceController = PersistenceController.shared
        
                    let context = persistenceController.container.viewContext
                    let developers = Developer(context: context)
                    developers.username = "Math"
                    developers.descriptions = "Calculus"
                    //developers.imageD = 0
                    let assignment1 = Assignments(context: context)
                    assignment1.assignName = "Test"
                    
                    let assignment2 = Assignments(context: context)
                    assignment2.assignName = "Lab"
                    
                    developers.addToDeveloperToAssignment(assignment1)
                    developers.addToDeveloperToAssignment(assignment2)
        
                    return DetailsView(developers: developers).environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}


