//
//  HostingTabBar.swift
//  iotSOS
//
//  Created by Mohammad Khimel on 07/06/2021.
//

import SwiftUI

struct HostingTabBar: View, Equatable{
    static func == (lhs: HostingTabBar, rhs: HostingTabBar) -> Bool {
        if(lhs.user != rhs.user){
            return false
        }
        return true
    }
    
    
    private enum Tab: Hashable {
            case Mapz
//            case Rooms
            case Contacts
            case HeartRate
    }
    @State private var selectedTab: Tab = .HeartRate
    @Binding var shouldPop : Bool
    @EnvironmentObject var usernameInfo: LoggedUsername
    @State var user: String = ""
   // @EnvironmentObject var usernameInfo: LoggedUsername
    
    
    var body: some View{
        TabView(selection: $selectedTab) {
            HeartRate(shouldPopToRootView: $shouldPop)
                .tag(0)
                .tabItem {
                            Text("HeartRate")
                    
                            Image(systemName: "heart")
                }
                
            Mapz()
                .tag(1)
            .tabItem {
                            Text("Map")
                    Image(systemName: "map")
                }
//            Rooms()
//                .tag(2)
//                .tabItem {
//                            Text("Rooms")
//                            Image(systemName: "person.3")
//                        }
            Contacts()
                .tag(2)
                .tabItem {
                            Text("Contacts")
                            Image(systemName: "person.crop.circle")
                        }
        }.onAppear(){
            self.user = "hi"
        }
        
    }
}

//struct HostingTabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        HostingTabBar()
//            .environmentObject(ModelData())
//    }
//}
