//
//  PersonDetail.swift
//  MoviesAPIs
//
//  Created by mac on 22/9/26.
//

import Foundation

struct PersonDetail: Codable {
    let id: Int
    let name: String
    let biography: String
    let profilePath: String?
    let birthday: String?
    let popularity: Double
    let knownFor: String
    let placeOfBirth: String?
    let homepage: String?
    let gender: Gender
    
    enum CodingKeys: String, CodingKey {
        case id, name, biography, birthday, popularity, homepage, gender
        case profilePath = "profile_path"
        case knownFor = "known_for_department"
        case placeOfBirth = "place_of_birth"
    }
    
    var fullPosterURL: URL? {
        if let path = profilePath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        }
        return nil
    }
    
    // MARK: - Birthday
    
    private var birthdayDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: LanguageManager.shared.languageCode)
        
        return formatter.date(from: birthday ?? "")
    }
    
    var formattedBirthday: String {
        guard let date = birthdayDate else {
            return birthday ?? ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = LanguageManager.shared.languageCode == "en" ? "MMMM d, yyyy" : "d MMMM, yyyy"
        formatter.locale = Locale(identifier: LanguageManager.shared.languageCode)
        
        return formatter.string(from: date)
    }
    
    var age: Int? {
        guard let date = birthdayDate else {
            return nil
        }
        
        return Calendar.current.dateComponents(
            [.year],
            from: date,
            to: Date()
        ).year
    }
    
    var birthdayDisplayText: String {
        guard let age else {
            return formattedBirthday
        }
        
        return "\(formattedBirthday) (\(age) \("person.age".localized()))"
    }
}

enum Gender: Int, Codable {
    case notSet = 0
    case female = 1
    case male = 2
    case nonBinary = 3
    
    var displayName: String {
        switch self {
        case .notSet:
            return "person.gender.none".localized()
        case .female:
            return "person.gender.female".localized()
        case .male:
            return "person.gender.male".localized()
        case .nonBinary:
            return "person.gender.nonbinary".localized()
        }
    }
}
