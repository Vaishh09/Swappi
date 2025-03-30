//
//  MessagesPage.swift
//  Swappi
//
//  Created by Asmi Kachare on 3/29/25.
//

import SwiftUI

struct MessagesPage: View {
    let messages: [MessagePreview] = [
        MessagePreview(name: "Aanya", lastMessage: "Let’s meet at 4?", time: "2:45 PM", emoji: "🎨"),
        MessagePreview(name: "Dev", lastMessage: "Sent the notes!", time: "1:12 PM", emoji: "📚"),
        MessagePreview(name: "Maya", lastMessage: "Skill swap tomorrow?", time: "12:01 PM", emoji: "🧘‍♀️"),
        MessagePreview(name: "Zayn", lastMessage: "Loved your playlist!", time: "10:30 AM", emoji: "🎧"),
        MessagePreview(name: "Sara", lastMessage: "Done! 😊", time: "Yesterday", emoji: "🧁")
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text("Messages")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 30)
                    Spacer()
                }

                NavigationView {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(messages) { msg in
                                NavigationLink(destination: ChatPage(userName: msg.name, vibeEmoji: msg.emoji)) {
                                    HStack(alignment: .top, spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.white.opacity(0.5))
                                                .frame(width: 46, height: 46)
                                            Text(msg.emoji)
                                                .font(.system(size: 24))
                                        }

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(msg.name)
                                                .font(.headline)

                                            Text(msg.lastMessage)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                        }

                                        Spacer()

                                        Text(msg.time)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                }
                            }
                        }
                        .padding(.bottom, 100)
                    }
                }
            }

            
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
    }
}

struct MessagePreview: Identifiable {
    let id = UUID()
    let name: String
    let lastMessage: String
    let time: String
    let emoji: String
}

#Preview {
    MessagesPage()
}
