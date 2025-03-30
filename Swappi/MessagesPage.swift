import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MessagesPage: View {
    @State private var messagePreviews: [MessagePreview] = [
        MessagePreview(
            name: "Alex Chen",
            lastMessage: "Hey, want to meet up for coffee tomorrow?",
            time: "2:30 PM",
            emoji: "☕️"
        ),
        MessagePreview(
            name: "Sarah Johnson",
            lastMessage: "Thanks for helping with the Python project!",
            time: "12:45 PM",
            emoji: "👩🏽‍💻"
        ),
        MessagePreview(
            name: "Mike Rodriguez",
            lastMessage: "Did you see the new photography exhibit?",
            time: "Yesterday",
            emoji: "📸"
        ),
        MessagePreview(
            name: "Taylor Swift",
            lastMessage: "I finished reading that book you recommended",
            time: "Yesterday",
            emoji: "📚"
        ),
        MessagePreview(
            name: "Jamie Lee",
            lastMessage: "Let's practice meditation together next week",
            time: "Sunday",
            emoji: "🧘‍♀️"
        ),
        MessagePreview(
            name: "Raj Patel",
            lastMessage: "I'll send you the UI design files soon",
            time: "Saturday",
            emoji: "🎨"
        ),
        MessagePreview(
            name: "Emma Wilson",
            lastMessage: "How was the cooking class?",
            time: "Friday",
            emoji: "👨‍🍳"
        ),
        MessagePreview(
            name: "Carlos Mendez",
            lastMessage: "Thanks for being my study buddy!",
            time: "3/25",
            emoji: "📝"
        )
    ]
    
    let pastelTints: [Color] = [
        Color(red: 0.94, green: 0.97, blue: 1.0),
        Color(red: 1.0, green: 0.95, blue: 0.95),
        Color(red: 0.95, green: 1.0, blue: 0.95),
        Color(red: 1.0, green: 0.98, blue: 0.9),
        Color(red: 0.96, green: 0.94, blue: 1.0)
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                headerView
                messagesList
            }
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
    }
    
    
    private var headerView: some View {
        HStack {
            Spacer()
            Text("Messages")
                .font(.system(size: 28, weight: .bold))
                .padding(.top, 30)
            Spacer()
        }
    }
    
    
    private var messagesList: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    
                    HStack {
                        Text("Active Now")
                            .font(.headline)
                            .padding(.leading)
                            .padding(.top, 16)
                        Spacer()
                    }
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(Array(zip(["Alex Chen", "Sarah Johnson", "Raj Patel", "Emma Wilson"], ["☕️", "👩🏽‍💻", "🎨", "👨‍🍳"])), id: \.0) { name, emoji in
                                VStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 60, height: 60)
                                            .shadow(color: .black.opacity(0.05), radius: 2)
                                        
                                        Text(emoji)
                                            .font(.system(size: 24))
                                    }
                                    
                                    Text(name.components(separatedBy: " ").first ?? "")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 8, height: 8)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    
                    HStack {
                        Text("Recent Messages")
                            .font(.headline)
                            .padding(.leading)
                        Spacer()
                    }
                    
                    
                    ForEach(Array(zip(messagePreviews.indices, messagePreviews)), id: \.0) { index, msg in
                        messageRow(msg, index: index)
                    }
                }
                .padding(.bottom, 100)
            }
        }
    }
    
    
    private func messageRow(_ msg: MessagePreview, index: Int) -> some View {
        NavigationLink(destination: ChatPage(userName: msg.name, moodEmoji: msg.emoji)) {
            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(pastelTints[index % pastelTints.count].opacity(0.7))
                        .frame(width: 50, height: 50)
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
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(msg.time)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    
                    if ["Alex Chen", "Raj Patel"].contains(msg.name) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(pastelTints[index % pastelTints.count].opacity(0.2))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.03), radius: 2, x: 0, y: 1)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
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
