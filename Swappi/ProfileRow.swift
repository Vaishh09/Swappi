import SwiftUI

struct ProfileRow: View {
    let profile: UserProfile
    
    var body: some View {
        HStack(spacing: 16) {
            Text(profile.mood) 
                .font(.system(size: 40))
                .frame(width: 60, height: 60)
                .background(Color.white.opacity(0.5))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {
                Text(profile.name)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(profile.skillsKnown.joined(separator: " • "))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 2)
        .padding(.horizontal)
    }
}
