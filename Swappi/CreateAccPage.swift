//
//  CreateAccPage.swift
//  Swappi
//
//  Created by Asmi Kachare on 3/29/25.
//

import SwiftUI

struct CreateAccPage: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 1.0, green: 0.65, blue: 0.9), Color(red: 0.55, green: 0.85, blue: 1.0)]), startPoint: .topLeading, endPoint: .bottomTrailing)
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
                Spacer()
                VStack(spacing: 20) {
                    TextField("First Name", text: $firstName)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    TextField("Last Name", text: $lastName)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.none)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    HStack {
                        if isPasswordVisible {
                            TextField("Create Password", text: $password)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.none)
                        } else {
                            SecureField("Create Password", text: $password)
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
                    HStack {
                        if isConfirmPasswordVisible {
                            TextField("Confirm Password", text: $confirmPassword)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.none)
                        } else {
                            SecureField("Confirm Password", text: $confirmPassword)
                        }
                        Button(action: {
                            isConfirmPasswordVisible.toggle()
                        }) {
                            Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                Spacer()
                NavigationLink(destination: AboutYouPage()) {
                    Text("Next")
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

struct CreateAccPage_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccPage()
    }
}
