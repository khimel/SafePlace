//
//  ModelData.swift
//  iotSOS
//
//  Created by Mohammad Khimel on 07/06/2021.
//

import Foundation
import Combine
import MapKit

class ModelData: ObservableObject {
    @Published var contacts: [Contact] = []
    
    @Published var annotations: [AnnotatedItem] = [
        ]
    
//
//    init(username: String){
//        // contact azure and get relevant contact / room contacts for given user
//    }
    
    func fillContacts(username: String, completion: @escaping ([Contact])->()){
        var gotContacts: [Contact] = []
        print("Filling contacts!!!")
//        self.contacts.append(Contact(name: "yasmin", email: "kkiki"))
        guard let url = URL(string: "https://sosfuncs.azurewebsites.net/api/getContacts") else {
            print("Invalid URL")
            return
        }
        print("url ok")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = [
            "username": username
        ]
        print(username)
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        print(json)
        URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
            guard let dataResponse = data,
                      error == nil else {
                      print(error?.localizedDescription ?? "Response Error")
                      return }
            do{
                    //here dataResponse received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                                           dataResponse, options: [])
                    print(jsonResponse) //Response result
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                      return
                }
                for dic in jsonArray{
                    guard let name = dic["name"] as? String else { return }
                    print(name)
                    guard let email = dic["email"] as? String else{ return }
                    print(email)
                    
                    gotContacts.append(Contact(name: name, email: email))
                }
                completion(gotContacts)
                 } catch let parsingError {
                    print("Error", parsingError)
                    completion(gotContacts)
            }
            
            // if we're still here it means there was a problem
            //print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func fillAnnotatedItems(completion: @escaping ([AnnotatedItem])->()){
        // get annotations and fill array
        var annotations: [AnnotatedItem] = []
        print("Filling annotations!!!")
        guard let url = URL(string: "https://sosfuncs.azurewebsites.net/api/getLocations") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = [
            ".": "."
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        print(json)
        URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
            guard let dataResponse = data,
                      error == nil else {
                      print(error?.localizedDescription ?? "Response Error")
                      return }
            do{
                    //here dataResponse received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                                           dataResponse, options: [])
                    print(jsonResponse) //Response result
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                      return
                }
                for dic in jsonArray{
                    guard let name = dic["name"] as? String else { return }
                    print(name)
                    guard let phoneNumber = dic["phone"] as? String else { return }
                    guard let long = dic["longitude"] as? String else{ return }
                    print(long)
                    guard let lat = dic["latitude"] as? String else{ return }
                    print(lat)
                    
                    annotations.append(AnnotatedItem(name: name,phone:phoneNumber,  coordinate: CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)))
                }
                completion(annotations)
                 } catch let parsingError {
                    print("Error", parsingError)
                    completion(annotations)
            }
            
            // if we're still here it means there was a problem
            //print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
}


struct AnnotatedItem: Identifiable {
    let id = UUID()
    var name: String
    var phone: String
    var coordinate: CLLocationCoordinate2D
}
