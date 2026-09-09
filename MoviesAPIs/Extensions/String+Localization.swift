//
//  String+Localization.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
    
    func localized(with arguments: CVarArg..., bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return String(format: localized(bundle: bundle, tableName: tableName), arguments: arguments)
    }
}
