//
//  AddBook.swift
//  BookTracker
//
//  Created by Regina Romero on 9/29/25.
//

import SwiftUI
import SwiftData
import NaturalLanguage // 👈 IMPORTANTE

struct AddBook: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    @State private var name: String = ""
    @State private var author: String = ""
    @State private var dateStarted: Date = .now
    @State private var dateFinished: Date = .now
    @State private var read: Bool = false
    @State private var review: String = "" // ✨ nuevo campo
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $name)
                TextField("Author", text: $author)
                
                TextEditor(text: $review)
                    .frame(height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                    .padding(.vertical, 8)
                    .foregroundColor(.primary)
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(10)
                    .overlay(Text("Write a short review...").opacity(review.isEmpty ? 0.5 : 0).padding(.leading, 5), alignment: .topLeading)
                
                Toggle("Read", isOn: $read)
                
                if read {
                    DatePicker("Date Started", selection: $dateStarted, displayedComponents: .date)
                    DatePicker("Date Finished", selection: $dateFinished, displayedComponents: .date)
                }
            }
            .navigationTitle("New Book")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        guard Book.isValidName(name), Book.isValidAuthor(author) else { return }
                        
                        // ✨ Analizar sentimiento antes de guardar
                        let sentiment = review.isEmpty ? nil : SentimentAnalyzer.analyze(text: review)
                        
                        let book = Book(
                            name: name,
                            author: author,
                            dateStarted: dateStarted,
                            dateFinished: dateFinished,
                            read: read,
                            review: review,
                            sentiment: sentiment
                        )
                        
                        context.insert(book)
                        try? context.save()
                        dismiss()
                    }
                    .disabled(!Book.isValidName(name) || !Book.isValidAuthor(author))
                }
            }
        }
    }
}


#Preview {
    AddBook()
}
