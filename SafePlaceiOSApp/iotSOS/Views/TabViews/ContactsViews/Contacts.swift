//
//  Contacts.swift
//  iotSOS
//
//  Created by Mohammad Khimel on 07/06/2021.
//
import Foundation
import SwiftUI


struct Contacts: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var usernameInfo: LoggedUsername
    @State var name: String = ""
    @State var email: String = ""
    
    
    var body: some View {
        VStack{
            
            List{
                ForEach(modelData.contacts, id: \.self) { contact in
                    ContactRow(contact: contact)
                }.onDelete(perform: delete)
            }
            
            TextField("Name", text: $name).padding()
                .border(Color.accentColor, width: 2)
                .cornerRadius(5.0)
                .padding(.bottom,10)
                .padding(.horizontal)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            TextField("Email", text: $email).padding()
                .border(Color.accentColor, width: 2)
                .cornerRadius(5.0)
                .padding(.bottom,20)
                .padding(.horizontal)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            Button(action: {
                    if(name != "" && email != ""){
                        let contact: Contact = Contact(name:name,email:email)
                        addRow(contact: contact)
                    }
                }) {
                    Text("Add Emergency Contact")
                }
            }
            
        }
            
    
        
    func delete(at offsets: IndexSet){ // should talk with azure
        var index : Int
        var removedContact: Contact
        index = offsets.first!
        print(index)
        removedContact = modelData.contacts[index]
        print(removedContact.name)
        modelData.contacts.remove(atOffsets: offsets)
        print("Deleting contact")
        guard let url = URL(string: "https://sosfuncs.azurewebsites.net/api/deleteContact") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = [
            "username": UserDefaults.standard.string(forKey: "username")!,
            "name": removedContact.name
        ]
        print(json)
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
        }.resume()
        
    }
    
    private func addRow(contact:Contact) { //talks with azure
        modelData.contacts.append(contact)
        name=""
        email=""
        print("Adding contact")
        guard let url = URL(string: "https://sosfuncs.azurewebsites.net/api/saveContact") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = [
            "username": UserDefaults.standard.string(forKey: "username")!,
            "name": contact.name,
            "email": contact.email
        ]
        print(json)
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
        }.resume()
    }
}

struct Contacts_Previews: PreviewProvider {
    static var previews: some View {
        Contacts()
            .environmentObject(ModelData())
    }
}
