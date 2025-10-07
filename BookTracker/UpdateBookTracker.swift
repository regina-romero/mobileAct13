//
//  UpdateBookTracker.swift
//  BookTracker
//
//  Created by Regina Romero on 9/29/25.
//

import SwiftUI
import NaturalLanguage // 🟩 Import para usar SentimentAnalyzer

struct UpdateBookTracker: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    @Bindable var book: Book
    
    var body: some View {
        NavigationStack {
            Form {
                // Editable fields
                TextField("Book Name", text: $book.name)
                TextField("Author", text: $book.author)
                
                // 🟩 NUEVA SECCIÓN: Campo editable para reseña
                Section("Review") {
                    TextEditor(text: Binding(
                        get: { book.review ?? "" },
                        set: { newValue in
                            book.review = newValue
                            // 🧠 Recalcular el sentimiento si se cambia la reseña
                            if !newValue.isEmpty {
                                book.sentiment = SentimentAnalyzer.analyze(text: newValue)
                            } else {
                                book.sentiment = nil
                            }
                        }
                    ))
                    .frame(height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                }
                
                Toggle("Read", isOn: $book.read)
                
                // Show dates only if read
                if book.read {
                    DatePicker("Date Started", selection: $book.dateStarted, displayedComponents: .date)
                    DatePicker("Date Finished", selection: $book.dateFinished, displayedComponents: .date)
                }
            }
            .navigationTitle("Edit Book")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") {
                        try? context.save()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    UpdateBookTracker(book: Book(
        name: "Little Women",
        author: "Louisa May Alcott",
        dateStarted: .now,
        dateFinished: .now,
        read: false,
        review: "Beautifully written, loved the characters!",
        sentiment: "😊 Positive"
    ))
}
