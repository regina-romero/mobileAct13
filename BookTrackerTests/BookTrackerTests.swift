//
//  BookTrackerTests.swift
//  BookTrackerTests
//
//  Created by Regina Romero on 9/29/25.
//

import Testing
import Foundation
@testable import BookTracker

struct BookTrackerTests {

    @Test("Name and Author must not be empty or whitespace")
    func testValidation() async throws {
        #expect(Book.isValidName("Little Women"))  // ✅ válido
        #expect(!Book.isValidName(""))             // ❌ vacío
        #expect(!Book.isValidName("   "))          // ❌ espacios

        #expect(Book.isValidAuthor("Louisa May Alcott")) // ✅ válido
        #expect(!Book.isValidAuthor(""))                 // ❌ vacío
        #expect(!Book.isValidAuthor(" "))                // ❌ espacios
    }
    
    @Test("Read books should retain dates")
    func testReadBookDates() {
        let now = Date()
        let book = Book(name: "Test", author: "Tester", dateStarted: now, dateFinished: now, read: true)
        
        #expect(book.read == true)
        #expect(book.dateStarted == now)
        #expect(book.dateFinished == now)
    }
}
