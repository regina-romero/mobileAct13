//
//  ContentView.swift
//  BookTracker
//
//  Created by Regina Romero on 9/29/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Book.dateStarted) var books: [Book]
    
    @State private var isShowingItemSheet = false
    @State private var bookToEdit: Book?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 📚 Background
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
                
                VStack(spacing: 0) {
                    // 🌟 Custom Header (Title + Plus Button Aligned)
                    HStack {
                        Text("My Library")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button {
                            isShowingItemSheet = true
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.25, green: 0.55, blue: 0.95),
                                                Color(red: 0.35, green: 0.68, blue: 0.95)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 38, height: 38)
                                    .shadow(color: .blue.opacity(0.35), radius: 8, x: 0, y: 3)
                                
                                Image(systemName: "plus")
                                    .font(.system(size: 19, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 4) // tightened top padding
                    .padding(.bottom, 6) // reduced bottom padding
                    
                    // 🧩 Main Content
                    if books.isEmpty {
                        VStack(spacing: 28) {
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
                                            startRadius: 20,
                                            endRadius: 80
                                        )
                                    )
                                    .frame(width: 160, height: 160)
                                
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
                                    .frame(width: 110, height: 110)
                                    .shadow(color: .blue.opacity(0.15), radius: 20, x: 0, y: 8)
                                
                                Image(systemName: "books.vertical.fill")
                                    .font(.system(size: 48, weight: .medium))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.3, green: 0.6, blue: 0.95),
                                                Color(red: 0.4, green: 0.8, blue: 0.85)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                            
                            VStack(spacing: 10) {
                                Text("Start Your Reading Journey")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.primary, .primary.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text("Track your books and build your\npersonal library")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                    .padding(.horizontal, 40)
                            }
                            
                            Button {
                                isShowingItemSheet = true
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    Text("Add Your First Book")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 28)
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
                                .cornerRadius(16)
                                .shadow(color: Color.blue.opacity(0.4), radius: 15, x: 0, y: 8)
                                .shadow(color: Color.blue.opacity(0.2), radius: 5, x: 0, y: 3)
                            }
                            .padding(.top, 10)
                        }
                        .padding(.top, 40) // less vertical space now
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 14) {
                                ForEach(books) { book in
                                    Button {
                                        bookToEdit = book
                                    } label: {
                                        BookCardView(book: book)
                                    }
                                    .buttonStyle(.plain)
                                    .transition(.scale.combined(with: .opacity))
                                }
                                .onDelete { indexSet in
                                    for index in indexSet {
                                        context.delete(books[index])
                                    }
                                }
                            }
                            .padding(.horizontal, 18)
                            .padding(.top, 12)
                            .padding(.bottom, 24)
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingItemSheet) {
                AddBook()
            }
            .sheet(item: $bookToEdit) { book in
                UpdateBookTracker(book: book)
            }
            .animation(.spring(response: 0.45, dampingFraction: 0.75), value: books.count)
        }
    }
}

// 📖 Premium Book Card Component
struct BookCardView: View {
    let book: Book
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(book.read ? Color.green.opacity(0.08) : Color.blue.opacity(0.08))
                    .frame(width: 66, height: 66)
                    .blur(radius: 8)
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: book.read
                                ? [
                                    Color(red: 0.7, green: 0.95, blue: 0.8),
                                    Color(red: 0.85, green: 0.98, blue: 0.9)
                                ]
                                : [
                                    Color(red: 0.75, green: 0.88, blue: 0.98),
                                    Color(red: 0.85, green: 0.93, blue: 0.98)
                                ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 62, height: 62)
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                
                Text(book.read ? "📖" : "📚")
                    .font(.system(size: 32))
            }
            
            VStack(alignment: .leading, spacing: 7) {
                Text(book.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(book.author)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.secondary.opacity(0.85))
                    .lineLimit(1)
                
                if let review = book.review, !review.isEmpty {
                                    Text("Review: \(review)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                
                if let sentiment = book.sentiment {
                    HStack(spacing: 5) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 11, weight: .semibold))
                        Text(sentiment)
                            .font(.system(size: 13, weight: .medium))
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
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.pink.opacity(0.12),
                                        Color.orange.opacity(0.08)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .padding(.top, 4)
                }
            }
            
            Spacer(minLength: 12)
            
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(book.read ? Color.green.opacity(0.15) : Color.blue.opacity(0.15))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: book.read ? "checkmark.seal.fill" : "book.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: book.read
                                    ? [Color(red: 0.2, green: 0.7, blue: 0.4), Color(red: 0.3, green: 0.8, blue: 0.5)]
                                    : [Color(red: 0.3, green: 0.6, blue: 0.95), Color(red: 0.4, green: 0.75, blue: 0.95)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                Text(book.read ? "Read" : "Reading")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(book.read ? Color(red: 0.2, green: 0.65, blue: 0.4) : Color(red: 0.3, green: 0.6, blue: 0.9))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(book.read ? Color(red: 0.9, green: 0.98, blue: 0.93) : Color(red: 0.9, green: 0.95, blue: 0.99))
            )
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
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
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
                .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.8),
                            Color.white.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Book.self], inMemory: true)
}

