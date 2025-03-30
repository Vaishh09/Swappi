import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ChatPage: View {
    let userName: String
    let moodEmoji: String

    @FocusState private var isInputFocused: Bool
    @State private var messages: [ChatMessage] = []
    @State private var newMessage: String = ""
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    
    
    private var chatID: String {
        guard let currentUserName = Auth.auth().currentUser?.displayName else {
            return "unknown_chat"
        }
        return [currentUserName, userName].sorted().joined(separator: "_")
    }

    var body: some View {
        VStack {
            
            HStack(spacing: 8) {
                Text(moodEmoji)
                Text(userName)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)

            
            if isLoading {
                ProgressView()
                    .padding()
            } else if messages.isEmpty {
                VStack {
                    Spacer()
                    Text("No messages yet. Start the conversation!")
                        .foregroundColor(.gray)
                    Spacer()
                }
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 10) {
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
                                .id(msg.id)
                            }
                            
                            Color.clear.frame(height: 1).id("bottom")
                        }
                        .padding(.vertical, 8)
                    }
                    .onChange(of: messages) { _ in
                        withAnimation {
                            proxy.scrollTo("bottom", anchor: .bottom)
                        }
                    }
                }
            }
            
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }

            
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 250)
                    .focused($isInputFocused)
                    .disabled(isLoading)

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .padding(.horizontal, 8)
                        .foregroundColor(newMessage.isEmpty ? .gray : .blue)
                }
                .disabled(newMessage.isEmpty || isLoading)
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
        .onAppear {
            fetchMessages()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isInputFocused = true
            }
        }
    }

    func fetchMessages() {
        guard let _ = Auth.auth().currentUser else {
            self.errorMessage = "User not signed in"
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        let db = Firestore.firestore()
        db.collection("chats").document(chatID).collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "Error loading messages: \(error.localizedDescription)"
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.errorMessage = "No message documents found"
                    return
                }

                self.messages = documents.compactMap { doc -> ChatMessage? in
                    let data = doc.data()
                    guard let text = data["text"] as? String,
                          let sender = data["sender"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return nil
                    }
                    
                    let currentUser = Auth.auth().currentUser?.displayName ?? ""
                    return ChatMessage(
                        id: doc.documentID,
                        text: text,
                        isMe: sender == currentUser,
                        timestamp: timestamp.dateValue()
                    )
                }
                
                
                self.messages.sort { $0.timestamp < $1.timestamp }
            }
    }

    func sendMessage() {
        guard !newMessage.isEmpty else { return }
        
        guard let currentUser = Auth.auth().currentUser?.displayName else {
            self.errorMessage = "User not signed in"
            return
        }
        
        let trimmedMessage = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else {
            newMessage = ""
            return
        }
        
        
        let tempID = UUID().uuidString
        let tempMessage = ChatMessage(
            id: tempID,
            text: trimmedMessage,
            isMe: true,
            timestamp: Date()
        )
        
        self.messages.append(tempMessage)
        let messageToSend = trimmedMessage
        newMessage = ""

        let db = Firestore.firestore()
        let messageData: [String: Any] = [
            "text": messageToSend,
            "sender": currentUser,
            "timestamp": Timestamp(date: Date())
        ]

        db.collection("chats").document(chatID).collection("messages")
            .addDocument(data: messageData) { error in
                if let error = error {
                    self.errorMessage = "Failed to send: \(error.localizedDescription)"
                    
                    
                    self.messages.removeAll { $0.id == tempID }
                    
                    
                    self.newMessage = messageToSend
                }
            }
    }
}

struct ChatMessage: Identifiable, Equatable {
    var id: String
    var text: String
    var isMe: Bool
    var timestamp: Date
    
    init(id: String = UUID().uuidString, text: String, isMe: Bool, timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.isMe = isMe
        self.timestamp = timestamp
    }
}

#Preview {
    ChatPage(userName: "John", moodEmoji: "😊")
}
