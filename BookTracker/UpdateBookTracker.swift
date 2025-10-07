//
//  UpdateBookTracker.swift
//  BookTracker
//
//  Created by Regina Romero on 9/29/25.
//

import SwiftUI
import NaturalLanguage // Necesario para analizar el sentimiento de la reseña

struct UpdateBookTracker: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    @Bindable var book: Book
    
    @State private var showError = false // Controla si se muestra una alerta de error
    @State private var errorMessage = "" // Mensaje que aparece en la alerta
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                        // Encabezado con ícono del libro
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
                        
                        // Campos del formulario
                        VStack(spacing: 16) {
                            // nombre del libro
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
                            }
                            
                            // autor
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
                            }
                            
                            //reseña
                            Section("Review") {
                                TextEditor(text: Binding(
                                    get: { book.review ?? "" },
                                    set: { newValue in
                                        book.review = newValue
                                        // Recalcula el sentimiento si se modifica la reseña
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
                            
                            // Marcar si el libro fue leído
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Reading Status")
                                        .font(.system(size: 15, weight: .semibold))
                                    Text(book.read ? "Finished reading" : "Currently reading")
                                        .font(.system(size: 13))
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
                                    .fill(Color.white.opacity(0.9))
                                    .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
                            )
                            
                            // si el libro fue leido, se escoge fecha de cuando empezo y cuando acabo el libro
                            if book.read {
                                VStack(spacing: 16) {
                                    // Fecha de inicio
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Date Started")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(.secondary)
                                        DatePicker("", selection: $book.dateStarted, displayedComponents: .date)
                                            .labelsHidden()
                                            .padding(16)
                                            .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.9)))
                                    }
                                    
                                    // Fecha que termino
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Date Finished")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(.secondary)
                                        DatePicker("", selection: $book.dateFinished, displayedComponents: .date)
                                            .labelsHidden()
                                            .padding(16)
                                            .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.9)))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Botones de acción
                        HStack(spacing: 12) {
                            // Botón para cancelar
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
                                    )
                            }
                            
                            // Botón para guardar los cambios
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
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Edit Book")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Failed to Update Book"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    UpdateBookTracker(book: Book(name: "Little Women", author: "Louisa May Alcott", dateStarted: .now, dateFinished: .now, read: false))
}
