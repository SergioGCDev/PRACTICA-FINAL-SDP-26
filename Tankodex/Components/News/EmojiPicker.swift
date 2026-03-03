//
//  EmojiPicker.swift
//  Tankodex
//
//  Created by Sergio García on 3/3/26.
//

import SwiftUI

struct EmojiPicker: View {
    @Binding var selectedEmoji: String
    @Environment(\.dismiss) private var dismiss

    private let categories: [(title: String, emojis: [String])] = [
        ("Faces",   ["😀", "😎", "🤓", "🥸", "🤩", "🥳", "😤", "😴"]),
        ("Animals", ["🐱", "🐶", "🐼", "🦊", "🐨", "🐯", "🦁", "🐸"]),
        ("Objects", ["📚", "🎮", "🎨", "🎵", "⚡️", "🔥", "💎", "🌙"]),
        ("Food",    ["🍜", "🍕", "🍣", "☕️", "🧃", "🍩"])
    ]

    private let columns = Array(repeating: GridItem(.flexible()), count: 4)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(categories, id: \.title) { category in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(category.title)
                                .font(.headline)
                                .padding(.horizontal)

                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(category.emojis, id: \.self) { emoji in
                                    Button {
                                        selectedEmoji = emoji
                                        dismiss()
                                    } label: {
                                        Text(emoji)
                                            .font(.system(size: 40))
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(
                                                selectedEmoji == emoji
                                                    ? Color.accentColor.opacity(0.2)
                                                    : Color.clear,
                                                in: RoundedRectangle(cornerRadius: 10)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Choose Avatar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var emoji = "😀"
    EmojiPicker(selectedEmoji: $emoji)
}
