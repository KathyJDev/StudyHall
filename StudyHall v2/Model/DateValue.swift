//
//  DateValue.swift
//  StudyHall v2
//
//  Created by Kathryn Jerez on 12/20/21.
//

import SwiftUI

// Date Value Model
struct DateValue: Identifiable{
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
