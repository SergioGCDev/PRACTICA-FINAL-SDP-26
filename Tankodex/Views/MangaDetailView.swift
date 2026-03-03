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
    @State private var isSynopsisExpanded: Bool = false

    private var libraryEntry: MangaCollectionDTO? {
        libraryViewModel.collection.first { $0.mangaId == manga.id }
    }

    private var isInLibrary: Bool { libraryEntry != nil }

    private var collectionProgress: Double? {
        guard let total = manga.volumes, total > 0 else { return nil }
        return min(Double(volumesBought) / Double(total), 1.0)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // MARK: - Header
                    ZStack(alignment: .bottomLeading) {
                        // Imagen de fondo desenfocada
                        AsyncImage(url: manga.mainPicture) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Rectangle().foregroundStyle(.secondary.opacity(0.1))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 280)
                        .clipped()
                        .overlay(.ultraThinMaterial.opacity(0.2))
                        .overlay(
                            LinearGradient(
                                colors: [.clear, Color(.systemBackground)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                        // Portada + info
                        HStack(alignment: .bottom, spacing: 16) {
                            AsyncImage(url: manga.mainPicture) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Rectangle()
                                    .foregroundStyle(.secondary.opacity(0.2))
                                    .overlay { ProgressView() }
                            }
                            .frame(width: 110, height: 160)
                            .clipShape(.rect(cornerRadius: 10))
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                            .offset(y: 30)

                            VStack(alignment: .leading, spacing: 4) {
                                if let demographic = manga.demographics.first {
                                    DemographicTag(demographic: demographic, style: .withText)
                                }
                                Text(manga.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .lineLimit(2)

                                if !manga.formattedJapaneseTitle.isEmpty {
                                    Text(manga.formattedJapaneseTitle)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.bottom, 8)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                    }

                    // Espacio para el offset de la portada
                    Spacer().frame(height: 36)

                    // MARK: - Stats Bar
                    HStack(spacing: 0) {
                        StatItem(label: "Score", value: String(format: "%.2f", manga.score), color: .orange)
                        Divider().frame(height: 36)
                        StatItem(label: "Status", value: manga.status.displayName, color: .blue)
                        if let chapters = manga.chapters {
                            Divider().frame(height: 36)
                            StatItem(label: "Chapters", value: "\(chapters)", color: .primary)
                        }
                        if let volumes = manga.volumes {
                            Divider().frame(height: 36)
                            StatItem(label: "Volumes", value: "\(volumes)", color: .primary)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)

                    Divider()

                    VStack(alignment: .leading, spacing: 0) {

                            // MARK: - Synopsis
                            SectionBlock(title: "Synopsis") {
                                VStack(alignment: .trailing, spacing: 8) {
                                    Text(manga.synopsis)
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                        // Si está expandido es nil (infinito), si no, limitamos a 4
                                        .lineLimit(isSynopsisExpanded ? nil : 4)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Button {
                                        withAnimation(.spring()) {
                                            isSynopsisExpanded.toggle()
                                        }
                                    } label: {
                                        Text(isSynopsisExpanded ? "Read Less" : "Read More...")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.blue)
                                    }
                                }
                            }

                        // MARK: - Author
                        if !manga.authors.isEmpty {
                            SectionBlock(title: manga.authors.count > 1 ? "Authors" : "Author") {
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(manga.authors) { author in
                                        HStack {
                                            Text(author.fullName)
                                                .font(.subheadline)
                                            Spacer()
                                            Text(author.role.displayName)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                            Divider().padding(.horizontal)
                        }

                            // MARK: - Genres
                            if !manga.genres.isEmpty {
                                SectionBlock(title: "Genres") {
                                    FlowLayout(spacing: 8) {
                                        ForEach(manga.genres, id: \.self) { genre in
                                            GenreTag(genre: genre)
                                        }
                                    }
                                }
                                Divider().padding(.horizontal)
                            }

                        // MARK: - Themes
                        if !manga.themes.isEmpty {
                            SectionBlock(title: "Themes") {
                                FlowLayout(spacing: 8) {
                                    ForEach(manga.themes, id: \.self) { theme in
                                        ThemeTag(theme: theme)
                                    }
                                }
                            }
                            Divider().padding(.horizontal)
                        }

                        // MARK: - Collection
                        if isInLibrary {
                            SectionBlock(title: "My Collection") {
                                VStack(spacing: 16) {
                                    Picker("Status", selection: $selectedStatus) {
                                        ForEach(ReadingStatus.allCases, id: \.self) { status in
                                            Image(systemName: status.icon).tag(status)
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                    .onChange(of: selectedStatus) { _, newValue in
                                        switch newValue {
                                        case .collected:
                                            if let total = manga.volumes { volumesBought = total }
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
                                                if let total = manga.volumes, newValue > total { volumesBought = total }
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
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .onTapGesture { isInputActive = false }
            .navigationTitle(manga.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isInLibrary {
                        HStack(spacing: 16) {
                            Button(role: .destructive) {
                                showDeleteConfirmation = true
                            } label: {
                                Image(systemName: "trash").foregroundStyle(.red)
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
                            Task { await libraryViewModel.addManga(manga, status: .wishlist) }
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

// MARK: - Supporting Views

private struct StatItem: View {
    let label: String
    let value: String
    var color: Color = .primary

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(color)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct SectionBlock<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            content()
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
    }
}

// Layout en flujo para los tags (géneros, temas)
private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var height: CGFloat = 0
        var x: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                height += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        height += rowHeight
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
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
