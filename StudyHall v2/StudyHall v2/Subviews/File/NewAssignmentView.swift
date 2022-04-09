//
//  NewAssignmentView.swift
//  StudyHall v2
//
//  Created by Kathryn Jerez on 3/12/22.
//

import SwiftUI

struct NewAssignmentView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @StateObject var developers : Developer
    
    
   // @FetchRequest var assign : FetchedResults<Assignments>
 //  @FetchRequest(sortDescriptors: [], animation: .default) private var developers: FetchedResults<Developer>
    
   // var developers : Developer = Developer()
    @State var assignName = ""
    @State var assignCompleted = Bool()
    @State var assignDate = Date()
    //@State private var selectedAssignment:[Developer] = []
    
    
    private func addAssignmentItem(){
        withAnimation {
            let newEmployee = Assignments(context: moc)
            newEmployee.assignName = assignName
            newEmployee.assignCompleted = assignCompleted
            newEmployee.assignDate = assignDate
            
            developers.addToDeveloperToAssignment(newEmployee)
            PersistenceController.shared.save()
        }
    }
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 14) {
                Spacer()
                
                TextField("Assignment Name",text: $assignName)
                    .padding()
                    .background(Color("tan"))
                    .cornerRadius(5)
                    .font(Font.custom(FontNameManager.Montserrat.semibold, size: 15))
                    .padding(.bottom, 20)
                HStack{
                Text("Due Date")
                        .font(Font.custom(FontNameManager.Montserrat.semibold, size: 15))
                    Image(systemName: "bell.badge")
                    .foregroundColor(.gray)
                    .frame(width: 30, height: 30, alignment: .leading)
                VStack{
                    DatePicker("Select Date", selection: $assignDate, displayedComponents: .date)
                        .labelsHidden()
                }
                }
                
                Spacer()
                
                Button(action:{
                    addAssignmentItem()
                    presentationMode.wrappedValue.dismiss()
                    
                }
                  ) {
                  Text("Add Assignment")
                        .font(Font.custom(FontNameManager.Montserrat.bold, size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color("orange"))
                        .cornerRadius(15)
                }
                
                
            }.padding()
                .navigationBarItems(trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack{
                        
                        Image(systemName: "xmark")
                            .foregroundColor(Color("orange"))
                            
                    }
                })
                
        }
    }
}

struct NewAssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        NewAssignmentView(developers: Developer())
    }
}
