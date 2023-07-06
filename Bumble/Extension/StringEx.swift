//
//  StringEx.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 06/07/2023.
//

import Foundation

extension String {
    var decimalCommaNumber: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        if let input = Double(self) {
            return formatter.string(from: NSNumber(value: input))
        } else {
            return nil
        }
    }
    
    var boDauTiengViet: String? {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
    
    var htmlToAtrributedText: NSAttributedString? {
        let data = Data(self.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
            return attributedString
        }
        return nil
    }
}
