//
//  AboutYouPage.swift
//  Swappi
//
//  Created by Asmi Kachare on 3/29/25.
//

import SwiftUI
import PhotosUI
import AVFoundation

struct AboutYouPage: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var images: [UIImage] = []
    @State private var videoURL: URL?
    @State private var audioURL: URL?
    @State private var selectedSkills: [String] = []
    @State private var newSkill: String = ""
    @State private var selectedInterests: [String] = []
    @State private var newInterest: String = ""
    @State private var moodEmoji = ""
    @State private var vibeNote = ""
    @State private var isShowingImageSourceSheet = false
    @State private var isShowingVideoPickerSheet = false
    @State private var isShowingCamera = false
    @State private var isShowingPhotoLibrary = false
    @State private var isShowingVideoPicker = false
    @State private var isShowingAudioRecorder = false
    @State private var selectedPhotoIndex: Int? = nil
    @State private var mediaSelection: MediaType = .video
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    enum MediaType: String, CaseIterable {
        case video = "Video"
        case audio = "Audio"
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 1.0, green: 0.65, blue: 0.9), Color(red: 0.55, green: 0.85, blue: 1.0)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    Image("Swappi")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    Text("Tell us about you!")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Add 3–6 Photos")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Button(action: { isShowingImageSourceSheet = true }) {
                                Text("Upload")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                            ForEach(0..<6, id: \.self) { index in
                                ZStack {
                                    if index < images.count {
                                        Image(uiImage: images[index])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(12)
                                            .overlay(
                                                Button(action: {
                                                    selectedPhotoIndex = index
                                                    isShowingImageSourceSheet = true
                                                }) {
                                                    Image(systemName: "pencil.circle.fill")
                                                        .font(.title)
                                                        .foregroundColor(.white)
                                                        .shadow(radius: 3)
                                                }
                                                .padding(8),
                                                alignment: .topTrailing
                                            )
                                    } else {
                                        Button(action: {
                                            selectedPhotoIndex = index
                                            isShowingImageSourceSheet = true
                                        }) {
                                            RoundedRectangle(cornerRadius: 12)
                                                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                                .frame(width: 100, height: 100)
                                                .overlay(
                                                    VStack(spacing: 8) {
                                                        Image(systemName: "plus")
                                                            .font(.title2)
                                                            .foregroundColor(.white)
                                                        Text("Add")
                                                            .font(.caption)
                                                            .foregroundColor(.white)
                                                    }
                                                )
                                                .background(Color.black.opacity(0.1))
                                                .cornerRadius(12)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 15)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Add Video or Audio (Required)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                        
                        HStack(spacing: 0) {
                            ForEach(MediaType.allCases, id: \.self) { type in
                                Button(action: { mediaSelection = type }) {
                                    Text(type.rawValue)
                                        .fontWeight(.medium)
                                        .padding(.vertical, 12)
                                        .frame(maxWidth: .infinity)
                                        .background(mediaSelection == type ? Color.white.opacity(0.6) : Color.gray.opacity(0.3))
                                        .foregroundColor(mediaSelection == type ? .black : .white)
                                }
                            }
                        }
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(25)
                        .padding(.horizontal, 40)
                        
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
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 15)
                        
                        if let videoURL = videoURL, mediaSelection == .video {
                            VideoPreviewView(url: videoURL)
                                .frame(height: 150)
                                .cornerRadius(12)
                                .padding(.horizontal, 40)
                                .padding(.top, 10)
                        } else if let audioURL = audioURL, mediaSelection == .audio {
                            AudioPreviewView(url: audioURL)
                                .frame(height: 80)
                                .cornerRadius(12)
                                .padding(.horizontal, 40)
                                .padding(.top, 10)
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Add at least 5 Skills")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack {
                            TextField("Enter a skill", text: $newSkill)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                            
                            Button(action: addSkill) {
                                Text("Add")
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color.green)
                                    .cornerRadius(8)
                            }
                        }
                        
                        FlowLayout(data: selectedSkills, spacing: 8) { skill in
                            BubbleTag(text: skill) {
                                if let idx = selectedSkills.firstIndex(of: skill) {
                                    selectedSkills.remove(at: idx)
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Add at least 5 Interests")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack {
                            TextField("Enter an interest", text: $newInterest)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                            
                            Button(action: addInterest) {
                                Text("Add")
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color.green)
                                    .cornerRadius(8)
                            }
                        }
                        
                        FlowLayout(data: selectedInterests, spacing: 8) { interest in
                            BubbleTag(text: interest) {
                                if let idx = selectedInterests.firstIndex(of: interest) {
                                    selectedInterests.remove(at: idx)
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    VStack(spacing: 10) {
                        TextField("Pick a mood emoji", text: $moodEmoji)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                        
                        TextField("Vibe? (Add a note)", text: $vibeNote)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    NavigationLink(destination: ExploreView()) {
                        Text("Save Profile")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 60)
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
                        sourceType = .camera
                        isShowingCamera = true
                    },
                    .default(Text("Choose from Library")) {
                        sourceType = .photoLibrary
                        isShowingPhotoLibrary = true
                    },
                    .cancel()
                ]
            )
        }
        .actionSheet(isPresented: $isShowingVideoPickerSheet) {
            ActionSheet(
                title: Text("Select Video"),
                message: Text("Choose your video source"),
                buttons: [
                    .default(Text("Record Video")) {
                        isShowingVideoPicker = true
                        sourceType = .camera
                    },
                    .default(Text("Choose from Library")) {
                        isShowingVideoPicker = true
                        sourceType = .photoLibrary
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $isShowingCamera) {
            ImagePicker(selectedImage: { image in addOrUpdateImage(image) },
                        sourceType: .camera)
        }
        .sheet(isPresented: $isShowingPhotoLibrary) {
            if #available(iOS 14, *) {
                MultipleImagePicker(onImagesSelected: { selectedImages in
                    addMultipleImages(selectedImages)
                })
            } else {
                ImagePicker(selectedImage: { image in addOrUpdateImage(image) },
                            sourceType: .photoLibrary)
            }
        }
        .sheet(isPresented: $isShowingVideoPicker) {
            VideoPicker(sourceType: sourceType) { url in
                self.videoURL = url
            }
        }
        .sheet(isPresented: $isShowingAudioRecorder) {
            AudioRecorderView { url in
                self.audioURL = url
            }
        }
    }

    private func addOrUpdateImage(_ image: UIImage) {
        if let index = selectedPhotoIndex {
            if index < images.count {
                images[index] = image
            } else {
                images.append(image)
            }
            selectedPhotoIndex = nil
        }
    }

    private func addMultipleImages(_ newImages: [UIImage]) {
        if let index = selectedPhotoIndex, index < images.count {
            if !newImages.isEmpty {
                images[index] = newImages[0]
                let remainingImages = Array(newImages.dropFirst())
                addRemainingImages(remainingImages)
            }
        } else {
            addRemainingImages(newImages)
        }
        selectedPhotoIndex = nil
    }

    private func addRemainingImages(_ newImages: [UIImage]) {
        for image in newImages {
            if images.count < 6 {
                images.append(image)
            } else {
                break
            }
        }
    }
    
    private func addSkill() {
        guard !newSkill.isEmpty else { return }
        selectedSkills.append(newSkill)
        newSkill = ""
    }
    
    private func addInterest() {
        guard !newInterest.isEmpty else { return }
        selectedInterests.append(newInterest)
        newInterest = ""
    }
}

struct VideoPicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var onVideoPicked: (URL) -> Void

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
        init(_ parent: VideoPicker) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let videoURL = info[.mediaURL] as? URL {
                parent.onVideoPicked(videoURL)
            }
            picker.dismiss(animated: true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
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
                if isRecording {
                    stopRecording()
                } else {
                    startRecording()
                }
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
        let time = CMTime(seconds: 0.1, preferredTimescale: 1)
        let interval = CMTime(seconds: 1.0, preferredTimescale: 1)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { _ in
            if player.currentItem?.duration == player.currentTime() {
                player.seek(to: time)
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
                    if isPlaying {
                        pauseAudio()
                    } else {
                        playAudio()
                    }
                }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading) {
                    Text("Your Audio Recording")
                        .foregroundColor(.white)
                        .font(.headline)
                    Text("\(timeString(time: currentTime)) / \(timeString(time: totalDuration))")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding()
            .background(Color.blue.opacity(0.6))
            .cornerRadius(12)
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

@available(iOS 14, *)
struct MultipleImagePicker: UIViewControllerRepresentable {
    var onImagesSelected: ([UIImage]) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 6
        configuration.preferredAssetRepresentationMode = .automatic
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: MultipleImagePicker
        init(_ parent: MultipleImagePicker) { self.parent = parent }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard !results.isEmpty else { return }
            let dispatchGroup = DispatchGroup()
            var images = [UIImage]()
            for result in results {
                dispatchGroup.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                    defer { dispatchGroup.leave() }
                    if let image = reading as? UIImage, error == nil {
                        images.append(image)
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                self.parent.onImagesSelected(images)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    var selectedImage: (UIImage) -> Void
    var sourceType: UIImagePickerController.SourceType

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
        init(_ parent: ImagePicker) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage(editedImage)
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage(originalImage)
            }
            picker.dismiss(animated: true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

struct BubbleTag: View {
    let text: String
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
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(Color.blue)
        .clipShape(Capsule())
    }
}

struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    @State private var totalHeight: CGFloat = .zero
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content

    init(data: Data,
         spacing: CGFloat = 8,
         alignment: HorizontalAlignment = .leading,
         @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        GeometryReader { geo in
            self.generateContent(in: geo)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geo: GeometryProxy) -> some View {
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0

        return ZStack(alignment: .topLeading) {
            ForEach(data, id: \.self) { item in
                content(item)
                    .padding(.all, spacing)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if xOffset + dimension.width > geo.size.width {
                            xOffset = 0
                            yOffset += dimension.height + spacing
                        }
                        let result = xOffset
                        xOffset += dimension.width + spacing
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = yOffset
                        return result
                    })
            }
        }
        .background(
            GeometryReader { internalGeo -> Color in
                DispatchQueue.main.async {
                    self.totalHeight = internalGeo.size.height
                }
                return Color.clear
            }
        )
    }
}

struct AboutYouPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutYouPage()
        }
    }
}
