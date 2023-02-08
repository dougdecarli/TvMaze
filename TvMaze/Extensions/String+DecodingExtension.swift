//
//  String+DecodingExtension.swift
//  TvMaze
//
//  Created by Douglas Immig on 07/02/23.
//

import Foundation
extension String {
    var htmlDecoded: String {
        guard let stringData = data(using: .utf8) else {
            return ""
        }
        let attributedString = try? NSAttributedString(
            data: stringData,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
        return attributedString?.string ?? ""
    }

    var urlEncoded: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
}
