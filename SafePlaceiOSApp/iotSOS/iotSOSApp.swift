//
//  iotSOSApp.swift
//  iotSOS
//
//  Created by Mohammad Khimel on 06/06/2021.
//

import SwiftUI
import SwiftSignalRClient
import WindowsAzureMessaging
@main
struct iotSOSApp: App {
   // @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
//    let hubConnection = HubConnectionBuilder(url: URL(string: "http://localhost:5000/playground")!)
//        .build()
    
//    let hub = SignalRService(url: URL(string: "https://sosfuncs.azurewebsites.net/api")!)
//    let PushService = AzurePushService()
    
    @StateObject var loggedUsername = LoggedUsername()
    @StateObject var modelData = ModelData()
    @StateObject var wc = WCsession()
    @StateObject var lm = LocationManager()
    
    
    var body: some Scene {
        WindowGroup {
            if(UserDefaults.standard.bool(forKey: "isLogged")){
                
                HostingTabBar(shouldPop: $loggedUsername.isLogged).equatable()
                    .environmentObject(loggedUsername)
                        .environmentObject(modelData)
                    .environmentObject(wc)
                    .environmentObject(lm)
                    .onAppear(){
                        modelData.fillContacts(username: UserDefaults.standard.string(forKey: "username")!){ (gotContacts) in
                            DispatchQueue.main.async {
                                modelData.contacts = gotContacts
                            }
                            modelData.fillAnnotatedItems(){ (items) in
                                DispatchQueue.main.async {
                                    modelData.annotations = items
                                }
                            }
                    }
                        loggedUsername.username = UserDefaults.standard.string(forKey: "username")!
                        loggedUsername.name = UserDefaults.standard.string(forKey: "name")!
                        loggedUsername.phone = UserDefaults.standard.string(forKey: "phone")!
                    }
            }else{
                Login().environmentObject(loggedUsername)
                    .environmentObject(modelData)
                    .environmentObject(wc)
                    .environmentObject(lm)
            }
            
        }
    }
    
}
