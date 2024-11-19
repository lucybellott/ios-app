//
//  LoginSignupView.swift
//  WoofWeather
//
//  Created by Lucy Bellott on 11/5/24.
//

import SwiftUI

struct LoginSignupView: View {
    @Environment(\.dismiss) var dismiss

    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Picker(selection: $isLoginMode, label: Text("")) {
                    Text("Login").tag(true)
                    Text("Signup").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Group {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)

                    if !isLoginMode {
                        SecureField("Confirm Password", text: $confirmPassword)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(5)
                    }
                }

                Button(action: {
                    if isLoginMode {
                        login()
                    } else {
                        signup()
                    }
                }) {
                    Text(isLoginMode ? "Log In" : "Sign Up")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(5)
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .navigationTitle(isLoginMode ? "Log In" : "Sign Up")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

//    func login() {
//        guard let url = URL(string: "http://127.0.0.1:8080/login") else {
//            errorMessage = "Invalid server URL."
//            return
//        }
//
//        let loginData = ["email": email, "password": password]
//        let jsonData = try? JSONSerialization.data(withJSONObject: loginData)
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = jsonData
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            // Handle response
//            DispatchQueue.main.async {
//                if let error = error {
//                    self.errorMessage = error.localizedDescription
//                    return
//                }
//                guard let data = data else {
//                    self.errorMessage = "No data received."
//                    return
//                }
//                // Process data
//                self.dismiss()
//            }
//        }.resume()
//    }
    
    func login() {
        guard let url = URL(string: "http://127.0.0.1:8080/login") else {
            errorMessage = "Invalid server URL."
            return
        }

        let loginData = ["email": email, "password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: loginData)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("Error logging in: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received."
                    print("Login failed: No data received.")
                    return
                }

                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        // Login successful
                        print("User signed in successfully!")
                        
                        // Optional: Process the response data
                        if let responseBody = String(data: data, encoding: .utf8) {
                            print("Response Body: \(responseBody)")
                        }

                        self.dismiss()
                    } else {
                        // Login failed with an HTTP error
                        self.errorMessage = "Login failed with status code: \(response.statusCode)"
                        print("Login failed: Status code \(response.statusCode)")
                    }
                } else {
                    print("Unexpected response format.")
                }
            }
        }.resume()
    }


    func signup() {
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return
        }

        guard let url = URL(string: "http://127.0.0.1:8080/signup") else {
            errorMessage = "Invalid server URL."
            return
        }

        let signupData = [
            "email": email,
            "password": password,
            "confirmPassword": confirmPassword
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: signupData) else {
            errorMessage = "Failed to serialize signup data."
            return
        }
        //debugging
        if let jsonString = String(data: jsonData, encoding: .utf8) {
             print("Request JSON: \(jsonString)")
         }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle response
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                     print("Request JSON: \(jsonString)")
                 }
                guard let data = data else {
                    self.errorMessage = "No data received."
                    return
                }
                // Process data 
                self.dismiss()
            }
        }.resume()
    }
}

#Preview {
    LoginSignupView()
}
