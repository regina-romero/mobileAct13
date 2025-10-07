//
//  AddBook.swift
//  BookTracker
//
//  Created by Regina Romero on 9/29/25.
//

import SwiftUI
import SwiftData
import NaturalLanguage

struct AddBook: View {
    // Environment variables
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    // Form field states
    @State private var name: String = ""
    @State private var author: String = ""
    @State private var dateStarted: Date = .now
    @State private var dateFinished: Date = .now
    @State private var read: Bool = false
    @State private var review: String = "" // Used for sentiment analysis
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.95, green: 0.97, blue: 1.0)
                    .ignoresSafeArea()
                
                // Gradient overlay for UI enhancement
                LinearGradient(
                    colors: [
                        Color(red: 0.4, green: 0.7, blue: 1.0).opacity(0.15),
                        Color(red: 0.6, green: 0.85, blue: 0.95).opacity(0.08),
                        Color(red: 0.5, green: 0.95, blue: 0.85).opacity(0.12),
                        Color(red: 0.7, green: 0.8, blue: 1.0).opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Decorative book icon with glowyy effect
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.blue.opacity(0.15),
                                            Color.mint.opacity(0.08),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 15,
                                        endRadius: 50
                                    )
                                )
                                .frame(width: 100, height: 100)
                            
                            // Inner circle with gradient!
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.85, green: 0.95, blue: 1.0),
                                            Color(red: 0.9, green: 0.98, blue: 0.98)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 70, height: 70)
                                .shadow(color: .blue.opacity(0.15), radius: 15, x: 0, y: 5)
                            
                            Text("📚")
                                .font(.system(size: 36))
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        
                        // Form fields container
                        VStack(spacing: 16) {
                            // Book Title input field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Book Title")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 4)
                                
                                TextField("Enter book title", text: $name)
                                    .font(.system(size: 17, weight: .medium))
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.white.opacity(0.9))
                                            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
                                    )
                            }
                            
                            // Author input field complemented with testing
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Author")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 4)
                                
                                TextField("Enter author name", text: $author)
                                    .font(.system(size: 17, weight: .medium))
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.white.opacity(0.9))
                                            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
                                    )
                            }
                            
                            // Review text editor with sentiment analysis indicator
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Review")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    // Show sentiment analysis indicator when review has text
                                    if !review.isEmpty {
                                        HStack(spacing: 4) {
                                            Image(systemName: "sparkles")
                                                .font(.system(size: 10))
                                            Text("Sentiment analysis enabled")
                                                .font(.system(size: 11, weight: .medium))
                                        }
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 1.0, green: 0.4, blue: 0.6),
                                                    Color(red: 1.0, green: 0.6, blue: 0.3)
                                                ],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                    }
                                }
                                .padding(.leading, 4)
                                
                                ZStack(alignment: .topLeading) {
                                    // Placeholder text (only shown when empty)
                                    if review.isEmpty {
                                        Text("Write a short review of the book...")
                                            .font(.system(size: 16))
                                            .foregroundColor(.secondary.opacity(0.5))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 16)
                                    }
                                    
                                    TextEditor(text: $review)
                                        .font(.system(size: 16))
                                        .frame(height: 120)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 12)
                                        .scrollContentBackground(.hidden)
                                        .background(Color.clear)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.white.opacity(0.9))
                                        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
                                )
                            }
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Reading Status")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.primary)
                                    // Dynamic status text based on toggle
                                    Text(read ? "Finished reading" : "Currently reading")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                
                                // Toggle switch for read status
                                Toggle("", isOn: $read)
                                    .labelsHidden()
                                    .tint(Color(red: 0.3, green: 0.65, blue: 0.95))
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.95),
                                                Color.white.opacity(0.85)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
                            )
                            
                            // Date pickers that are only shown when book is marked as read
                            if read {
                                VStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Date Started")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(.secondary)
                                            .padding(.leading, 4)
                                        
                                        DatePicker("", selection: $dateStarted, displayedComponents: .date)
                                            .datePickerStyle(.compact)
                                            .labelsHidden()
                                            .padding(16)
                                            .background(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .fill(Color.white.opacity(0.9))
                                                    .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
                                            )
                                    }
                                    
                                    // Date finished picker
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Date Finished")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(.secondary)
                                            .padding(.leading, 4)
                                        
                                        DatePicker("", selection: $dateFinished, displayedComponents: .date)
                                            .datePickerStyle(.compact)
                                            .labelsHidden()
                                            .padding(16)
                                            .background(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .fill(Color.white.opacity(0.9))
                                                    .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
                                            )
                                    }
                                }
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Action buttons!!
                        HStack(spacing: 12) {
                            // Cancel button
                            Button {
                                dismiss()
                            } label: {
                                Text("Cancel")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(Color(red: 0.3, green: 0.6, blue: 0.95))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.white.opacity(0.9))
                                            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .strokeBorder(
                                                Color(red: 0.3, green: 0.6, blue: 0.95).opacity(0.3),
                                                lineWidth: 1.5
                                            )
                                    )
                            }
                            
                            // Save button
                            Button {
                                // This line validates required fields
                                guard Book.isValidName(name), Book.isValidAuthor(author) else { return }
                                
                                // Analyzes sentiment from review text
                                let sentiment = review.isEmpty ? nil : SentimentAnalyzer.analyze(text: review)
                                
                                // Creates new book instance
                                let book = Book(
                                    name: name,
                                    author: author,
                                    dateStarted: dateStarted,
                                    dateFinished: dateFinished,
                                    read: read,
                                    review: review,
                                    sentiment: sentiment
                                )
                                
                                // Save to context and dismiss
                                context.insert(book)
                                try? context.save()
                                dismiss()
                            } label: {
                                Text("Save")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.2, green: 0.5, blue: 0.95),
                                                Color(red: 0.3, green: 0.65, blue: 0.95)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(14)
                                    .shadow(color: Color.blue.opacity(0.4), radius: 12, x: 0, y: 6)
                                    .shadow(color: Color.blue.opacity(0.2), radius: 4, x: 0, y: 2)
                            }
                            // Disable button if validation fails
                            .disabled(!Book.isValidName(name) || !Book.isValidAuthor(author))
                            .opacity((!Book.isValidName(name) || !Book.isValidAuthor(author)) ? 0.5 : 1.0)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("New Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                // Configure rounded font for navigation title!!
                let appearance = UINavigationBarAppearance()
                appearance.configureWithDefaultBackground()
                appearance.backgroundColor = UIColor(Color(red: 0.95, green: 0.97, blue: 1.0))
                appearance.titleTextAttributes = [
                    .font: UIFont.systemFont(ofSize: 17, weight: .semibold, width: .standard),
                    .foregroundColor: UIColor.label
                ]
                
                // Apply rounded font design
                if let descriptor = UIFont.systemFont(ofSize: 17, weight: .semibold).fontDescriptor.withDesign(.rounded) {
                    appearance.titleTextAttributes[.font] = UIFont(descriptor: descriptor, size: 17)
                }
                
                // Apply to all navigation bar states
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
            }
            // Smooth animation when toggling read status
            .animation(.spring(response: 0.4, dampingFraction: 0.75), value: read)
        }
    }
}

#Preview {
    AddBook()
}
