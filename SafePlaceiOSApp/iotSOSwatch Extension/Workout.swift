//
//  Workout.swift
//  iotSOSwatch Extension
//
//  Created by Mohammad Khimel on 09/06/2021.
//

import Foundation
import HealthKit
import WatchKit

class ExtendedSession: NSObject, WKExtendedRuntimeSessionDelegate {
    
    var session : WKExtendedRuntimeSession!
    
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        print("did invalidateeee")
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("well shit jsut started")
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("fkkkk")
    }

    func startSession() {
        self.session = WKExtendedRuntimeSession()
        self.session.delegate = self
        self.session.start()
    }
}


