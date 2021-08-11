////
////  HealthStore.swift
////  iotSOS
////
////  Created by Mohammad Khimel on 08/06/2021.
////
//
//import Foundation
//import HealthKit
//
//class HealthStore{
//
//    var healthStore: HKHealthStore?
//    let heartRateQuantity = HKUnit(from: "count/min")
//
//    init() {
//        if HKHealthStore.isHealthDataAvailable(){
//            healthStore = HKHealthStore()
//        }
//    }
//
//
//
//    func requestAuthorization(completion: @escaping (Bool) -> Void){
//
//        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
//
//        guard let healthStore = self.healthStore else { return completion(false)}
//
//        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in completion(success)
//        }
//    }
//
//
//
//}
