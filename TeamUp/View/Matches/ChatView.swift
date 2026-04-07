//
//  Untitled.swift
//  TeamUp
//
//  Created by Ilyes Mo on 06/04/2026.
//



import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// Message model
struct Message: Identifiable {
    var id: String
    var text: String
    var senderUID: String
    var timestamp: Date
    
    // Check if message was sent by current user
    var isFromCurrentUser: Bool {
        return senderUID == Auth.auth().currentUser?.uid
    }
}

struct ChatView: View {
    
    let match: Match
    
    @State private var messages: [Message] = []
    @State private var newMessage = ""
    @State private var isLoading = true
    
    // Firestore reference
    let db = Firestore.firestore()
    
    var body: some View {
        ZStack {
            Color(hex: "FDF6EC").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Messages list
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            if isLoading {
                                ProgressView()
                                    .tint(Color(red: 0.498, green: 0.467, blue: 0.867))
                                    .padding()
                            } else if messages.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "bubble.left.and.bubble.right")
                                        .font(.system(size: 50))
                                        .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867).opacity(0.5))
                                    Text("Start the conversation!")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 100)
                            } else {
                                ForEach(messages) { message in
                                    MessageBubble(message: message)
                                        .id(message.id)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 16)
                    }
                    // Auto scroll to latest message
                    .onChange(of: messages.count) { _ in
                        if let lastMessage = messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Message input bar
                HStack(spacing: 12) {
                    TextField("Type a message...", text: $newMessage, axis: .vertical)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(20)
                        .lineLimit(1...4)
                    
                    // Send button
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                newMessage.isEmpty ?
                                Color.gray.opacity(0.3) :
                                Color(red: 0.498, green: 0.467, blue: 0.867)
                            )
                            .clipShape(Circle())
                    }
                    .disabled(newMessage.isEmpty)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color(hex: "FDF6EC"))
            }
        }
        .navigationTitle(match.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadMessages()
            NotificationCenter.default.post(name: Notification.Name("hideTabBar"), object: nil)
        }
        .onDisappear {
            NotificationCenter.default.post(name: Notification.Name("showTabBar"), object: nil)
        }
    }
    
    // Load messages in real time using Firestore listener
    
    func loadMessages() {
        let chatId = getChatId()
        
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                isLoading = false
                guard let documents = snapshot?.documents else { return }
                
                // Convert Firestore documents to Message objects
                messages = documents.compactMap { doc in
                    let data = doc.data()
                    guard let text = data["text"] as? String,
                          let senderUID = data["senderUID"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else { return nil }
                    
                    return Message(
                        id: doc.documentID,
                        text: text,
                        senderUID: senderUID,
                        timestamp: timestamp.dateValue()
                    )
                }
            }
    }
    
    // Send a new message to Firestore
    func sendMessage() {
        guard let uid = Auth.auth().currentUser?.uid,
              !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let chatId = getChatId()
        let messageText = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        newMessage = ""
        
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .addDocument(data: [
                "text": messageText,
                "senderUID": uid,
                "timestamp": Timestamp()
            ])
    }
    
    // Generate consistent chat ID from two user UIDs
    func getChatId() -> String {
        guard let currentUID = Auth.auth().currentUser?.uid else { return "" }
        // Sort UIDs so the chat ID is the same regardless of who opens it
        let uids = [currentUID, match.uid].sorted()
        return "\(uids[0])_\(uids[1])"
    }
}

// Individual message bubble
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser { Spacer() }
            
            VStack(alignment: message.isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(.system(size: 16))
                    .foregroundColor(message.isFromCurrentUser ? .white : .primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        message.isFromCurrentUser ?
                        Color(red: 0.498, green: 0.467, blue: 0.867) :
                        Color.white
                    )
                    .cornerRadius(18)
                
                // Timestamp
                Text(formatTime(message.timestamp))
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }
            
            if !message.isFromCurrentUser { Spacer() }
        }
    }
    
    // Format timestamp to show time only
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


