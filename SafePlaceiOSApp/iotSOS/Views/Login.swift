//
//  Login.swift
//  iotSOS
//
//  Created by Mohammad Khimel on 07/06/2021.
//

import SwiftUI
import HealthKit


let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

class LoggedUsername: ObservableObject{
    @Published var username = ""
    @Published var isLogged = false
    @Published var alertLocation = false
    @Published var name = ""
    @Published var phone = ""
}

struct Login: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var authenticationDidFail: Bool = false
    
    @State var signupButtonActive: Bool = false
    
    @State var RootisActive : Bool = false
    
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var usernameInfo: LoggedUsername

    //@State var authenticationOk: Bool = false
    

    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                Image("safeplacetrans")
                    .resizable()
                                .scaledToFit()
//                Text("SOS")
//                    .font(.system(size: 100))
//                    .fontWeight(.heavy)
//                    .foregroundColor(Color.red)
//                    .multilineTextAlignment(.center)
//                    .padding(0.0)
//                    .frame(height: 0.0)
                    
            
                Spacer()
                    
                
                UsernameTextField(username: $username)
                    .padding(.horizontal, 14.0)
                PasswordSecureField(password: $password)
                    .padding(.horizontal, 14.0)
                if authenticationDidFail {
                    Text("Information not correct. Try again.")
                        .offset(y: -10)
                        .foregroundColor(.red)
                }
                
                // Log in button, navigates to tabs screen
                NavigationLink(
                    destination: HostingTabBar(shouldPop: $usernameInfo.isLogged).navigationBarBackButtonHidden(true).navigationBarHidden(true),
                    isActive: $usernameInfo.isLogged,
                    label: {
                        Button(action: {
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                if success {
                                    print("Notifications set!")
                                } else if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                            if self.username != "" && self.password != ""{
                                print(self.username)
                                authUser(uname: self.username, pass: self.password){ isOK in
                                    print(isOK)
                                    if(isOK){
                                        DispatchQueue.main.async {
                                            usernameInfo.username = self.username
                                            usernameInfo.isLogged = true
                                        }
                                        UserDefaults.standard.set(self.username, forKey: "username")
                                        UserDefaults.standard.set(true, forKey: "isLogged")
                                        print("well OMGGGGGGG")
                                        DispatchQueue.main.async {
                                            print("yes man")
                                            usernameInfo.isLogged = true
                                        }
                                        
                                        authenticationDidFail = false
                                        modelData.fillContacts(username: UserDefaults.standard.string(forKey: "username")!){ (gotContacts) in
                                            DispatchQueue.main.async {
                                                modelData.contacts = gotContacts
                                            }
                                            modelData.fillAnnotatedItems(){ (items) in
                                                DispatchQueue.main.async {
                                                    modelData.annotations = items
                                                }
                                            }
                                    }
                                    }else{
                                        DispatchQueue.main.async {
                                            usernameInfo.isLogged = false
                                        }
                                      //  usernameInfo.isLogged = false
                                        authenticationDidFail = true
                                        print("wowzzzzz")
                                    }
                                    self.username = ""
                                    self.password = ""
                                }
                                
                                
                                let center = UNUserNotificationCenter.current()
                                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                                    // Enable or disable features based on the authorization.
                                }
                            }
                            
                            
                                }) {
                                LogInButtonContent()
                        }
                    }).isDetailLink(false)
                // sign up button, navigate to sign up screen
                NavigationLink(
                    destination: Signup(shouldPopToRootView: $signupButtonActive),
                    isActive: $signupButtonActive,
                    label: {
                        Button(action:{
                            
                            print("well well well")
                            signupButtonActive = true
                        }) {
                            SignUpButtonContent()
                        }
                    }).isDetailLink(false)
                
//                if(self.authenticationOk){
//                    HostingTabBar()
//                }
                
            }
        }
        
            
    }
    
    func authUser(uname: String, pass: String, completion: @escaping (Bool)->()){
        guard let url = URL(string: "https://sosfuncs.azurewebsites.net/api/authUser") else {
            print("Invalid URL")
//            completion(false)
            return
        }
        print("url ok")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = [
            "username": username,
            "password": password
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        print(json)
        URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
            guard let dataResponse = data,
                      error == nil else {
                      print(error?.localizedDescription ?? "Response Error")
                      return }
            do{
                //            let dataString = String(data: data, encoding: .utf8)
                //                print(dataString)
                                
                let jsonResponse = try JSONSerialization.jsonObject(with:dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                      return
                }
                if(jsonArray.isEmpty){
                    completion(false)
                }else{
                    let dic = jsonArray[0]
                    guard let name = dic["name"] as? String else { return }
                    print(name)
                    guard let phoneNumber = dic["phone"] as? String else { return }
                    print(phoneNumber)
                    DispatchQueue.main.async {
                        usernameInfo.name = name
                        usernameInfo.phone = phoneNumber
                    }
                    UserDefaults.standard.set(name, forKey: "name")
                    UserDefaults.standard.set(phoneNumber, forKey: "phone")
                    
                    completion(true)
                }
                
//                                if dataResponse == "OK"{
//                //                    authenticationOk = true
//                //                authenticationDidFail = false
//                //                    DispatchQueue.main.async {
//                //                        loggedUsername.username = self.username
//                //                        modelData.fillContacts(username: username)
//                //                    }
//                                    print("OKKKK")
//                                    completion(true)
//                                }else{
//                //                    authenticationOk = false
//                //                    authenticationDidFail = true
//                //                    print("wowzzzzz")
//                                        completion(false)
//
//                                }
            }catch let parsingError {
                print("Error", parsingError)
                completion(false)
        }
            

                return
            
//            // if we're still here it means there was a problem
//            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
        return
    }
}


struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

struct LogInButtonContent: View {
    var body: some View {
        Text("Log In")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.blue)
            .cornerRadius(15.0)
    }
}

struct SignUpButtonContent: View {
    var body: some View {
        Text("Sign Up")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}



struct UsernameTextField: View {
    @Binding var username: String
    var body: some View {
        
        TextField("Username", text: $username)
            .padding()
            .border(Color.pink, width: 2)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
            .disableAutocorrection(true)
    }
}

struct PasswordSecureField: View {
    @Binding var password: String
    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .border(Color.pink, width: 2)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .disableAutocorrection(true)
    }
}
