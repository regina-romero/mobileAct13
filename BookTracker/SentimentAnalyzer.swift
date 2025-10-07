//
//  SentimentAnalyzer.swift
//  BookTracker
//
//  Created by Regina Romero on 10/6/25.
//

import Foundation
import NaturalLanguage //framework de Apple que permite analisis de lenguaje natural

struct SentimentAnalyzer {
    //analiza texto y regresa su sentimiento como cadena
    static func analyze(text: String) -> String {
        // Crea un analizador que mide el sentimiento del texto
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        
        // El valor devuelto (sentiment) es un string con un número entre -1.0 y 1.0
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        let score = Double(sentiment?.rawValue ?? "0") ?? 0 // (si no hay valor, usa 0)
        
        // Clasifica el resultado en tres categorías según el puntaje
        switch score {
        case let x where x > 0.3:
            return "😊 Positive"
        case let x where x < -0.3:
            return "😞 Negative"
        default:
            return "😐 Neutral"
        }
    }
}
