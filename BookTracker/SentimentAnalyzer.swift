//
//  SentimentAnalyzer.swift
//  BookTracker
//
//  Created by Regina Romero on 10/6/25.
//

import Foundation
import NaturalLanguage

struct SentimentAnalyzer {
    static func analyze(text: String) -> String {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        let score = Double(sentiment?.rawValue ?? "0") ?? 0
        
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
