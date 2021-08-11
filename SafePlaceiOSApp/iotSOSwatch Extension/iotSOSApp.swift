//
//  iotSOSApp.swift
//  iotSOSwatch Extension
//
//  Created by Mohammad Khimel on 08/06/2021.
//

import SwiftUI

@main
struct iotSOSApp: App {
    let extendedSession = ExtendedSession()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView().onAppear(){
//                extendedSession.startSession()
            }.onDisappear(){
                print("well shit")
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
        
    }
}
