//
//  AddBook.swift
//  BookTracker
//
//  Created by Regina Romero on 9/29/25.
//

import SwiftUI
import SwiftData

// View for creating a new book entry
struct AddBook: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    @State private var name: String = ""
    @State private var author: String = ""
    @State private var dateStarted: Date = .now
    @State private var dateFinished: Date = .now
    @State private var read: Bool = false
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $name)
                    TextField("Author", text: $author)
                    
                    Toggle("Read", isOn: $read)
                
                    // Only show date pickers if marked as read
                    if read {
                        DatePicker("Date Started", selection: $dateStarted, displayedComponents: .date)
                        DatePicker("Date Finished", selection: $dateFinished, displayedComponents: .date)
                        
                    }
            }
            .navigationTitle("New Book")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                // Cancel button
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                // Save button with validation
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        // Validation for name and author
                        guard Book.isValidName(name), Book.isValidAuthor(author) else { return }
                        // Create new book and insert in database
                        let book = Book(
                            name: name,
                            author: author,
                            dateStarted: dateStarted,
                            dateFinished: dateFinished,
                            read: read
                        )
                        context.insert(book)
                        do {
                            try context.save() // Try to save
                            dismiss()          // Close view
                        } catch {
                            // If error, show simple alert
                            errorMessage = "Error saving book"
                            showError = true
                        }
                    }
                    .disabled(!Book.isValidName(name) || !Book.isValidAuthor(author))
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Failed to save book!"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}


#Preview {
    AddBook()
}
