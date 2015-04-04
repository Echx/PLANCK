//
//  String+XUtility.swift
//  Planck
//
//  Created by NULL on 04/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import Foundation

extension String {
    static func generateRandomString(len: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let lettersLength = UInt32(countElements(letters))
        let result = (0..<len).map { _ -> String in
            let idx = Int(arc4random_uniform(lettersLength))
            return String(letters[advance(letters.startIndex, idx)])
        }
        return "".join(result)
    }
}