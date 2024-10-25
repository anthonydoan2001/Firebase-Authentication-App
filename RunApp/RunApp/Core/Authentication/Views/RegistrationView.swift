//
//  RegistrationView.swift
//  RunningApp
//
//  Created by user265613 on 10/21/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isUsernameValid: Bool? = nil // To track if username is valid or not
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack{
            Image("bb")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical)
            Text("Bigs Boos Development")
                .fontWeight(.heavy)
                .font(.title)
            
            //form fields
            VStack(spacing: 24){
                ZStack(alignment: .trailing){
                    InputView(text: $username,
                              title: "Username",
                              placeholder: "Enter your username")
                        .autocapitalization(.none)
                        .onChange(of: username) { newValue in
                            // Trigger a check when the username changes
                            Task {
                                isUsernameValid = try await viewModel.checkUsernameAvailability(username: newValue)
                            }
                        }
                    
                    if let isUsernameValid = isUsernameValid {
                        Image(systemName: isUsernameValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(isUsernameValid ? .green : .red)
                    }
                }
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                
                ZStack(alignment: .trailing){
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Confirm your password",
                              isSecureField: true)
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword{
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button{
                Task{
                    try await viewModel.createUser(withUsername: username, password: password)
                }
            }label: {
                HStack{
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height:48)
            }
            .background(Color(.systemGray))
            .disabled(!formIsValid || isUsernameValid == false) // Disable if form is invalid or username is taken
            .opacity(formIsValid && isUsernameValid != false ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top,24)
            Spacer()
            
            Button{
                dismiss()
            }label: {
                HStack{
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
        }
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool{
        return !username.isEmpty
        && !password.isEmpty
        && password.count > 5
        && password == confirmPassword
    }
}
