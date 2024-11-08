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

    func login() {
        guard let url = URL(string: "http://localhost:8080/login") else {
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
            // Handle response
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
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

    func signup() {
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return
        }

        guard let url = URL(string: "http://localhost:8080/signup") else {
            errorMessage = "Invalid server URL."
            return
        }

        let signupData = ["email": email, "password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: signupData)

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
