//
//  HeartRate.swift
//  iotSOS
//
//  Created by Mohammad Khimel on 07/06/2021.
//

import SwiftUI
import UserNotifications
import Combine

struct HeartRate: View{
    @EnvironmentObject var usernameInfo: LoggedUsername
    @EnvironmentObject var wcSession : WCsession
    @State private var value = 0
    @State var linkActive = false
//    @State var showSOSmsg = false
    @State var Reachable = true
    @State var min = "40"
    @State var max = "100"
    
    @Binding var shouldPopToRootView : Bool
    @EnvironmentObject var manager : LocationManager
    @State var alertLocation = false
    
    var body: some View {
        
            VStack{
                Button(action:{
                    usernameInfo.username = ""
                    UserDefaults.standard.set(false, forKey: "isLogged")
                    shouldPopToRootView = false
                    wcSession.active = false
                    wcSession.pointsHigh = 0
                    wcSession.pointsHigh = 0
                    self.linkActive = false
                    self.wcSession.SOS = false
                    self.Reachable = true
                    guard let url = URL(string: "https://sosfuncs.azurewebsites.net/api/deleteLocation") else {
                        print("Invalid URL")
                        return
                    }
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    let json = [
                        "username": usernameInfo.username
                    ]
                    let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
                    print(json)
                    URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
                    }.resume()
                    
                    // disconnect from watch
                    self.wcSession.session.sendMessage(["message" : Int(0)], replyHandler: nil) { (error) in
                        print(error.localizedDescription)
                    }
                }){
                    Text("Log out").padding(.bottom, 50)
                }
                MaxField(max: $max)
                MinField(min: $min)
                Button(action:{
                    self.wcSession.max = Int(self.max)!
                    self.wcSession.min = Int(self.min)!
                }){
                    Text("Submit").padding(.bottom, 100)
                }
                
//                Spacer()
                
                if(linkActive){
                    if(self.wcSession.SOS){
                        VStack{
                            Text("SOS!")
                                .fontWeight(.heavy)
                                .foregroundColor(Color.red)
                                .multilineTextAlignment(.center).onAppear(){
                                    print(self.manager.location!.coordinate)
                                        // send coordinates to azure table locations
                                        alertLocation = true
                                    print("Sending Location to azure!!!")
                                    guard let url = URL(string: "https://sosfuncs.azurewebsites.net/api/saveLocation") else {
                                        print("Invalid URL")
                                        return
                                    }
                                    var request = URLRequest(url: url)
                                    request.httpMethod = "POST"
                                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                    let json = [
                                        "username": usernameInfo.username,
                                        "long": String(self.manager.location!.coordinate.longitude),
                                        "lat":String(self.manager.location!.coordinate.latitude),
                                        "name": usernameInfo.name,
                                        "phone": usernameInfo.phone
                                    ]
                                    let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
                                    print(json)
                                    URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
                                    }.resume()
                                }
                            Button(action: {
                                self.wcSession.SOS = false
                                self.wcSession.pointsHigh = 0
                                self.wcSession.pointsLess = 0
                                self.wcSession.active = true
                                self.linkActive = false
                                self.linkActive = true
                                guard let url = URL(string: "https://sosfuncs.azurewebsites.net/api/deleteLocation") else {
                                    print("Invalid URL")
                                    return
                                }
                                var request = URLRequest(url: url)
                                request.httpMethod = "POST"
                                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                let json = [
                                    "username": usernameInfo.username
                                ]
                                let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
                                print(json)
                                URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
                                }.resume()
                            }){
                                Text("Stop")
                            }
                        }
                        
                    }
                }
                                
                Text("❤️")
                        .font(.system(size: 50))
                        .multilineTextAlignment(.center)
                if(linkActive){
                    Text("\(self.wcSession.value)")
                            .fontWeight(.regular)
                        .font(.system(size: 70))
                        
                        Text("BPM")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.red)
                            .padding(.bottom, 28.0)
                }
                
                if(!Reachable){
                    Text("Please start SafePlace on your Apple watch then try connecting.").fontWeight(.bold)
                        .multilineTextAlignment(.center).foregroundColor(.red)
                }
                
                if(!linkActive){
                    Button(action: {
                        wcSession.session.activate()
                        sleep(2)
                        if(self.wcSession.session.isReachable){
                            self.linkActive = true
                            wcSession.active = true
                            wcSession.pointsHigh = 0
                            wcSession.pointsLess = 0
                            wcSession.username = usernameInfo.username
                            wcSession.name = usernameInfo.name
                            wcSession.phone = usernameInfo.phone
                            wcSession.max = Int(self.max)!
                            wcSession.min = Int(self.min)!
                            self.wcSession.session.sendMessage(["message" : Int(1)], replyHandler: nil) { (error) in
                                print(error.localizedDescription)
                        }
                            self.Reachable = true
                        }else{
                            self.Reachable = false
                        }
                            
                        
                    }){
                        Text("Connect to Watch")
                    }
                }else{
                    Button(action: {
                        self.linkActive = false
//                        wcSession.session.activate()
                        wcSession.active = false
                        wcSession.pointsHigh = 0
                        wcSession.pointsHigh = 0
                        if(alertLocation){
                            guard let url = URL(string: "https://sosfuncs.azurewebsites.net/api/deleteLocation") else {
                                print("Invalid URL")
                                return
                            }
                            var request = URLRequest(url: url)
                            request.httpMethod = "POST"
                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            let json = [
                                "username": usernameInfo.username
                            ]
                            let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
                            print(json)
                            URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
                            }.resume()
                        }
                        self.wcSession.session.sendMessage(["message" : Int(0)], replyHandler: nil) { (error) in
                            print(error.localizedDescription)
                        }
                    }){
                        Text("Disconnect from Watch")
                    }
                }
                
                    Spacer()
            }
            .padding()
    }
}


//struct HeartRate_Previews: PreviewProvider {
//    static var previews: some View {
//        HeartRate()
//    }
//}

struct MaxField: View {
    @Binding var max: String
    var body: some View {
                        HStack {
                            Text("Max BPM value:").fontWeight(.heavy)
        
//                            Spacer()
        
                            TextField("Max BPM value", text: $max).fixedSize().border(Color.pink, width: 2).multilineTextAlignment(.center)
                                .cornerRadius(5.0)
        
                        }
    }
}
struct MinField: View {
    @Binding var min: String
    var body: some View {
                        HStack {
                            Text("Min BPM value:").fontWeight(.heavy)
        
//                            Spacer()
        
                            TextField("Max BPM value", text: $min).fixedSize().border(Color.pink, width: 2).multilineTextAlignment(.center)
                                .cornerRadius(5.0)
        
                        }
    }
}
