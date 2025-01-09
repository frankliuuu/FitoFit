//
//  Fits.swift
//  FitoFit
//




import SwiftUI

struct FitsView: View {
    @EnvironmentObject var fitsViewModel: FitsViewModel
    @EnvironmentObject var closetViewModel: ClosetViewModel
    @State private var showingAddAlbumSheet = false
    @State private var newAlbumName = ""

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    ProfilePictureView()
                    Text("Your Fits")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        showingAddAlbumSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                HStack {
                    Button(action: {
                        print("Sort Button Tapped")
                    }) {
                        HStack {
                            Image(systemName: "arrow.up.arrow.down")
                            Text("Sort")
                                .fontWeight(.medium)
                        }
                    }
                    Spacer()
                    Button(action: {
                        print("Change Display")
                    }) {
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 24))
                    }
                }
                .padding(.horizontal)

                // Scrollable List of Albums
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(fitsViewModel.albums) { album in
                            NavigationLink(destination: AlbumDetailView(album: album)) {
                                FitCategory(title: album.name, outfits: album.outfits, currentAlbum: album)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .sheet(isPresented: $showingAddAlbumSheet) {
                VStack {
                    Text("New Album")
                        .font(.headline)
                        .padding()
                    TextField("Album Name", text: $newAlbumName)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    Button(action: {
                        if !newAlbumName.isEmpty {
                            fitsViewModel.addAlbum(name: newAlbumName)
                            newAlbumName = ""
                            showingAddAlbumSheet = false
                        }
                    }) {
                        Text("Create Album")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                .presentationDetents([.fraction(0.4)])
            }
        }
    }
}


struct FitCategory: View {
    let title: String
    let outfits: [Outfit]
    let currentAlbum: Album

    @EnvironmentObject var fitsViewModel: FitsViewModel
    @EnvironmentObject var closetViewModel: ClosetViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 5)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(outfits, id: \.id) { outfit in
                        NavigationLink(destination: OutfitDetailView(outfit: .constant(outfit), currentAlbum: currentAlbum)
                            .environmentObject(fitsViewModel)
                        ) {
                            OutfitThumbnailView(outfit: outfit)
                        }
                    }
                }
            }
        }
    }
}


struct OutfitThumbnailView: View {
    let outfit: Outfit

    var body: some View {
        VStack(spacing: 3) {
            if let hat = outfit.hat {
                Image(uiImage: hat.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            if let top = outfit.top {
                Image(uiImage: top.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            if let bottom = outfit.bottom {
                Image(uiImage: bottom.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            if let shoes = outfit.shoes {
                Image(uiImage: shoes.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .frame(width: 120, height: 300)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


#Preview {
    FitsView()
        .environmentObject(FitsViewModel())
}

