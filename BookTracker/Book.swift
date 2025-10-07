//
//  Book.swift
//  BookTracker
//
//  Created by Regina Romero on 9/29/25.
//

import Foundation
import SwiftData

@Model
class Book {
    var name: String
    var author: String
    var dateStarted: Date
    var dateFinished: Date
    var read: Bool
    
    // ✨ NUEVO: reseña del usuario
    var review: String?
    
    // ✨ NUEVO: resultado del análisis ML
    var sentiment: String?

    init(name: String, author: String, dateStarted: Date, dateFinished: Date, read: Bool, review: String? = nil, sentiment: String? = nil) {
        self.name = name
        self.author = author
        self.dateStarted = dateStarted
        self.dateFinished = dateFinished
        self.read = read
        self.review = review
        self.sentiment = sentiment
    }

    static func isValidName(_ name: String) -> Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    static func isValidAuthor(_ author: String) -> Bool {
        !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

