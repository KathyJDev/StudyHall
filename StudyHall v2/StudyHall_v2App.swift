//
//  StudyHall_v2App.swift
//  StudyHall v2
//
//  Created by Kathryn Jerez on 12/20/21.
//

import SwiftUI

@main
struct StudyHall_v2App: App {
    @Environment(\.scenePhase) var scenePhase
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    
                
            }.onChange(of: scenePhase) {_ in
                persistenceController.save()
        }
    }
}

