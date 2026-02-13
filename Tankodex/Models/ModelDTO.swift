    //
    //  ModelDTO.swift
    //  myMangas
    //
    //  Created by Sergio García on 22/12/25.
    //

import Foundation

    // MARK: - Enums / Enumeraciones

enum Theme: String, Codable, CaseIterable {
    case gore = "Gore"
    case military = "Military"
    case mythology = "Mythology"
    case psychological = "Psychological"
    case historical = "Historical"
    case samurai = "Samurai"
    case romanticSubtext = "Romantic Subtext"
    case school = "School"
    case adultCast = "Adult Cast"
    case parody = "Parody"
    case superPower = "Super Power"
    case teamSports = "Team Sports"
    case delinquents = "Delinquents"
    case workplace = "Workplace"
    case survival = "Survival"
    case childcare = "Childcare"
    case iyashikei = "Iyashikei"
    case reincarnation = "Reincarnation"
    case showbiz = "Showbiz"
    case anthropomorphic = "Anthropomorphic"
    case lovePolygon = "Love Polygon"
    case music = "Music"
    case mecha = "Mecha"
    case combatSports = "Combat Sports"
    case isekai = "Isekai"
    case gagHumor = "Gag Humor"
    case crossdressing = "Crossdressing"
    case reverseHarem = "Reverse Harem"
    case martialArts = "Martial Arts"
    case visualArts = "Visual Arts"
    case harem = "Harem"
    case otakuCulture = "Otaku Culture"
    case timeTravel = "Time Travel"
    case videoGame = "Video Game"
    case strategyGame = "Strategy Game"
    case vampire = "Vampire"
    case mahouShoujo = "Mahou Shoujo"
    case highStakesGame = "High Stakes Game"
    case cgdct = "CGDCT"
    case organizedCrime = "Organized Crime"
    case detective = "Detective"
    case performingArts = "Performing Arts"
    case medical = "Medical"
    case space = "Space"
    case memoir = "Memoir"
    case villainess = "Villainess"
    case racing = "Racing"
    case pets = "Pets"
    case magicalSexShift = "Magical Sex Shift"
    case educational = "Educational"
    case idolsFemale = "Idols (Female)"
    case idolsMale = "Idols (Male)"
}

enum MangaStatus: String, Codable, CaseIterable {
    case discontinued = "discontinued"
    case onHiatus = "on_hiatus"
    case publishing = "currently_publishing"
    case finished = "finished"
    case none = "none"
        
    var displayName: String {
        switch self {
        case .discontinued: return "Discontinuado"
        case .onHiatus: return "En pausa"
        case .publishing: return "Publicándose"
        case .finished: return "Finalizado"
        case .none: return "Desconocido"
        }
    }
}

enum AuthorRole: String, Codable, CaseIterable {
    case art = "Art"
    case storyAndArt = "Story & Art"
    case story = "Story"
    case none = "None"
            
    var displayName: String {
        rawValue
    }
}

    // MARK: - Response Models / Modelos de Respuesta

struct MangaListResponse: Codable {
    let items: [MangaDTO]
    let metadata: MetadataDTO
}

struct MetadataDTO: Codable {
    let total: Int
    let page: Int
    let per: Int
}

    // MARK: - Supporting DTOs / DTOs de Soporte

struct GenreDTO: Codable, Identifiable {
    let id: String
    let genre: String
                    
    var asEnum: Genre? {
        Genre(rawValue: genre)
    }
}

struct ThemeDTO: Codable, Identifiable {
    let id: String
    let theme: String
                    
    var asEnum: Theme? {
        Theme(rawValue: theme)
    }
}

struct DemographicDTO: Codable, Identifiable {
    let id: String
    let demographic: String
                    
    var asEnum: Demographic? {
        Demographic(rawValue: demographic)
    }
}

struct AuthorDTO: Codable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let role: AuthorRole
                    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

    // MARK: - Main Manga DTO / DTO Principal de Manga

struct MangaDTO: Codable, Identifiable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    let mainPicture: String?
    let sypnosis: String?
    let background: String?
    let score: Double
    let status: MangaStatus
    let chapters: Int?
    let volumes: Int?
    let startDate: String?
    let endDate: String?
    let url: String?
    let genres: [GenreDTO]
    let themes: [ThemeDTO]
    let demographics: [DemographicDTO]
    let authors: [AuthorDTO]
}

    // MARK: - DTO to Model Transformations / Transformaciones de DTO a Modelo

extension MangaDTO {
    var toManga: Manga {
        Manga(
            id: id,
            title: title,
            titleEnglish: titleEnglish,
            titleJapanese: titleJapanese,
            mainPicture: mainPicture.flatMap { URL(string: $0.cleanedURL) },
            synopsis: sypnosis ?? "",
            background: background,
            score: score,
            status: status,
            chapters: chapters,
            volumes: volumes,
            startDate: startDate?.toDate(),
            endDate: endDate?.toDate(),
            url: url.flatMap { URL(string: $0.cleanedURL) },
            genres: genres.compactMap { Genre(rawValue: $0.genre) },
            themes: themes.compactMap { Theme(rawValue: $0.theme) },
            demographics: demographics
                .compactMap { Demographic(rawValue: $0.demographic) },
            authors: authors.map(\.toAuthor)
        )
    }
}

extension AuthorDTO {
    var toAuthor: Author {
        Author(
            id: id,
            fullName: "\(firstName) \(lastName)",
            role: role
        )
    }
}

extension MetadataDTO {
    var toPaginationMetadata: PaginationMetadata {
        PaginationMetadata(
            total: total,
            currentPage: page,
            itemsPerPage: per
        )
    }
}

extension MangaListResponse {
    var toMangaListResult: MangaListResult {
        MangaListResult(
            mangas: items.map(\.toManga),
            metadata: metadata.toPaginationMetadata
        )
    }
}

    // MARK: - Helper Extensions / Extensiones de Ayuda

extension String {
    var cleanedURL: String {
        self.replacingOccurrences(of: "\\", with: "")
            .replacingOccurrences(of: "\"", with: "")
    }
        
    func toDate() -> Date? {
        ISO8601DateFormatter().date(from: self)
    }
}
