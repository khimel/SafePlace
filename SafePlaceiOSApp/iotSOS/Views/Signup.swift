//
//  Signup.swift
//  iotSOS
//
//  Created by Mohammad Khimel on 30/07/2021.
//

import SwiftUI

struct Signup: View {
    @State var name: String = ""
    @State var username: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State var password: String = ""
    @State var signUpDidFail: Bool = false
    
    @Binding var shouldPopToRootView : Bool
    
    var body: some View {
        NavigationView{
            VStack{
//                Spacer()
                TextField("Your Full Name", text: $name)
                    .padding()
                    .border(Color.accentColor, width: 2)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .disableAutocorrection(true)
                    .navigationTitle("Sign up")
                
                TextField("Email", text: $email)
                    .padding()
                    .border(Color.accentColor, width: 2)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .disableAutocorrection(true)
                
                TextField("Phone Number", text: $phone)
                    .padding()
                    .border(Color.accentColor, width: 2)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .disableAutocorrection(true)
                
                TextField("Username (Used for Logging in)", text: $username)
                    .padding()
                    .border(Color.accentColor, width: 2)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $password)
                    .padding()
                    .border(Color.accentColor, width: 2)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                if signUpDidFail {
                    Text("Please fill the form with your correct data")
                        .offset(y: -10)
                        .foregroundColor(.red)
                }
                
                Button(action:{
                    if(name != "" && username != "" && password != "" && email != "" && phone != ""){
                        saveUser(fullName: name, email:email, phone:phone,  uname: username, pass: password)
                        signUpDidFail = false
                        shouldPopToRootView = false
                        print("Lol")
                    }else{
                        signUpDidFail = true
                    }
                    
                }) {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.green)
                        .cornerRadius(15.0)
                }
                
                
            }
 
        }.padding()
        
    }
    
    func saveUser(fullName:String, email:String, phone:String, uname: String, pass: String){
        
        guard let url = URL(string: "https://sosfuncs.azurewebsites.net/api/saveUser") else {
            print("Invalid URL")
            return
        }
        print("save user url ok")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = [
            "PartitionKey" : "PKuser",
            "RowKey" : "idk",
            "name": fullName,
            "username": uname,
            "email": email,
            "phone": phone,
            "password": pass,
            "showLocationBit": "false"
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        print(json)
        
        URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
                return
            }
            
            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

//struct Signup_Previews: PreviewProvider {
//    static var previews: some View {
//        Signup(shouldPopToRootView: $RootisActive)
//    }
//}


