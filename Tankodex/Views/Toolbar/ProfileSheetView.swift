//
//  ProfileSheetView.swift
//  Tankodex
//
//  Created by Sergio García on 26/2/26.
//

import SwiftUI
import PhotosUI

struct ProfileSheetView: View {
    @Environment(libraryVM.self) private var libraryViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var profileVM = ProfileVM()
    @State private var selectedPhoto: PhotosPickerItem?
    @FocusState private var isNameFocused: Bool
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Avatar
                    VStack(spacing: 12) {
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            ZStack(alignment: .bottomTrailing) {
                                Group {
                                    if let image = profileVM.profileImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 50))
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .frame(width: 100, height: 100)
                                .clipShape(.circle)
                                .background(.regularMaterial, in: .circle)
                                
                                Image(systemName: "pencil.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.blue)
                                    .background(.white, in: .circle)
                            }
                        }
                        
                        TextField("Your name", text: $profileVM.username)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .focused($isNameFocused)
                    }
                    .padding(.top)
                    
                    // MARK: - Stats
                    VStack(alignment: .leading, spacing: 16) {
                        Text("My Collection")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            StatCard(title: "Total", value: "\(libraryViewModel.totalMangas)", icon: "books.vertical.fill", color: .blue)
                            StatCard(title: "Wishlist", value: "\(libraryViewModel.count(for: .wishlist))", icon: ReadingStatus.wishlist.icon, color: .purple)
                            StatCard(title: "Reading", value: "\(libraryViewModel.count(for: .reading))", icon: ReadingStatus.reading.icon, color: .orange)
                            StatCard(title: "Completed", value: "\(libraryViewModel.count(for: .completed))", icon: ReadingStatus.completed.icon, color: .green)
                            StatCard(title: "Collected", value: "\(libraryViewModel.count(for: .collected))", icon: ReadingStatus.collected.icon, color: .indigo)
                            StatCard(title: "Volumes owned", value: "\(libraryViewModel.totalVolumesOwned)", icon: "shippingbox.fill", color: .brown)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(profileVM.username.isEmpty ? "Profile" : profileVM.username)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .task(id: selectedPhoto) {
                await profileVM.savePhoto(from: selectedPhoto)
            }
        }
    }
    
    private func count(for status: ReadingStatus) -> Int {
        libraryViewModel.collection.filter { $0.status == status }.count
    }
    
    private var totalVolumes: Int {
        libraryViewModel.collection.reduce(0) { $0 + $1.volumesBought }
    }
}
