//
//  LoginPage.swift
//  Swappi
//
//  Created by Asmi Kachare on 3/29/25.
//

import SwiftUI
import FirebaseAuth

struct LoginPage: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var username = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1.0, green: 0.65, blue: 0.9),
                    Color(red: 0.55, green: 0.85, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {

                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
                
                Image("Swappi")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.top, 0)
                
                Spacer()
                
                VStack(spacing: 20) {
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.none)
                    
                    HStack {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.none)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                Button(action: {
                    Auth.auth().signIn(withEmail: username, password: password) { result, error in
                        if error == nil {
                            isLoggedIn = true
                        }
                    }
                }) {
                    Text("Sign In")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)

            }
        }
        .navigationBarHidden(true)
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
