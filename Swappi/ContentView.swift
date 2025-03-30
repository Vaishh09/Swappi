import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    var body: some View {
        if isLoggedIn {
            MainView()
        } else {
            FrontPage() 
        }
    }
}

#Preview {
    ContentView()
}
