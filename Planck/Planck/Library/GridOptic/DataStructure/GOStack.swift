//
//  GOStack.swift
//  GridOptic
//
//  Created by Wang Jinghan on 02/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

// GOStack is an auxiliary data structure for facilitating some operation in
// the grid calculation. This is a typical implementation of a stack data
// structure with push, peek, and pop operation
struct GOStack<T> {
    var items = [T]()
    //  Adds an element to the top of the stack.
    mutating func push(item: T) {
        items.insert(item, atIndex: 0)
    }
    
    //  Removes the element at the top of the stack and return it.
    //  If the stack is empty, return nil.
    mutating func pop() -> T? {
        if items.isEmpty {
            return nil
        } else {
            return items.removeAtIndex(0)
        }
    }
    
    //  Returns, but does not remove, the element at the top of the stack.
    //  If the stack is empty, returns nil.
    func peek() -> T? {
        return items.first
    }
    
    //  Returns the number of elements currently in the stack.
    var count: Int {
        return items.count
    }
    
    //  Returns true if the stack is empty and false otherwise.
    var isEmpty: Bool {
        return items.isEmpty
    }
    
    //  Removes all elements in the stack.
    mutating func removeAll() {
        return items.removeAll(keepCapacity: false)
    }
    
    //  Returns an array of elements of the stack in the order
    //  that they are popped i.e. first element in the array
    //  is the first element popped.
    func toArray() -> [T] {
        return items
    }
}
