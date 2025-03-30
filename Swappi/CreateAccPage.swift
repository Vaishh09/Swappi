import SwiftUI
import FirebaseAuth

struct CreateAccPage: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isLoggedIn") var isLoggedIn = false  // This remains for later use
    @State private var shouldNavigateToAboutYou = false  // New flag for navigation

    // Basic account fields
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false

    // For showing errors and a loading indicator
    @State private var isUploading = false
    @State private var uploadError: String? = nil

    var body: some View {
        NavigationStack {
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
                    // Top bar with back button
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

                    // Input Fields
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

                    // Show a progress indicator and error messages if needed
                    if isUploading {
                        ProgressView("Creating Account...")
                            .padding(.bottom, 10)
                    }
                    if let error = uploadError {
                        Text("❌ \(error)")
                            .foregroundColor(.red)
                    }

                    // Button to create the account
                    Button(action: {
                        // Basic validations
                        guard password == confirmPassword, !email.isEmpty, !firstName.isEmpty else {
                            uploadError = "Please complete all fields."
                            return
                        }

                        isUploading = true

                        // Create the user account with Firebase Auth only.
                        Auth.auth().createUser(withEmail: email, password: password) { result, error in
                            isUploading = false
                            if let error = error {
                                uploadError = error.localizedDescription
                                return
                            }
                            // Account created successfully; now navigate to AboutYouPage.
                            shouldNavigateToAboutYou = true
                        }
                    }) {
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

                    // Hidden NavigationLink triggered on successful account creation.
                    NavigationLink(destination: AboutYouPage(), isActive: $shouldNavigateToAboutYou) {
                        EmptyView()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct CreateAccPage_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccPage()
    }
}
