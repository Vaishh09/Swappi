import SwiftUI

struct FrontPage: View {
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.92, green: 0.87, blue: 0.99),
                        Color(red: 0.85, green: 0.80, blue: 0.95)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image("Swappi")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)

                    Text("Welcome to Swappi!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.25, green: 0.25, blue: 0.35))

                    VStack(spacing: 16) {
                        NavigationLink(destination: LoginPage()) {
                            Text("Sign In")
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.25, green: 0.25, blue: 0.35))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 0.75, green: 0.87, blue: 0.95))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                        }
                        
                        NavigationLink(destination: CreateAccPage()) {
                            Text("Create Account")
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.25, green: 0.25, blue: 0.35))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 0.75, green: 0.87, blue: 0.95))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 40)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct FrontPage_Previews: PreviewProvider {
    static var previews: some View {
        FrontPage()
    }
}
