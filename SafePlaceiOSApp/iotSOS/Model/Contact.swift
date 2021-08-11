//
//  Contact.swift
//  iotSOS
//
//  Created by Mohammad Khimel on 30/06/2021.
//

import Foundation

struct Contact: Hashable, Codable, Identifiable {
    var id = UUID()
    var name: String
    var email: String
}

//var contacts: [Contact] = [
//    Contact(name : "Mohammad Khimel", phoneNumber : "00000", email: "zz" ),
//    Contact(name : "Malak Daka", phoneNumber : "12345", email: "zzz"),
//    Contact(name : "Marah Bishara", phoneNumber : "54321", email: "Zzzzz" )
//]
