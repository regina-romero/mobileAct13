//
//  UpdateBookTracker.swift
//  BookTracker
//
//  Created by Regina Romero on 9/29/25.
//

import SwiftUI
import NaturalLanguage // 🧠 Necesario para SentimentAnalyzer

// View for updating an existing book
struct UpdateBookTracker: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    @Bindable var book: Book
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 📚 Matching background
                Color(red: 0.95, green: 0.97, blue: 1.0)
                    .ignoresSafeArea()
                
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
                        // 📖 Book Icon Header
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
                            
                            Text(book.read ? "📖" : "📚")
                                .font(.system(size: 36))
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        
                        // Form Fields in Cards
                        VStack(spacing: 16) {
                            // Book Name Card
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Book Name")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 4)
                                
                                TextField("Enter book name", text: $book.name)
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
                            
                            // Author Card
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Author")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 4)
                                
                                TextField("Enter author name", text: $book.author)
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
                            
                            // 🟩 NUEVO: Review Section
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
                            
                            // Read Toggle Card
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Reading Status")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Text(book.read ? "Finished reading" : "Currently reading")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $book.read)
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
                            
                            // Date Pickers (only if read)
                            if book.read {
                                VStack(spacing: 16) {
                                    // Date Started Card
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Date Started")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(.secondary)
                                            .padding(.leading, 4)
                                        
                                        DatePicker("", selection: $book.dateStarted, displayedComponents: .date)
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
                                    
                                    // Date Finished Card
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Date Finished")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(.secondary)
                                            .padding(.leading, 4)
                                        
                                        DatePicker("", selection: $book.dateFinished, displayedComponents: .date)
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
                        
                        // Action Buttons
                        HStack(spacing: 12) {
                            // Cancel Button
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
                            
                            // Done Button
                            Button {
                                do {
                                    try context.save()
                                    dismiss()
                                } catch {
                                    errorMessage = "Error updating book"
                                    showError = true
                                }
                            } label: {
                                Text("Done")
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
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Edit Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                // Set rounded font for navigation title
                let appearance = UINavigationBarAppearance()
                appearance.configureWithDefaultBackground()
                appearance.backgroundColor = UIColor(Color(red: 0.95, green: 0.97, blue: 1.0))
                appearance.titleTextAttributes = [
                    .font: UIFont.systemFont(ofSize: 17, weight: .semibold, width: .standard),
                    .foregroundColor: UIColor.label
                ]
                
                if let descriptor = UIFont.systemFont(ofSize: 17, weight: .semibold).fontDescriptor.withDesign(.rounded) {
                    appearance.titleTextAttributes[.font] = UIFont(descriptor: descriptor, size: 17)
                }
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Failed to Update Book"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.75), value: book.read)
        }
    }
}

#Preview {
    UpdateBookTracker(book: Book(name: "Little Women", author: "Louisa May Alcott", dateStarted: .now, dateFinished: .now, read: false))
}
