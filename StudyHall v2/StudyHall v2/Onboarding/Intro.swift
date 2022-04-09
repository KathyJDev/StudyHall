//
//  Intro.swift
//  StudyHall
//
//  Created by Kathryn Jerez on 12/8/21.
//

import SwiftUI

struct Intro: Identifiable{
    var id = UUID().uuidString
    var image: String
    var title: String
    var description: String
    var color: Color
}

var intros : [Intro] = [

    Intro(image: "logo", title: "Page 1", description: "Welcome Page", color: Color("lightorange")),
    Intro(image: "logo", title: "Page 2", description: "Notification Page", color: Color("lightorange")),
    Intro(image: "logo", title: "Page 3", description: "Welcome Page", color: Color("lightorange")),

]
