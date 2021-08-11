//
//  WCsession.swift
//  iotSOSwatch Extension
//
//  Created by Mohammad Khimel on 09/06/2021.
//

import Foundation
import WatchConnectivity

class WCsession : NSObject,  WCSessionDelegate, ObservableObject{
    var session: WCSession
    @Published var iphoneDidActivate = false
    init(session: WCSession = .default){
            self.session = session
            super.init()
            self.session.delegate = self
            session.activate()
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let msg = message["message"] as? Int ?? 0
        print(msg)
        if msg == 0{
            iphoneDidActivate = false
        }else{
            iphoneDidActivate = true
        }
        
    }
}
