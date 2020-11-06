//
//  String+SubString.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 28.02.20.
//  Copyright © 2020 Jeanette Müller. All rights reserved.
//

import Foundation

extension String {

    var length: Int {
        return self.count
    }

    subscript(_ i: Int) -> String {
        let idx1 = index(startIndex, offsetBy: i)
        let idx2 = index(idx1, offsetBy: 1)
        return String(self[idx1..<idx2])
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)

        let stringRange: Range<String.Index> = start..<end

        return String(self[stringRange])
    }
    
    func subString(from: Int) -> String {

        let idx1 = min(from, length)
        let idx2 = length

        return String(self[idx1..<idx2])
    }

    func subString(to: Int) -> String {

        let idx1 = 0
        let idx2 = max(0, to)

        return String(self[idx1 ..< idx2])
    }

}
