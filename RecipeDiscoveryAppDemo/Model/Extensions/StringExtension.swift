//
//  StringExtension.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 15/10/25.
//

import Foundation


extension String {
    /// Trim whitespace/newlines and lowercase copy
    var normalizedEmail: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    /// Regex-based email validation (good balance of correctness and practicality)
    var isValidEmail: Bool {
        let email = self.normalizedEmail
        // Reasonable regex: allows most valid addresses while blocking obvious invalid strings.
        // Not 100% RFC5322-complete (those regexes are huge); this is practical for UI validation.
        let pattern =
        #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        let range = NSRange(location: 0, length: email.utf16.count)
        return regex?.firstMatch(in: email, options: [], range: range) != nil
    }

    var isValidEmailUsingDataDetector: Bool {
        let email = self.normalizedEmail
        guard !email.isEmpty else { return false }
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count))
            guard let match = matches.first, matches.count == 1 else { return false }
            guard match.range.length == email.utf16.count else { return false }
            return match.url?.scheme == "mailto"
        } catch {
            return false
        }
    }
    
    /// Validates if a string has at least:
    /// - 6 characters
    /// - 1 letter
    /// - 1 number
    /// - 1 special character
    var isValidPassword: Bool {
        // Regex:
        // ^(?=.*[A-Za-z])  → must contain a letter
        // (?=.*\d)         → must contain a digit
        // (?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]) → must contain a special char
        // .{6,}$           → at least 6 characters long
        let pattern = #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]).{6,}$"#
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
}
