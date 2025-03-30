# 🌟 Swappi – Skill Swap Meets Vibes 🌈

Swappi is your new favorite way to meet people *near you* by **exchanging skills, sharing vibes**, and starting real conversations. Whether you want to learn guitar 🎸, teach design 🎨, or just meet someone who’s also craving matcha 🍵 today — **Swappi matches you accordingly.**

Built in under 24 hours at WiCS Hackathon 2025, Swappi is a SwiftUI + Firebase powered iOS app that makes social skill-sharing effortless and fun.

---

## 🚀 Features

✅ **Create Your Profile**
- Upload 3+ photos + voice or video intro
- Add skills you know 🧠 and skills you want to learn 🎯
- Set today’s vibe: mood emoji + food/drink choice

🤝 **Match Based on Skill & Vibe**
- Smart matching algorithm using AI-like filtering (mood, skills, vibe)
- Browse an Explore page filled with the best matches near you

📬 **Swipe / Like / Match**
- Like someone? Tap Match 🤝 and we log the connection in Firebase
- (Chat coming soon!)

📂 **Firebase-Powered Backend**
- Authentication (Login / Signup)
- Firestore to store users and matches
- Firebase Storage for photo/video uploads

---

## 📱 Built With

- **SwiftUI** – Clean declarative UI
- **Firebase** – Auth, Firestore, and Storage
- **Xcode** – Swift Package Manager for Firebase SDK
- **❤️ Team Spirit** – We didn’t sleep and we’re proud of it 😅

---

## 🔧 Setup Instructions
1. 🚀 Clone the Repo
bash
Copy
Edit
git clone https://github.com/your-username/Swappi.git
cd Swappi
git checkout dev_nysa
3. 📂 Open the Project
Open Swappi.xcodeproj or Swappi.xcworkspace (if using CocoaPods)

Recommended: Use Xcode 15+

3. 🔥 Add Firebase Configuration
Go to Firebase Console

Create an iOS project (if not already created)

Download GoogleService-Info.plist

Drag and drop it into your Xcode project (in the main target)

4. 📦 Install Firebase SDK (via Swift Package Manager)
In Xcode:
File > Add Packages...
Paste this URL:

arduino
Copy
Edit
https://github.com/firebase/firebase-ios-sdk
Add these packages:

✅ FirebaseAuth

✅ FirebaseFirestore

✅ FirebaseStorage

5. ✅ Build & Run
Select a simulator or your iPhone

Press Cmd + R or click the ▶️ button in Xcode
