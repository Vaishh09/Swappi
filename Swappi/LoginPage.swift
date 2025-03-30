import SwiftUI
import FirebaseAuth

struct LoginPage: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var username = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    
    let cream = Color(red: 0.98, green: 0.96, blue: 0.90)
    let lightBlue = Color(red: 0.75, green: 0.87, blue: 0.95)
    let lightPink = Color(red: 0.96, green: 0.76, blue: 0.85)
    let lightGreen = Color(red: 0.80, green: 0.95, blue: 0.82)
    let darkText = Color(red: 0.25, green: 0.25, blue: 0.35)
    
    var body: some View {
        ZStack {
            
            cream.ignoresSafeArea()
            
            
            ZStack {
                
                Circle()
                    .fill(lightPink.opacity(0.2))
                    .frame(width: 200, height: 200)
                    .blur(radius: 30)
                    .offset(x: 120, y: -280)
                
                Circle()
                    .fill(lightBlue.opacity(0.2))
                    .frame(width: 250, height: 250)
                    .blur(radius: 35)
                    .offset(x: -120, y: 350)
                
                Circle()
                    .fill(lightGreen.opacity(0.15))
                    .frame(width: 180, height: 180)
                    .blur(radius: 25)
                    .offset(x: -100, y: -200)
                
                
                ForEach(0..<5) { i in
                    Circle()
                        .fill([lightPink, lightBlue, lightGreen][i % 3].opacity(0.3))
                        .frame(width: CGFloat.random(in: 40...80), height: CGFloat.random(in: 40...80))
                        .blur(radius: CGFloat.random(in: 5...15))
                        .offset(
                            x: CGFloat.random(in: -150...150),
                            y: CGFloat.random(in: -300...300)
                        )
                }
                
                
                ForEach(0..<20) { i in
                    Circle()
                        .fill([lightPink, lightBlue, lightGreen][i % 3].opacity(0.6))
                        .frame(width: CGFloat.random(in: 5...12), height: CGFloat.random(in: 5...12))
                        .blur(radius: CGFloat.random(in: 0...2))
                        .offset(
                            x: CGFloat.random(in: -180...180),
                            y: CGFloat.random(in: -350...350)
                        )
                }
            }
            
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(darkText)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top, 10)
                
                
                Image("Swappi")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .shadow(color: lightPink.opacity(0.5), radius: 15, x: 5, y: 5)
                    .shadow(color: lightBlue.opacity(0.5), radius: 15, x: -5, y: -5)
                    .padding(.top, 0)
                    .padding(.bottom, -80)
                
                Spacer()
                
                VStack(spacing: 20) {
                    
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                        .foregroundColor(darkText)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.none)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lightBlue.opacity(username.isEmpty ? 0 : 0.5), lineWidth: 1.5)
                        )
                        .animation(.easeInOut(duration: 0.2), value: username)
                    
                    
                    HStack {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.none)
                                .foregroundColor(darkText)
                        } else {
                            SecureField("Password", text: $password)
                                .foregroundColor(darkText)
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(darkText.opacity(0.6))
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lightBlue.opacity(password.isEmpty ? 0 : 0.5), lineWidth: 1.5)
                    )
                    .animation(.easeInOut(duration: 0.2), value: password)
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
                        .foregroundColor(darkText)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [lightBlue, lightBlue.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.6), lineWidth: 1)
                        )
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
