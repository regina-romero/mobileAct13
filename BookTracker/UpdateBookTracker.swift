//
//  UpdateBookTracker.swift
//  BookTracker
//
//  Created by Regina Romero on 9/29/25.
//

import SwiftUI

// View for updating an existing book
struct UpdateBookTracker: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    @Bindable var book : Book
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack{
            
            
            Form{
                // Editable fields
                TextField("Book Name", text: $book.name)
                    TextField("Author", text: $book.author)
                    
                    Toggle("Read", isOn: $book.read)
                
                    // Show dates only if read
                    if book.read {
                        DatePicker("Date Started", selection: $book.dateStarted, displayedComponents: .date)
                        DatePicker("Date Finished", selection: $book.dateFinished, displayedComponents: .date)
                    }
            }
            .navigationTitle("New Book")
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                // Cancel and Done buttons
                ToolbarItemGroup(placement: .topBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing){
                    Button("Done"){

                        do {
                            try context.save() // Auto-saves changes via SwiftData binding
                            dismiss()
                        } catch {
                            errorMessage = "Error updating book"
                            showError = true
                        }
                    }
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Failed to edit book!"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
            
    }
}

#Preview {
    UpdateBookTracker(book: Book(name: "Little Women", author: "Louisa May Alcott", dateStarted: .now, dateFinished: .now, read: false))
}
