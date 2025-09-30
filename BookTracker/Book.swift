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
    var author : String
    var dateStarted : Date
    var dateFinished : Date
    var read : Bool
    
    init(name: String, author: String, dateStarted : Date, dateFinished: Date, read: Bool) {
        self.name = name
        self.author = author
        self.dateStarted = dateStarted
        self.dateFinished = dateFinished
        self.read = read
    }
    static func isValidName(_ name: String) -> Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    static func isValidAuthor(_ author: String) -> Bool {
        !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
