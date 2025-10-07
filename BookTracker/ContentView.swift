//
//  ContentView.swift
//  BookTracker
//
//  Created by Regina Romero on 9/29/25.
//

import SwiftUI
import SwiftData

// Main view showing list of saved books
struct ContentView: View {
    @Environment(\.modelContext) var context
    // Query all books, sorted by dateStarted
    @Query(sort: \Book.dateStarted) var books: [Book]
    
    @State private var isShowingItemSheet = false
    @State private var bookToEdit: Book?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(book.name)
                                .font(.headline)
                            
                            Text(book.author)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            // 🧠 Mostrar análisis de sentimiento (Natural Language)
                            if let sentiment = book.sentiment {
                                Text(sentiment)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Text(book.read ? "📖 Read" : "📚 Will Read")
                            .foregroundColor(book.read ? .green : .blue)
                            .font(.subheadline)
                            .bold()
                    }
                    .padding(.vertical, 4)
                    .onTapGesture {
                        bookToEdit = book
                    }
                }
                // Delete action
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(books[index])
                    }
                }
            }
            .navigationTitle("My Library")
            .navigationBarTitleDisplayMode(.large)
            // Sheet for adding a new book
            .sheet(isPresented: $isShowingItemSheet) {
                AddBook()
            }
            // Sheet for editing an existing book
            .sheet(item: $bookToEdit) { book in
                UpdateBookTracker(book: book)
            }
            .toolbar {
                Button("Add", systemImage: "plus") {
                    isShowingItemSheet = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Book.self], inMemory: true)
}
