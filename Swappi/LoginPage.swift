import SwiftUI
import FirebaseAuth

struct LoginPage: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""      // Changed from username to email
    @State private var password = ""
    @State private var isPasswordVisible = false
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            // Background Gradient
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
                // Back Button
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
                
                // App Logo
                Image("Swappi")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.top, 0)
                
                Spacer()
                
                // Input Fields
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
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
                    
                    // Error Message
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Loading Indicator
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.bottom, 20)
                }
                
                // Sign In Button
                Button(action: {
                    signIn()
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
    
    // MARK: - Sign In Function
    func signIn() {
        // Clear any previous error and start loading
        errorMessage = nil
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
                print("Error signing in: \(error.localizedDescription)")
            } else {
                isLoggedIn = true
            }
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
