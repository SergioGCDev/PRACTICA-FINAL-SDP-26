    //
    //  MangaDetailView.swift
    //  Tankodex
    //
    //  Created by Sergio García on 23/2/26.
    //

import SwiftUI
import SwiftData

struct MangaDetailView: View {
    let manga: Manga
    
        // Variable que SwiftUI usa para saber si algún campo tiene el foco
        // Gestionado con .focused($isInputActive) en los TextField.
        // Y en tapGesture del Scroll, para ponerlo en false en caso de tapear fuera del TxtField
    @FocusState private var isInputActive: Bool
    
    
    @Environment(libraryVM.self) private var libraryViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var volumesBought: Int = 0
    @State private var currentVolume: Int = 0
    @State private var isCompleted: Bool = false
    @State private var selectedStatus: ReadingStatus = .wishlist
    @State private var showDeleteConfirmation = false
    
    private var libraryEntry: MangaCollectionDTO? {
        libraryViewModel.collection.first { $0.mangaId == manga.id }
    }
    
    private var isInLibrary: Bool {
        libraryEntry != nil
    }
    
    private var collectionProgress: Double? {
        guard let total = manga.volumes, total > 0 else { return nil }
        return min(Double(volumesBought) / Double(total), 1.0)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                        // MARK: - Header
                    HStack(alignment: .top, spacing: 16) {
                        AsyncImage(url: manga.mainPicture) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Rectangle()
                                .foregroundStyle(.secondary.opacity(0.2))
                                .overlay { ProgressView() }
                        }
                        .frame(width: 120, height: 180)
                        .clipped()
                        .clipShape(.rect(cornerRadius: 8))
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(manga.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            if !manga.formattedJapaneseTitle.isEmpty {
                                Text(manga.formattedJapaneseTitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            if let demographic = manga.demographics.first {
                                DemographicTag(demographic: demographic, style: .withText)
                            }
                            
                            Label(String(format: "%.2f", manga.score), systemImage: "star.fill")
                                .font(.subheadline)
                                .foregroundStyle(.orange)
                            
                            Text(manga.status.displayName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            if let volumes = manga.volumes {
                                Text("\(volumes) volumes")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                        // MARK: - Synopsis
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Synopsis")
                            .font(.headline)
                        Text(manga.synopsis)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    
                        // MARK: - Collection
                    if isInLibrary {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("My Collection")
                                .font(.headline)
                                .padding(.horizontal)
                            
                                // Status picker
                            Picker("Status", selection: $selectedStatus) {
                                ForEach(ReadingStatus.allCases, id: \.self) { status in
                                    Image(systemName: status.icon).tag(status)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal)
                            .onChange(of: selectedStatus) { _, newValue in
                                switch newValue {
                                case .collected:
                                    if let total = manga.volumes {
                                        volumesBought = total
                                    }
                                case .completed:
                                    isCompleted = true
                                    if let total = manga.volumes {
                                        volumesBought = total
                                        currentVolume = total
                                    }
                                case .reading:
                                    isCompleted = false
                                case .wishlist:
                                    isCompleted = false
                                    volumesBought = 0
                                    currentVolume = 0
                                }
                            }
                            
                            VStack(spacing: 12) {
                                    // Volumes bought
                                HStack {
                                    Text("Owned: \(volumesBought) / \(manga.volumes.map { "\($0)" } ?? "In progress") vols.")
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    TextField("0", value: $volumesBought, format: .number)
                                        .focused($isInputActive)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 50)
                                        .textFieldStyle(.roundedBorder)
                                        .disabled(isCompleted)
                                        .onChange(of: volumesBought) { _, newValue in
                                            if let total = manga.volumes, newValue > total {
                                                volumesBought = total
                                            }
                                            if newValue < 0 { volumesBought = 0 }
                                        }
                                    Stepper("", value: $volumesBought, in: 0...(manga.volumes ?? .max))
                                        .labelsHidden()
                                        .disabled(isCompleted)
                                }
                                
                                    // Current volume
                                HStack {
                                    Text("Reading: \(currentVolume) / \(manga.volumes.map { "\($0)" } ?? "In progress")")
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    TextField("0", value: $currentVolume, format: .number)
                                        .focused($isInputActive)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 50)
                                        .textFieldStyle(.roundedBorder)
                                        .disabled(isCompleted)
                                        .onChange(of: currentVolume) { _, newValue in
                                            guard let total = manga.volumes else { return }
                                            if newValue > total { currentVolume = total }
                                            if newValue < 0 { currentVolume = 0 }
                                            selectedStatus = libraryViewModel.resolveStatus(
                                                currentVolume: newValue,
                                                totalVolumes: manga.volumes,
                                                status: selectedStatus
                                            )
                                            isCompleted = selectedStatus == .completed || selectedStatus == .collected
                                        }
                                    Stepper("", value: $currentVolume, in: 0...(manga.volumes ?? .max))
                                        .labelsHidden()
                                        .disabled(selectedStatus == .completed)
                                }
                                
                                    // Progress bar
                                if let progress = collectionProgress {
                                    VStack(alignment: .leading, spacing: 4) {
                                        ProgressView(value: progress)
                                            .tint(progress == 1.0 ? .green : .blue)
                                        Text("\(Int(progress * 100))% collected")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .scrollDismissesKeyboard(.interactively)
            .onTapGesture {
                isInputActive = false
            }
            .navigationTitle("Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    if isInLibrary {
                        HStack (spacing: 16){
                            Button(role: .destructive) {
                                showDeleteConfirmation = true
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                            
                            Button {
                                Task {
                                        await libraryViewModel.saveCollection(
                                            manga: manga,
                                            volumesBought: volumesBought,
                                            currentVolume: currentVolume,
                                            isCompleted: isCompleted,
                                            status: selectedStatus
                                        )
                                        dismiss()
                                    }
                            } label: {
                                Image(systemName: "square.and.arrow.down.badge.checkmark")
                                    .foregroundStyle(.green)
                            }
                        }
                    } else {
                        Button {
                            Task {
                                await libraryViewModel.addManga(manga, status: .wishlist)
                            }
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .alert("Remove \(manga.title)?", isPresented: $showDeleteConfirmation) {
                Button("Remove", role: .destructive) {
                    Task {
                        await libraryViewModel.removeManga(manga)
                        dismiss()
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will permanently remove this manga from your library.")
            }
        }
        .onAppear {
            if let entry = libraryEntry {
                volumesBought = entry.volumesBought
                currentVolume = entry.currentVolume
                isCompleted = entry.isCompleted
                selectedStatus = entry.status
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: MangaCollection.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let vm = libraryVM(modelContainer: container)
    
    return MangaDetailView(manga: .test)
        .environment(vm)
}
