import SwiftUI

struct LoginSignupView: View {
    @Environment(\.dismiss) var dismiss

    var onLogin: (() -> Void)? // Closure for login success notification

    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Login/Signup Picker
                Picker(selection: $isLoginMode, label: Text("")) {
                    Text("Login").tag(true)
                    Text("Signup").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Input Fields
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

                // Action Button
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

                // Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .navigationTitle(isLoginMode ? "Log In" : "Sign Up")
        }
    }

    func login() {
        guard let url = URL(string: "http://127.0.0.1:8080/login") else {
            errorMessage = "Invalid server URL."
            return
        }

        let loginData = ["email": email, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: loginData) else {
            errorMessage = "Failed to encode login data."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                guard let data = data else {
                    self.errorMessage = "No data received."
                    return
                }

                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    print("User signed in successfully!")
                    onLogin?() // Notify parent of login success
                    dismiss()  // Dismiss the view
                } else {
                    self.errorMessage = "Login failed. Please check your credentials."
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

        let signupData = ["email": email, "password": password, "confirmPassword": confirmPassword]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: signupData) else {
            errorMessage = "Failed to encode signup data."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                guard let data = data else {
                    self.errorMessage = "No data received."
                    return
                }

                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    print("User signed up successfully!")
                    onLogin?() // Notify parent of login success
                    dismiss()  // Dismiss the view
                } else {
                    self.errorMessage = "Signup failed. Please try again."
                }
            }
        }.resume()
    }
}

#Preview {
    LoginSignupView(onLogin: {
        print("Login successful!")
    })
}

