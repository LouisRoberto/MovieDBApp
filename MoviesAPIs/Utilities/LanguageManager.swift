//
//  LanguageManager.swift
//  MoviesAPIs
//
//  Created by mac on 18/5/25.
//

import Foundation

final class LanguageManager {
    static let shared = LanguageManager()
    
    private init() {}
    
    var currentLanguage: String {
        // Get the device language or default to English
        let deviceLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        // Check if the device language is supported by TMDB
        return supportedLanguages.contains(deviceLanguage) ? deviceLanguage : "en"
    }
    
    // List of languages supported by TMDB API
    private let supportedLanguages = ["en", "es", "fr", "de", "it", "pt", "ru"]
    
    // ISO 639-1 language code
    var languageCode: String {
        return currentLanguage
    }
    
    // ISO 3166-1 region code (optional, can improve results)
    var regionCode: String {
        return Locale.current.region?.identifier ?? "US"
    }
}
