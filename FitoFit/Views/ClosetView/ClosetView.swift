//
//  ClosetView.swift
//  FitoFit
//

import SwiftUI
import PhotosUI
import Vision
import CoreImage.CIFilterBuiltins

struct ClosetView: View {
    @EnvironmentObject var viewModel: ClosetViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State private var showingImagePicker = false
    @State private var selectedImages: [UIImage] = []
    @State private var selectedClothingItemID: UUID? = nil
    @State private var isClothingDetailPresented = false
    @State private var isLoading: Bool = false

    // Filter states
    @State private var selectedCategory: String = "CATEGORY"
    @State private var selectedType: String = "TYPE"
    @State private var selectedColor: String = "COLOR"
    @State private var favoritesOnly: Bool = false

    let categories = ["CATEGORY"] + Category.allCases.map { $0.rawValue }
    let colors = ["COLOR"] + NamedColor.all.map { $0.name }

    private var processingQueue = DispatchQueue(label: "ProcessingQueue")

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Processing Images...")
                        .padding()
                }

                HStack {
                    ProfilePictureView()
                        .environmentObject(profileViewModel)

                    Image(systemName: favoritesOnly ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(favoritesOnly ? .red : .black)
                        .onTapGesture {
                            favoritesOnly.toggle()
                        }

                    Spacer()

                    HStack(spacing: 10) {
                        DropdownFilterButton(
                            label: "CATEGORY",
                            options: categories,
                            selectedOption: Binding(
                                get: { selectedCategory },
                                set: { newValue in
                                    selectedCategory = newValue
                                    selectedType = "TYPE"
                                    selectedColor = "COLOR"
                                }
                            )
                        )
                        DropdownFilterButton(
                            label: "TYPE",
                            options: ["TYPE"] + typesForCategory(selectedCategory),
                            selectedOption: $selectedType
                        )
                        DropdownFilterButton(
                            label: "COLOR",
                            options: colors,
                            selectedOption: $selectedColor
                        )
                    }
                }
                .padding()

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(filteredItems) { item in
                            ClothingItemView(image: item.image)
                                .onTapGesture {
                                    selectedClothingItemID = item.id
                                    isClothingDetailPresented = true
                                }
                        }
                    }
                    .padding()
                }
                .sheet(isPresented: $isClothingDetailPresented, onDismiss: {
                    selectedClothingItemID = nil
                }) {
                    if let selectedID = selectedClothingItemID,
                       let index = viewModel.uploadedItems.firstIndex(where: { $0.id == selectedID }) {
                        ClothingItemDetailView(
                            clothingItem: $viewModel.uploadedItems[index],
                            onRemove: { viewModel.removeItem(at: index) }
                        )
                    }
                }
                .sheet(isPresented: $showingImagePicker, onDismiss: {
                    processSelectedImages()
                }) {
                    MultiImagePicker(selectedImages: $selectedImages)
                }
                .overlay(
                    FloatingAddButton(action: {
                        showingImagePicker = true
                    })
                    .padding(),
                    alignment: .bottomTrailing
                )
            }
        }
    }

    private var filteredItems: [ClothingItem] {
        viewModel.uploadedItems.filter { item in
            (!favoritesOnly || item.isFavorited) &&
            (selectedCategory == "CATEGORY" || item.category.rawValue == selectedCategory) &&
            (selectedType == "TYPE" || item.type == selectedType) &&
            (selectedColor == "COLOR" || item.color.name == selectedColor)
        }
    }

    private func typesForCategory(_ category: String) -> [String] {
        guard let selectedCategory = Category(rawValue: category), category != "CATEGORY" else {
            return []
        }

        switch selectedCategory {
        case .top: return Types.tops
        case .bottom: return Types.bottoms
        case .hat: return Types.hats
        case .shoe: return Types.shoes
        }
    }

    // Process selected images and create clothing items
    private func processSelectedImages() {
        guard !selectedImages.isEmpty else { return }

        isLoading = true
        let processingGroup = DispatchGroup()

        for image in selectedImages {
            processingGroup.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                guard let processedImage = self.createSticker(from: self.correctImageOrientation(image)) else {
                    processingGroup.leave()
                    return
                }
                DispatchQueue.main.async {
                    let newItem = ClothingItem(
                        image: processedImage,
                        category: .top,
                        type: Types.tops.first ?? "",
                        color: NamedColor(color: .gray, name: "Gray"),
                        isFavorited: false
                    )
                    self.viewModel.uploadedItems.insert(newItem, at: 0)
                    processingGroup.leave()
                }
            }
        }

        processingGroup.notify(queue: .main) {
            isLoading = false
            selectedImages = []
        }
    }


    private func createSticker(from inputUIImage: UIImage) -> UIImage? {
        guard let inputImage = CIImage(image: inputUIImage) else { return nil }

        guard let maskImage = subjectMaskImage(from: inputImage) else { return nil }

        let outputImage = apply(maskImage: maskImage, to: inputImage)
        return render(ciImage: outputImage)
    }

    private func subjectMaskImage(from inputImage: CIImage) -> CIImage? {
        let handler = VNImageRequestHandler(ciImage: inputImage)
        let request = VNGenerateForegroundInstanceMaskRequest()
        do {
            try handler.perform([request])
        } catch {
            print(error)
            return nil
        }
        guard let result = request.results?.first else { return nil }
        do {
            let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
            return CIImage(cvPixelBuffer: maskPixelBuffer)
        } catch {
            print(error)
            return nil
        }
    }

    private func apply(maskImage: CIImage, to inputImage: CIImage) -> CIImage {
        let filter = CIFilter.blendWithMask()
        filter.inputImage = inputImage
        filter.maskImage = maskImage
        filter.backgroundImage = CIImage.empty()
        return filter.outputImage!
    }

    private func render(ciImage: CIImage) -> UIImage? {
        guard let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    private func correctImageOrientation(_ image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage ?? image
    }
}

struct MultiImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: MultiImagePicker

        init(_ parent: MultiImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            let dispatchGroup = DispatchGroup()

            for result in results {
                dispatchGroup.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.selectedImages.append(image)
                        }
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
               
            }
        }
    }
}


struct DropdownFilterButton: View {
    let label: String
    let options: [String]
    @Binding var selectedOption: String

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedOption = option
                }) {
                    Text(option.capitalized)
                }
            }
        } label: {
            Text(selectedOption.capitalized)
                .font(.system(size: 16, weight: .bold))
                .frame(minWidth: 20)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Capsule().stroke())
        }
    }
}

struct FloatingAddButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.red)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
}

struct ClothingItemView: View {
    var image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 200)
            .cornerRadius(10)
    }
}

#Preview {
    ClosetView()
        .environmentObject(ClosetViewModel())
        .environmentObject(ProfileViewModel())
}




