import SwiftUI
import PhotosUI
import AVFoundation
import FirebaseAuth
import UniformTypeIdentifiers

struct PastelColors {
    
    static let cream = Color(red: 0.98, green: 0.96, blue: 0.90)
    static let lightBlue = Color(red: 0.75, green: 0.87, blue: 0.95)
    static let lightGreen = Color(red: 0.80, green: 0.95, blue: 0.82)
    static let paleYellow = Color(red: 0.98, green: 0.96, blue: 0.80)
    
    
    static let gradientTop = cream
    static let gradientBottom = Color(red: 0.95, green: 0.93, blue: 0.87)
    
    
    static let primaryButton = lightBlue
    static let secondaryButton = lightGreen
    static let deleteButton = Color(red: 0.96, green: 0.85, blue: 0.82)
    static let saveButton = Color(red: 0.70, green: 0.90, blue: 0.75)
    
    
    static let darkText = Color(red: 0.25, green: 0.25, blue: 0.35)
}

struct PastelTextField: ViewModifier {
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(backgroundColor)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
            .padding(.vertical, 5)
    }
}

struct PastelButton: ButtonStyle {
    var backgroundColor: Color
    var textColor: Color = .white
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .foregroundColor(textColor)
            .animation(.spring(), value: configuration.isPressed)
    }
}

struct PastelBubbleTag: View {
    let text: String
    var backgroundColor: Color = PastelColors.lightBlue
    var onDelete: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 6) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(1)
            
            if let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(backgroundColor)
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct MoodVibeSection: View {
    @Binding var moodEmoji: String
    @Binding var vibeNote: String
    
    var body: some View {
        VStack(spacing: 15) {
            TextField("Tell us your mood in an emoji", text: $moodEmoji)
                .modifier(PastelTextField(backgroundColor: PastelColors.cream))
                .foregroundColor(PastelColors.darkText)
            
            TextField("Describe your vibe today in three or more words", text: $vibeNote)
                .modifier(PastelTextField(backgroundColor: PastelColors.cream))
                .foregroundColor(PastelColors.darkText)
        }
        .padding(.horizontal)
    }
}

struct DynamicInputSection: View {
    let title: String
    @Binding var items: [String]
    @Binding var newItem: String
    var onAdd: () -> Void
    
    
    private func colorForIndex(_ index: Int) -> Color {
        let colors = [PastelColors.lightBlue, PastelColors.lightGreen]
        return colors[index % colors.count]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(PastelColors.darkText)
            
            HStack {
                TextField("Enter \(title.lowercased())", text: $newItem)
                    .modifier(PastelTextField(backgroundColor: PastelColors.cream))
                    .foregroundColor(PastelColors.darkText)
                    .disabled(items.count >= 5)
                
                
                Button(action: {
                    if items.count < 5 {
                        onAdd()
                    }
                }) {
                    Text("Add")
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(items.count < 5 ? PastelColors.lightGreen : Color.gray)
                        .cornerRadius(8)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(items.prefix(5).enumerated()), id: \.element) { index, item in
                        PastelBubbleTag(text: item, backgroundColor: colorForIndex(index)) {
                            if let idx = items.firstIndex(of: item) {
                                items.remove(at: idx)
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .animation(.spring(), value: items)
        }
        .padding(.horizontal)
    }
}

struct SaveProfileSection: View {
    @Binding var isSaving: Bool
    @Binding var error: String?
    var action: () -> Void
    
    var body: some View {
        Group {
            if isSaving {
                ProgressView("Saving Profile...")
                    .foregroundColor(PastelColors.darkText)
                    .padding(.bottom, 5)
            }
            if let error = error {
                Text("❌ \(error)")
                    .foregroundColor(PastelColors.deleteButton)
                    .padding(.vertical, 5)
            }
            
            
            Button(action: action) {
                Text("Save Profile")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(PastelColors.saveButton)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}


struct VideoAudioSection: View {
    @Binding var mediaSelection: AboutYouPage.MediaType
    @Binding var videoURL: URL?
    @Binding var audioURL: URL?
    @Binding var isShowingVideoPickerSheet: Bool
    @Binding var isShowingAudioRecorder: Bool
    @Binding var videoSourceType: UIImagePickerController.SourceType
    
    init(mediaSelection: Binding<AboutYouPage.MediaType>,
         videoURL: Binding<URL?>,
         audioURL: Binding<URL?>,
         isShowingVideoPickerSheet: Binding<Bool>,
         isShowingAudioRecorder: Binding<Bool>,
         videoSourceType: Binding<UIImagePickerController.SourceType>) {
        
        self._mediaSelection = mediaSelection
        self._videoURL = videoURL
        self._audioURL = audioURL
        self._isShowingVideoPickerSheet = isShowingVideoPickerSheet
        self._isShowingAudioRecorder = isShowingAudioRecorder
        self._videoSourceType = videoSourceType
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Add Video or Audio (Required)")
                .font(.headline)
                .foregroundColor(PastelColors.darkText)
                .padding(.horizontal, 20)
            
            
            HStack(spacing: 0) {
                ForEach(AboutYouPage.MediaType.allCases, id: \.self) { type in
                    Button(action: { mediaSelection = type }) {
                        Text(type.rawValue)
                            .fontWeight(.medium)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(
                                mediaSelection == type
                                ? (type == .video ? PastelColors.lightBlue : PastelColors.lightGreen)
                                : PastelColors.cream.opacity(0.8)
                            )
                            .foregroundColor(mediaSelection == type ? PastelColors.darkText : Color.gray)
                    }
                }
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal, 20)
            
            
            Button(action: {
                if mediaSelection == .video {
                    isShowingVideoPickerSheet = true
                } else {
                    isShowingAudioRecorder = true
                }
            }) {
                HStack {
                    Image(systemName: mediaSelection == .video ? "video.fill" : "mic.fill")
                    Text(mediaSelection == .video ? "Upload Video" : "Record Audio")
                }
                .fontWeight(.semibold)
                .foregroundColor(PastelColors.darkText)
            }
            .buttonStyle(PastelButton(backgroundColor: mediaSelection == .video ? PastelColors.lightBlue : PastelColors.lightGreen))
            .padding(.horizontal, 20)
            .padding(.top, 15)
            
            if mediaSelection == .video, let videoURL = videoURL {
                VideoPreviewView(url: videoURL)
                    .frame(height: 150)
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(PastelColors.lightBlue, lineWidth: 2))
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
            } else if mediaSelection == .audio, let audioURL = audioURL {
                AudioPreviewView(url: audioURL)
                    .frame(height: 80)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
            }
        }
    }
}

struct AudioPreviewView: View {
    let url: URL
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var currentTime: TimeInterval = 0
    @State private var totalDuration: TimeInterval = 0
    @State private var timer: Timer?

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Button(action: {
                    isPlaying ? pauseAudio() : playAudio()
                }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(PastelColors.darkText)
                }
                VStack(alignment: .leading) {
                    Text("Your Audio Recording")
                        .foregroundColor(PastelColors.darkText)
                        .font(.headline)
                    Text("\(timeString(time: currentTime)) / \(timeString(time: totalDuration))")
                        .foregroundColor(PastelColors.darkText.opacity(0.8))
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding()
            .background(LinearGradient(
                gradient: Gradient(colors: [PastelColors.lightBlue, PastelColors.lightGreen]),
                startPoint: .leading,
                endPoint: .trailing
            ))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        }
        .onAppear { setupAudioPlayer() }
        .onDisappear {
            audioPlayer?.stop()
            timer?.invalidate()
        }
    }

    
    private func setupAudioPlayer() {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                totalDuration = audioPlayer?.duration ?? 0
            } catch {
                print("Error setting up audio player: \(error.localizedDescription)")
            }
        }

        private func playAudio() {
            audioPlayer?.play()
            isPlaying = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                currentTime = audioPlayer?.currentTime ?? 0
                if currentTime >= totalDuration {
                    pauseAudio()
                    currentTime = 0
                }
            }
        }

        private func pauseAudio() {
            audioPlayer?.pause()
            isPlaying = false
            timer?.invalidate()
        }

        private func timeString(time: TimeInterval) -> String {
            let minutes = Int(time) / 60
            let seconds = Int(time) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }


struct PhotoSectionView: View {
    @Binding var images: [UIImage]
    @Binding var isShowingImageSourceSheet: Bool
    @Binding var selectedImageIndex: Int?
    let maxPhotos: Int = 6
    
    var onSelectSourceType: ((UIImagePickerController.SourceType) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Add 3–6 Photos")
                    .font(.headline)
                    .foregroundColor(PastelColors.darkText)
                Spacer()
                
                Menu {
                    Button(action: {
                        onSelectSourceType?(.camera)
                    }) {
                        Label("Take Photo", systemImage: "camera")
                    }
                    
                    Button(action: {
                        onSelectSourceType?(.photoLibrary)
                    }) {
                        Label("Choose from Library", systemImage: "photo.on.rectangle")
                    }
                } label: {
                    Text("Upload")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(PastelColors.darkText)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(PastelColors.lightBlue)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                }
            }
            .padding(.horizontal)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3),
                spacing: 12
            ) {
                ForEach(0..<maxPhotos, id: \.self) { index in
                    ZStack {
                        if index < images.count {
                            Image(uiImage: images[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white, lineWidth: 3)
                                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                )
                                .overlay(
                                    Menu {
                                        Button(action: {
                                            selectedImageIndex = index
                                            onSelectSourceType?(.camera)
                                        }) {
                                            Label("Take Photo", systemImage: "camera")
                                        }
                                        
                                        Button(action: {
                                            selectedImageIndex = index
                                            onSelectSourceType?(.photoLibrary)
                                        }) {
                                            Label("Choose from Library", systemImage: "photo.on.rectangle")
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .fill(PastelColors.lightBlue)
                                                .frame(width: 32, height: 32)
                                                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                                            
                                            Image(systemName: "pencil")
                                                .font(.system(size: 15, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding(8),
                                    alignment: .topTrailing
                                )
                                .overlay(
                                    Button(action: {
                                        if images.count > 0 && index < images.count {
                                            images.remove(at: index)
                                        }
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(PastelColors.deleteButton)
                                                .frame(width: 28, height: 28)
                                                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                                            
                                            Image(systemName: "xmark")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding(8),
                                    alignment: .bottomTrailing
                                )
                                .animation(.spring(), value: images.count)
                        } else {
                            Menu {
                                Button(action: {
                                    selectedImageIndex = index
                                    onSelectSourceType?(.camera)
                                }) {
                                    Label("Take Photo", systemImage: "camera")
                                }
                                
                                Button(action: {
                                    selectedImageIndex = index
                                    onSelectSourceType?(.photoLibrary)
                                }) {
                                    Label("Choose from Library", systemImage: "photo.on.rectangle")
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(PastelColors.cream)
                                        .frame(width: 100, height: 100)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                                .foregroundColor(index % 2 == 0 ? PastelColors.lightBlue : PastelColors.lightGreen)
                                        )
                                    
                                    VStack(spacing: 8) {
                                        ZStack {
                                            Circle()
                                                .fill(index % 2 == 0 ? PastelColors.lightBlue.opacity(0.8) : PastelColors.lightGreen.opacity(0.8))
                                                .frame(width: 40, height: 40)
                                            
                                            Image(systemName: "plus")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                        
                                        Text("Add")
                                            .font(.caption)
                                            .foregroundColor(PastelColors.darkText)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            if images.count > 0 {
                HStack {
                    Text("\(images.count)/\(maxPhotos) photos added")
                        .font(.caption)
                        .foregroundColor(PastelColors.darkText)
                    
                    Spacer()
                    
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 120, height: 8)
                            .foregroundColor(Color.gray.opacity(0.2))
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 120 * CGFloat(images.count) / CGFloat(maxPhotos), height: 8)
                            .foregroundColor(images.count % 2 == 0 ? PastelColors.lightBlue : PastelColors.lightGreen)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 5)
            }
        }
    }
}



struct AboutYouPage: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    @State private var images: [UIImage] = []
    @State private var videoURL: URL?
    @State private var audioURL: URL?
    @State private var selectedImageIndex: Int? = nil
    
    @State private var selectedSkills: [String] = []
    @State private var newSkill: String = ""
    @State private var selectedInterests: [String] = []
    @State private var newInterest: String = ""
    
    @State private var moodEmoji = ""
    @State private var vibeNote = ""
    
    @State private var isShowingImageSourceSheet = false
    @State private var isShowingPhotoPicker = false
    @State private var photoSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isShowingDocumentPicker = false
    
    @State private var isShowingVideoPickerSheet = false
    @State private var isShowingVideoPicker = false
    @State private var videoSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var isShowingAudioRecorder = false
    
    @State private var isSavingProfile = false
    @State private var saveError: String? = nil
    
    enum MediaType: String, CaseIterable {
        case video = "Video"
        case audio = "Audio"
    }
    @State private var mediaSelection: MediaType = .video
    
    @StateObject var profileVM = ProfileViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        PastelColors.gradientTop,
                        PastelColors.gradientBottom
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 20) {
                        
                        
                        Image("Swappi")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(.top, 20)

                        Text("Tell us about you!")
                            .font(.title)
                            .foregroundColor(PastelColors.darkText)
                            .padding(.top, 5)
                        
                        PhotoSectionView(
                            images: $images,
                            isShowingImageSourceSheet: $isShowingImageSourceSheet,
                            selectedImageIndex: $selectedImageIndex,
                            onSelectSourceType: { sourceType in
                                showImagePicker(sourceType: sourceType)
                            }
                        )
                        
                        VideoAudioSection(
                            mediaSelection: $mediaSelection,
                            videoURL: $videoURL,
                            audioURL: $audioURL,
                            isShowingVideoPickerSheet: $isShowingVideoPickerSheet,
                            isShowingAudioRecorder: $isShowingAudioRecorder,
                            videoSourceType: $videoSourceType
                        )
                        
                        DynamicInputSection(
                            title: "Add at least 5 Skills",
                            items: $selectedSkills,
                            newItem: $newSkill,
                            onAdd: addSkill
                        )
                        
                        DynamicInputSection(
                            title: "Add at least 5 Interests",
                            items: $selectedInterests,
                            newItem: $newInterest,
                            onAdd: addInterest
                        )
                        
                        MoodVibeSection(
                            moodEmoji: $moodEmoji,
                            vibeNote: $vibeNote
                        )
                        
                        SaveProfileSection(
                            isSaving: $isSavingProfile,
                            error: $saveError,
                            action: saveProfile
                        )
                    }
                }
            }
        }
        .navigationBarHidden(true)
        
        .actionSheet(isPresented: $isShowingImageSourceSheet) {
            ActionSheet(
                title: Text("Select Photo"),
                message: Text("Choose your photo source"),
                buttons: [
                    .default(Text("Take Photo")) {
                        photoSourceType = .camera
                        isShowingPhotoPicker = true
                    },
                    .default(Text("Choose from Library")) {
                        photoSourceType = .photoLibrary
                        isShowingPhotoPicker = true
                    },
                    .default(Text("Choose from Files")) {
                        isShowingDocumentPicker = true
                    },
                    .cancel()
                ]
            )
        }
        
        .sheet(isPresented: $isShowingPhotoPicker) {
            print("Photo picker was dismissed")
        } content: {
            ImagePicker(selectedImage: { image in
                print("Image selected, size: \(image.size)")
                addImage(image)
            }, sourceType: photoSourceType)
        }
        
        .sheet(isPresented: $isShowingDocumentPicker) {
            print("Document picker was dismissed")
        } content: {
            DocumentPicker { pickedURL in
                print("Document picked: \(pickedURL)")
                if let data = try? Data(contentsOf: pickedURL),
                   let image = UIImage(data: data) {
                    addImage(image)
                }
            }
        }
        
        .actionSheet(isPresented: $isShowingVideoPickerSheet) {
            ActionSheet(
                title: Text("Select Video"),
                message: Text("Choose your video source"),
                buttons: [
                    .default(Text("Record Video")) {
                        videoSourceType = .camera
                        isShowingVideoPicker = true
                    },
                    .default(Text("Choose from Library")) {
                        videoSourceType = .photoLibrary
                        isShowingVideoPicker = true
                    },
                    .cancel()
                ]
            )
        }
        
        .sheet(isPresented: $isShowingVideoPicker) {
            VideoPicker(sourceType: videoSourceType) { url in
                videoURL = url
            }
        }
        
        .sheet(isPresented: $isShowingAudioRecorder) {
            AudioRecorderView { url in
                audioURL = url
            }
        }
    }


    
    private func saveProfile() {
        guard images.count >= 3,
              selectedSkills.count >= 5,
              selectedInterests.count >= 5,
              (videoURL != nil || audioURL != nil) else {
            
            var errorMessages = [String]()
            
            if images.count < 3 {
                errorMessages.append("Please add at least 3 photos")
            }
            if selectedSkills.count < 5 {
                errorMessages.append("Please add at least 5 skills")
            }
            if selectedInterests.count < 5 {
                errorMessages.append("Please add at least 5 interests")
            }
            if videoURL == nil && audioURL == nil {
                errorMessages.append("Please add either a video or audio")
            }
            
            saveError = errorMessages.joined(separator: "\n")
            return
        }
        
        isSavingProfile = true
        
        let profile = UserProfile(
            name: Auth.auth().currentUser?.displayName ?? "",
            email: Auth.auth().currentUser?.email ?? "",
            skillsKnown: selectedSkills,
            skillsWanted: selectedInterests,
            vibe: vibeNote,
            mood: moodEmoji,
            note:"",
            profilePhotos: [""],
            introMediaURL: videoURL?.absoluteString ?? ""
            )
        
        profileVM.saveUserProfile(profile: profile) { result in
            isSavingProfile = false
            switch result {
            case .success():
                isLoggedIn = true
            case .failure(let error):
                saveError = error.localizedDescription
            }
        }
    }
    
    
    private func addImage(_ image: UIImage) {
        print("Adding image to collection at position: \(selectedImageIndex?.description ?? "end")")
        
        
        DispatchQueue.main.async {
            if let selectedIndex = self.selectedImageIndex {
                
                if selectedIndex < self.images.count {
                    
                    self.images[selectedIndex] = image
                    print("Replaced image at index \(selectedIndex)")
                } else {
                    
                    while self.images.count < selectedIndex {
                        self.images.append(UIImage())
                    }
                    self.images.append(image)
                    print("Added image at index \(selectedIndex)")
                }
            } else if self.images.count < 6 {
                
                self.images.append(image)
                print("Added image at the end, total count: \(self.images.count)")
            } else {
                print("Maximum number of images reached")
            }
            
            
            self.selectedImageIndex = nil
        }
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        
        self.photoSourceType = sourceType
        
        self.isShowingPhotoPicker = true
    }
    
    
    private func addSkill() {
        guard !newSkill.isEmpty else { return }
        if selectedSkills.count < 5 {
            selectedSkills.append(newSkill)
            newSkill = ""
        }
    }
    
    private func addInterest() {
        guard !newInterest.isEmpty else { return }
        if selectedInterests.count < 5 {
            selectedInterests.append(newInterest)
            newInterest = ""
        }
    }
}


struct DebugInfoView: View {
    let images: [UIImage]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Debug Info:")
                .font(.caption)
                .foregroundColor(.white)
            Text("- Images count: \(images.count)")
                .font(.caption)
                .foregroundColor(.white)
            ForEach(0..<images.count, id: \.self) { index in
                Text("- Image \(index): \(Int(images[index].size.width))×\(Int(images[index].size.height))")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .padding(10)
        .background(Color.black.opacity(0.5))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}




struct DocumentPicker: UIViewControllerRepresentable {
    let onFilePicked: (URL) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let types = [UTType.image]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            print("Document picker did pick documents: \(urls)")
            if let url = urls.first {
                parent.onFilePicked(url)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("Document picker was cancelled")
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    var selectedImage: (UIImage) -> Void
    var sourceType: UIImagePickerController.SourceType
    
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            print("Image picker did finish with info")
            
            if let editedImage = info[.editedImage] as? UIImage {
                print("Using edited image")
                parent.selectedImage(editedImage)
            } else if let originalImage = info[.originalImage] as? UIImage {
                print("Using original image")
                parent.selectedImage(originalImage)
            } else {
                print("No image found in info")
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("Image picker was cancelled")
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


struct VideoPicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var onVideoPicked: (URL) -> Void
    
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeMedium
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: VideoPicker
        
        init(_ parent: VideoPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let videoURL = info[.mediaURL] as? URL {
                parent.onVideoPicked(videoURL)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


struct AudioRecorderView: View {
    @Environment(\.presentationMode) var presentationMode
    var onAudioRecorded: (URL) -> Void
    @State private var audioRecorder: AVAudioRecorder?
    @State private var isRecording = false
    @State private var timer: Timer?
    @State private var recordingTime: TimeInterval = 0
    @State private var recordingURL: URL?

    var body: some View {
        VStack(spacing: 30) {
            Text("Record Audio")
                .font(.title)
                .fontWeight(.bold)
            ZStack {
                Circle()
                    .fill(isRecording ? Color.red : Color.blue)
                    .frame(width: 200, height: 200)
                VStack {
                    Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    if isRecording {
                        Text(timeString(time: recordingTime))
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                    } else {
                        Text("Tap to Record")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                    }
                }
            }
            .onTapGesture {
                isRecording ? stopRecording() : startRecording()
            }
            if let recordingURL = recordingURL {
                Button(action: {
                    onAudioRecorded(recordingURL)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Use This Recording")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
            }
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("Cancel")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding(30)
        .onAppear { setupAudioRecorder() }
        .onDisappear { timer?.invalidate() }
    }

    private func setupAudioRecorder() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentsPath.appendingPathComponent("recording_\(Date().timeIntervalSince1970).m4a")
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.prepareToRecord()
        } catch {
            print("Failed to set up audio recorder: \(error.localizedDescription)")
        }
    }

    private func startRecording() {
        guard let recorder = audioRecorder, !isRecording else { return }
        recordingTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            recordingTime += 1
        }
        isRecording = true
        recorder.record()
    }

    private func stopRecording() {
        guard isRecording, let recorder = audioRecorder else { return }
        timer?.invalidate()
        isRecording = false
        recorder.stop()
        recordingURL = recorder.url
    }

    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


struct VideoPreviewView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        playerLayer.frame = view.bounds
        player.actionAtItemEnd = .none
        player.play()
        let startTime = CMTime(seconds: 0.1, preferredTimescale: 1)
        let interval = CMTime(seconds: 1.0, preferredTimescale: 1)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { _ in
            if player.currentItem?.duration == player.currentTime() {
                player.seek(to: startTime)
                player.play()
            }
        }
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        if let playerLayer = uiView.layer.sublayers?.first as? AVPlayerLayer {
            playerLayer.frame = uiView.bounds
        }
    }
}

struct AboutYouPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutYouPage()
        }
    }
}
