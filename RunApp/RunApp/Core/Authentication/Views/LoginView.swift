//
//  LoginView.swift
//  RunningApp
//
//  Created by user265613 on 10/21/24.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack{
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
                    InputView(text: $username,
                              title: "Username",
                              placeholder: "Enter your username")
                    .autocapitalization(.none)
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top,12)
                
                //sign in button
                Button{
                    Task{
                        try await viewModel.signIn(withUsername: username, password: password)
                    }
                }label: {
                    HStack{
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height:48)
                }
                .background(Color(.systemGray))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top,24)
                Spacer()
                
                //sign up button
                NavigationLink{
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                }label: {
                    HStack{
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.black)
                }
                .font(.system(size:18))
               
                
            }
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool{
        return !username.isEmpty
        && !password.isEmpty
        && password.count > 5
    }
}

#Preview {
    LoginView()
}
