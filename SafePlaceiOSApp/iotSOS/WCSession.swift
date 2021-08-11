//
//  WCSession.swift
//  iotSOS
//
//  Created by Mohammad Khimel on 09/06/2021.
//

import Foundation
import WatchConnectivity
import UserNotifications

class WCsession: NSObject, WCSessionDelegate, ObservableObject{
     
    var session: WCSession
    @Published var value = 0
    @Published var SOS = false
    var pointsHigh = 0
    var pointsLess = 0
    var active = false
    var username = ""
    var name = ""
    var phone = ""
    var max = 0
    var min = 0
    
//    var loggedinfo: LoggedUsername
    
    init(session: WCSession = .default){
        print("here we go again")
            self.session = session
//            self.loggedinfo = loggedinfo
            super.init()
            self.session.delegate = self
//            session.activate()
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            print("\(self.pointsHigh)")
            self.value = message["message"] as? Int ?? 0
            if self.active{
                if(self.value > self.max){
                    self.pointsHigh += 1
                } else if(self.value < self.min){
                    self.pointsLess += 1
                }
                if(self.pointsLess > 3 || self.pointsHigh > 3){
                    self.active = false
                    self.SOS = true
                    let content = UNMutableNotificationContent()
                    content.title = "\(self.name) are you OK?"
                    content.subtitle = "We have notified your contacts and shared your last location on the map."
                    content.sound = UNNotificationSound.default

                    // show this notification five seconds from now
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                    // choose a random identifier
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                    // add our notification request
                    UNUserNotificationCenter.current().add(request)
                    
                    guard let url = URL(string: "https://sosfuncs.azurewebsites.net/api/HeartSignal") else {
                        print("Invalid URL")
                        return
                    }
                    var requestz = URLRequest(url: url)
                    requestz.httpMethod = "POST"
                    requestz.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    let json = [
                        "username": self.username,
                        "name": self.name,
                        "phone": self.phone
                    ]
                    print(json)
                    let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
                    URLSession.shared.uploadTask(with: requestz, from: jsonData) { data, response, error in
                    }.resume()
                    print("sent http requesttt")

                }
            }
            
        }
    }
    
//    var wcSession : WCSession!
//
//    func startSession(){
//        wcSession.delegate = self
//        wcSession.activate()
//    }
}
