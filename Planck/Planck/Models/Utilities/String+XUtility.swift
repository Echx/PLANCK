//
//  String+XUtility.swift
//  Planck
//
//  Created by Wang Jinghan on 04/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

extension String {
    //generate a random string with given length
    static func generateRandomString(length: Int) -> String {
        //possible letters in the random string
        let possibleChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let numberOfChars = UInt32(countElements(possibleChars))
        let result = (0..<length).map { _ -> String in
            let randomDistance = Int(arc4random_uniform(numberOfChars))
            //retrieve and return the character
            return String(possibleChars[advance(possibleChars.startIndex, randomDistance)])
        }
        
        //join the result array into a new string and return
        return "".join(result)
    }
}