//
//  ContentView.swift
//  iotSOSwatch Extension
//
//  Created by Mohammad Khimel on 08/06/2021.
//

import SwiftUI
import HealthKit
import WatchConnectivity

// The quantity type to write to the health store.
struct ContentView: View {
    let extendedSession = ExtendedSession()
    var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")

    @ObservedObject var wcSession = WCsession()
    @State private var value =  0
    @State var isMonitor = false
    
    var body: some View { 
        
        VStack{
            
            HStack{
                Text("❤️")
                    .font(.system(size: 50))
                Spacer()

            }
            
            HStack{
                Text("\(value)")
                    .fontWeight(.regular)
                    .font(.system(size: 70))
                
                Text("BPM")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .padding(.bottom, 28.0)
                
                Spacer()
            }
            if(!isMonitor){
                Button("Start Monitoring"){
                    extendedSession.startSession()
                    isMonitor = !isMonitor
                }
                
            }else{
                Button("Stop Monitoring"){
                    extendedSession.session.invalidate()
                    
                    isMonitor = !isMonitor
                }
            }
            

        }
        .padding()
        .onAppear(perform: start)
    }

    
    func start() {
        
        autorizeHealthKit()
        
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }
    
    func autorizeHealthKit() {
        let healthKitTypes: Set = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]

        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }
    
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        
        // 1
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        // 2
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            
            // 3
        guard let samples = samples as? [HKQuantitySample] else {
            return
        }
            
        self.process(samples, type: quantityTypeIdentifier)

        }
        
        // 4
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        // 5
        
        healthStore.execute(query) 
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0
        
        if samples.last != nil{
            
            lastHeartRate = samples.last!.quantity.doubleValue(for: heartRateQuantity)
            print(lastHeartRate)
                print("hahahah")
            if(self.wcSession.iphoneDidActivate){ // send only after iphone activated connection with watch
                self.wcSession.session.sendMessage(["message" : Int(lastHeartRate)], replyHandler: nil) { (error) in
                                    print(error.localizedDescription)
            }
                
            }
            
            self.value = Int(lastHeartRate)
        }
        
        
//        for sample in samples {
//            if type == .heartRate {
//                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
//            }
//            print(lastHeartRate)
//            self.wcSession.session.sendMessage(["message" : Int(lastHeartRate)], replyHandler: nil) { (error) in
//                                print(error.localizedDescription)
//            }
//            self.value = Int(lastHeartRate)
//        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

