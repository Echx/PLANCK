//
//  String+XUtility.swift
//  Planck
//
//  Created by Wang Jinghan on 04/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

extension String {
    //generate a random string with given length
    static func generateRandomString(len: Int) -> String {
        //possible letters in the random string
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let numberOfLetters = UInt32(countElements(letters))
        let result = (0..<len).map { _ -> String in
            let randomDistance = Int(arc4random_uniform(numberOfLetters))
            //retrieve and return the character
            return String(letters[advance(letters.startIndex, randomDistance)])
        }
        
        //join the result array into a new string and return
        return "".join(result)
    }
}