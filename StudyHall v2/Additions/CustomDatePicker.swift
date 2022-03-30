//
//  CustomDatePicker.swift
//  StudyHall v2
//
//  Created by Kathryn Jerez on 12/20/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomDatePicker: View {
    @Binding var currentDate: Date
    
    // Month update on arrow button
    @State var currentMonth: Int = 0
    
    @State var assignDate = Date()
    
    @FetchRequest(sortDescriptors:
         [NSSortDescriptor(keyPath: \Assignments.assignName, ascending: true),
         NSSortDescriptor(keyPath: \Assignments.assignDate, ascending: true),
         NSSortDescriptor(keyPath: \Assignments.assignCompleted, ascending: true),
          NSSortDescriptor(keyPath: \Assignments.assignid, ascending: true)
         ]) private var assignment : FetchedResults<Assignments>
    
    var body: some View {
        
        VStack(spacing: 35) {
            
            let days: [String] =
                ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
            
            HStack(spacing:20) {
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text(extraDate()[0])
                        .font(Font.custom(FontNameManager.Montserrat.semibold, size: 15))
                    
                    Text(extraDate()[1])
                        .font(Font.custom(FontNameManager.Montserrat.bold, size: 22))
                    
                }
                Spacer(minLength: 0)
                
                Button {
                    
                    withAnimation{
                        currentMonth -= 1
                        
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .accentColor(Color(UIColor(named: "lightorange")!))
                }
                
                Button{
                    
                    withAnimation{
                        currentMonth += 1
                        
                    }
                    
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .accentColor(Color(UIColor(named: "lightorange")!))
                    
                }
            }
            .padding(.horizontal)
            
          //Day View
            HStack(spacing: 0){
                ForEach(days,id: \.self){day in
                    
                    Text(day)
                        .font(Font.custom(FontNameManager.Montserrat.light, size: 15))
                        .frame(maxWidth: .infinity)
                }
            }
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns,spacing: 15) {
                
                ForEach(extractDate()){value in
                    
                    CardView(value: value)
                        .background(
                            Circle()
                                .fill(Color("burntorange"))
                                .frame(width: 35, height: 35)
                                .padding(.bottom, 8)
                                .offset(y: -3)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }
            
        }
        .onChange(of: currentMonth) { newValue in
            
            // Updating Month
            currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue)->some View{
        
        VStack{
            if value.day != -1 {
                if let task = assignment.first(where: {task in
                  
                    return isSameDay(date1: task.assignDate ?? self.assignDate, date2: value.date)
                }) {
                    
                    Text("\(value.day)")
                        .font(Font.custom(FontNameManager.Montserrat.medium, size: 15))
                        .foregroundColor(isSameDay(date1: task.assignDate ?? self.assignDate, date2: currentDate) ? Color("tan") : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Circle()
                        .fill(isSameDay(date1: task.assignDate ?? self.assignDate, date2: currentDate) ? Color("tan") : Color("lightorange"))
                        .frame(width: 5, height: 5)
                    
                }
                else {
                    Text("\(value.day)")
                        .font(Font.custom(FontNameManager.Montserrat.medium, size: 15))
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? Color("tan") : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
            }
        }
        
    }
    
    // Checking dates
    func isSameDay(date1: Date, date2: Date)->Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    // Extracting Year And Month For Display
    func extraDate()->[String]{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    
    func getCurrentMonth()->Date{
        
        let calendar = Calendar.current
        
        //Getting Current Month Date
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else{
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate()->[DateValue]{
        
        let calendar = Calendar.current
        
        //Getting Current Month Date
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue
            in
            
            // Getting Day
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        // Adding Offset Days To Get Exact Week Day
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


// Extending Date to get Current Month Dates
extension Date{
    
    func getAllDates()->[Date]{
        
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
            
        }
    }
}
