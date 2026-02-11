    //
    //  Model.swift
    //  myMangas
    //
    //  Created by Sergio García on 23/12/25.
    //

import Foundation

    // MARK: - Model / Model
struct Manga: Identifiable, Hashable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    let mainPicture: URL?  // ← Ya limpio, como URL
    let synopsis: String  // ← Typo corregido
    let background: String?
    let score: Double
    let status: MangaStatus  // ← Enum directamente
    let chapters: Int?
    let volumes: Int?
    let startDate: Date?  // ← Date en lugar de String
    let endDate: Date?
    let url: URL?
    let genres: [Genre]  // ← Solo enums, sin IDs
    let themes: [Theme]
    let demographics: [Demographic]
    let authors: [Author]
}

struct Author: Identifiable, Hashable {
    let id: String
    let fullName: String  // ← Ya concatenado
    let role: AuthorRole
}

    // MARK: - Pagination Result

struct MangaListResult {
    let mangas: [Manga]
    let metadata: PaginationMetadata
}

struct PaginationMetadata {
    let total: Int
    let currentPage: Int
    let itemsPerPage: Int
        
    var totalPages: Int {
        (total + itemsPerPage - 1) / itemsPerPage
    }
        
    var hasMorePages: Bool {
        currentPage < totalPages
    }
        
    var hasPreviousPage: Bool {
        currentPage > 1
    }
}

extension Manga {
    var formattedJapaneseTitle: String {
        titleJapanese.map { "(\($0))" } ?? ""
    }
    
    var formattedEnglishTitle: String {
        titleEnglish.map { "(\($0))" } ?? ""
    }
    
}
   
#if DEBUG
extension MangaListResult {
    static let test = MangaListResult(
        mangas: [.test, .test2, .test3, .test4, .test5],
        metadata: .test
    )
}
    extension Manga {
        static let test = Manga(
                id: 1,
                title: "One Piece",
                titleEnglish: "One Piece",
                titleJapanese: "ワンピース",
                mainPicture: URL(string: "https://cdn.myanimelist.net/images/manga/2/253146.jpg"),
                synopsis: "Gol D. Roger, a man referred to as the 'Pirate King,' is set to be executed by the World Government.",
                background: "One Piece is the best-selling manga series of all time.",
                score: 9.21,
                status: .publishing,
                chapters: 1100,
                volumes: 107,
                startDate: Date(),
                endDate: nil,
                url: URL(string: "https://myanimelist.net/manga/13/One_Piece"),
                genres: [.action, .adventure, .fantasy],
                themes: [.military],
                demographics: [.shounen],
                authors: [.test]
            )
            
            static let test2 = Manga(
                id: 2,
                title: "Berserk",
                titleEnglish: "Berserk",
                titleJapanese: nil,
                mainPicture: URL(string: "https://cdn.myanimelist.net/images/manga/1/157931.jpg"),
                synopsis: "Guts, a former mercenary now known as the Black Swordsman, is out for revenge.",
                background: "Berserk is considered one of the greatest manga of all time.",
                score: 9.47,
                status: .publishing,
                chapters: 380,
                volumes: 41,
                startDate: Date(),
                endDate: nil,
                url: URL(string: "https://myanimelist.net/manga/2/Berserk"),
                genres: [.action, .drama, .horror],
                themes: [.military],
                demographics: [.seinen],
                authors: [.test]
            )
            
            static let test3 = Manga(
                id: 3,
                title: "Naruto",
                titleEnglish: "Naruto",
                titleJapanese: "ナルト",
                mainPicture: URL(string: "https://cdn.myanimelist.net/images/manga/3/249658.jpg"),
                synopsis: "Naruto Uzumaki wants to become the best ninja in the land.",
                background: nil,
                score: 8.14,
                status: .finished,
                chapters: 700,
                volumes: 72,
                startDate: Date(),
                endDate: Date(),
                url: URL(string: "https://myanimelist.net/manga/11/Naruto"),
                genres: [.action, .adventure],
                themes: [.martialArts],
                demographics: [.shounen],
                authors: [.test]
            )
            
            static let test4 = Manga(
                id: 4,
                title: "Attack on Titan",
                titleEnglish: "Attack on Titan",
                titleJapanese: "進撃の巨人",
                mainPicture: URL(string: "https://cdn.myanimelist.net/images/manga/2/37846.jpg"),
                synopsis: "Humanity lives inside cities surrounded by enormous walls.",
                background: nil,
                score: 8.56,
                status: .finished,
                chapters: 139,
                volumes: 34,
                startDate: Date(),
                endDate: Date(),
                url: URL(string: "https://myanimelist.net/manga/23390"),
                genres: [.action, .drama],
                themes: [.military],
                demographics: [.shounen],
                authors: [.test]
            )
            
            static let test5 = Manga(
                id: 5,
                title: "Death Note",
                titleEnglish: "Death Note",
                titleJapanese: "デスノート",
                mainPicture: URL(string: "https://cdn.myanimelist.net/images/manga/2/253119.jpg"),
                synopsis: "Light Yagami finds a notebook that can kill anyone.",
                background: nil,
                score: 8.71,
                status: .finished,
                chapters: 108,
                volumes: 12,
                startDate: Date(),
                endDate: Date(),
                url: URL(string: "https://myanimelist.net/manga/21/Death_Note"),
                genres: [.mystery],
                themes: [.psychological],
                demographics: [.shounen],
                authors: [.test]
            )
    }

    extension Author {
        static let test = Author(
                id: "1",
                fullName: "Oda Eiichiro",
                role: .storyAndArt
            )
            
            static let test2 = Author(
                id: "2",
                fullName: "Miura Kentarou",
                role: .storyAndArt
            )
            
            static let test3 = Author(
                id: "3",
                fullName: "Kishimoto Masashi",
                role: .storyAndArt
            )
            
            static let test4 = Author(
                id: "4",
                fullName: "Isayama Hajime",
                role: .storyAndArt
            )
            
            static let test5 = Author(
                id: "5",
                fullName: "Ohba Tsugumi",
                role: .story
            )
            
            static let test6 = Author(
                id: "6",
                fullName: "Obata Takeshi",
                role: .art
            )
    }

    extension PaginationMetadata {
        static let test = PaginationMetadata(
            total: 100, // Aunque tengamos 5 datos creados.
            currentPage: 1,
            itemsPerPage: 20
        )
    }
#endif // DEBUG
