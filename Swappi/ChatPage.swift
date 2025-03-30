//
//  ChatPage.swift
//  Swappi
//
//  Created by Nysa Jain on 29/03/25.
//


import SwiftUI

struct ChatPage: View {
    let userName: String
    let vibeEmoji: String

    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hey! Super excited to learn painting from you!", isMe: false),
        ChatMessage(text: "Sameee! I’ve been wanting to swap with someone who knows watercolor 🎨", isMe: true),
        ChatMessage(text: "Do you have time tomorrow afternoon?", isMe: false),
        ChatMessage(text: "Yep, let's set it for 3pm?", isMe: true)
    ]

    @State private var newMessage: String = ""

    var body: some View {
        VStack {
            HStack(spacing: 8) {
                Text(vibeEmoji)
                Text(userName)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(messages) { msg in
                        HStack {
                            if msg.isMe { Spacer() }

                            Text(msg.text)
                                .padding()
                                .background(msg.isMe ? Color.blue.opacity(0.2) : Color.white.opacity(0.7))
                                .foregroundColor(.primary)
                                .cornerRadius(16)
                                .frame(maxWidth: 260, alignment: msg.isMe ? .trailing : .leading)

                            if !msg.isMe { Spacer() }
                        }
                        .padding(.horizontal)
                    }
                }
            }

            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 44)

                Button(action: {
                    if !newMessage.isEmpty {
                        messages.append(ChatMessage(text: newMessage, isMe: true))
                        newMessage = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .padding(.horizontal, 8)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isMe: Bool
}

#Preview {
    ChatPage(userName: "Nysa", vibeEmoji: "😭")
}
