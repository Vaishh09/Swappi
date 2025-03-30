import SwiftUI
import FirebaseAuth

struct AccPageColors {
    
    static let cream = Color(red: 0.98, green: 0.96, blue: 0.90)
    static let lightBlue = Color(red: 0.75, green: 0.87, blue: 0.95)
    static let lightGreen = Color(red: 0.80, green: 0.95, blue: 0.82)
    static let lightPink = Color(red: 0.96, green: 0.76, blue: 0.85)
    
    
    static let gradientTop = cream
    static let gradientBottom = Color(red: 0.95, green: 0.93, blue: 0.87)
    
    
    static let primaryButton = lightBlue
    static let secondaryButton = lightGreen
    static let deleteButton = Color(red: 0.96, green: 0.85, blue: 0.82)
    static let saveButton = lightGreen
    
    
    static let darkText = Color(red: 0.25, green: 0.25, blue: 0.35)
}

struct CreateAccPage: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isLoggedIn") var isLoggedIn = false

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false

    @StateObject var profileVM = ProfileViewModel()
    @State private var isUploading = false
    @State private var uploadError: String? = nil

    
    @State private var selectedImages: [UIImage] = []
    @State private var introVideoURL: URL? = nil
    @State private var mood: String = "😊"
    @State private var vibe: String = "Coffee & Chill"
    @State private var skillsKnown: [String] = ["Swift", "UI Design"]
    @State private var skillsWanted: [String] = ["React", "Marketing"]
    @State private var note: String = "Excited to swap skills!"

    var body: some View {
        ZStack {
            
            LinearGradient(
                gradient: Gradient(colors: [
                    AccPageColors.gradientTop,
                    AccPageColors.gradientBottom
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            
            ZStack {
                
                Circle()
                    .fill(AccPageColors.lightPink.opacity(0.2))
                    .frame(width: 200, height: 200)
                    .blur(radius: 30)
                    .offset(x: 120, y: -280)
                
                Circle()
                    .fill(AccPageColors.lightBlue.opacity(0.2))
                    .frame(width: 250, height: 250)
                    .blur(radius: 35)
                    .offset(x: -120, y: 350)
                
                Circle()
                    .fill(AccPageColors.lightGreen.opacity(0.15))
                    .frame(width: 180, height: 180)
                    .blur(radius: 25)
                    .offset(x: -100, y: -200)
                
                
                ForEach(0..<5) { i in
                    Circle()
                        .fill([AccPageColors.lightPink, AccPageColors.lightBlue, AccPageColors.lightGreen][i % 3].opacity(0.3))
                        .frame(width: CGFloat.random(in: 40...80), height: CGFloat.random(in: 40...80))
                        .blur(radius: CGFloat.random(in: 5...15))
                        .offset(
                            x: CGFloat.random(in: -150...150),
                            y: CGFloat.random(in: -300...300)
                        )
                }
                
                
                ForEach(0..<20) { i in
                    Circle()
                        .fill([AccPageColors.lightPink, AccPageColors.lightBlue, AccPageColors.lightGreen][i % 3].opacity(0.6))
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
                            .foregroundColor(AccPageColors.darkText)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top, 10)
                
                
                Image("Swappi")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .shadow(color: AccPageColors.lightPink.opacity(0.5), radius: 15, x: 5, y: 5)
                    .shadow(color: AccPageColors.lightBlue.opacity(0.5), radius: 15, x: -5, y: -5)
                
                Spacer()
                
                VStack(spacing: 20) {
                    
                    TextField("First Name", text: $firstName)
                        .padding()
                        .background(AccPageColors.cream)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                        .foregroundColor(AccPageColors.darkText)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(AccPageColors.lightBlue.opacity(firstName.isEmpty ? 0 : 0.5), lineWidth: 1.5)
                        )
                        .animation(.easeInOut(duration: 0.2), value: firstName)
                    
                    
                    TextField("Last Name", text: $lastName)
                        .padding()
                        .background(AccPageColors.cream)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                        .foregroundColor(AccPageColors.darkText)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(AccPageColors.lightBlue.opacity(lastName.isEmpty ? 0 : 0.5), lineWidth: 1.5)
                        )
                        .animation(.easeInOut(duration: 0.2), value: lastName)
                    
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.none)
                        .padding()
                        .background(AccPageColors.cream)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                        .foregroundColor(AccPageColors.darkText)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(AccPageColors.lightBlue.opacity(email.isEmpty ? 0 : 0.5), lineWidth: 1.5)
                        )
                        .animation(.easeInOut(duration: 0.2), value: email)
                    
                    
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .padding()
                        .background(AccPageColors.cream)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                        .foregroundColor(AccPageColors.darkText)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(AccPageColors.lightBlue.opacity(phoneNumber.isEmpty ? 0 : 0.5), lineWidth: 1.5)
                        )
                        .animation(.easeInOut(duration: 0.2), value: phoneNumber)
                    
                    
                    HStack {
                        if isPasswordVisible {
                            TextField("Create Password", text: $password)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.none)
                                .foregroundColor(AccPageColors.darkText)
                        } else {
                            SecureField("Create Password", text: $password)
                                .foregroundColor(AccPageColors.darkText)
                        }
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(AccPageColors.darkText.opacity(0.6))
                        }
                    }
                    .padding()
                    .background(AccPageColors.cream)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(AccPageColors.lightBlue.opacity(password.isEmpty ? 0 : 0.5), lineWidth: 1.5)
                    )
                    .animation(.easeInOut(duration: 0.2), value: password)
                    
                    
                    HStack {
                        if isConfirmPasswordVisible {
                            TextField("Confirm Password", text: $confirmPassword)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.none)
                                .foregroundColor(AccPageColors.darkText)
                        } else {
                            SecureField("Confirm Password", text: $confirmPassword)
                                .foregroundColor(AccPageColors.darkText)
                        }
                        Button(action: {
                            isConfirmPasswordVisible.toggle()
                        }) {
                            Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(AccPageColors.darkText.opacity(0.6))
                        }
                    }
                    .padding()
                    .background(AccPageColors.cream)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(AccPageColors.lightBlue.opacity(confirmPassword.isEmpty ? 0 : 0.5), lineWidth: 1.5)
                    )
                    .animation(.easeInOut(duration: 0.2), value: confirmPassword)
                }
                .padding(.horizontal, 40)
                
                Spacer()

                if isUploading {
                    ProgressView("Uploading...")
                        .foregroundColor(AccPageColors.darkText)
                        .padding(.bottom, 10)
                }

                if let error = uploadError {
                    Text("❌ \(error)")
                        .foregroundColor(AccPageColors.deleteButton)
                        .padding(.vertical, 5)
                }

                
                Button(action: {
                    guard password == confirmPassword, !email.isEmpty, !firstName.isEmpty, let videoURL = introVideoURL else {
                        uploadError = "Please complete all fields."
                        return
                    }

                    isUploading = true
                    
                    FirebaseStorageManager.uploadMultipleImages(selectedImages) { imageURLs in
                        FirebaseStorageManager.uploadIntroMedia(fileURL: videoURL) { result in
                            switch result {
                            case .success(let videoURL):
                                let profile = UserProfile(
                                    id: Auth.auth().currentUser?.uid ?? "",
                                    name: firstName + " " + lastName,
                                    email: email,
                                    skillsKnown: skillsKnown,
                                    skillsWanted: skillsWanted,
                                    vibe: vibe,
                                    mood: mood,
                                    note: note,
                                    profilePhotos: imageURLs,
                                    introMediaURL: videoURL
                                )

                                profileVM.saveUserProfile(profile: profile) { result in
                                    isUploading = false
                                    switch result {
                                    case .success():
                                        isLoggedIn = true
                                    case .failure(let error):
                                        uploadError = error.localizedDescription
                                    }
                                }

                            case .failure(let error):
                                isUploading = false
                                uploadError = error.localizedDescription
                            }
                        }
                    }
                }) {
                    Text("Next")
                        .fontWeight(.semibold)
                        .foregroundColor(AccPageColors.darkText)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [AccPageColors.primaryButton, AccPageColors.primaryButton.opacity(0.8)]),
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

struct CreateAccPage_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccPage()
    }
}
