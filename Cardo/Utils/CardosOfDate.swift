//
//  CardosOfDate.swift
//  Cardo
//
//  Created by happts on 2019/3/29.
//  Copyright © 2019 happts. All rights reserved.
//

import Foundation
struct CardosOfDate {
    var allDays:[CardosOfOneDay] = []
    
    
    mutating func append(cardo:Cardo) -> Int {
        return 1
    }
    
    //FIXME:实现定位 index
    func index(oftime:String) -> Int {
        
        return 1
    }
    //FIXME:实现二分查找
    func binarySearch(_ time:Date) -> Int {
        var index = 1
        index = 2
        return index
    }
    
}

struct CardosOfOneDay {
    var time:String
    var cardos:[Cardo]
    
    var isEmpty:Bool {
        get {
            return cardos.isEmpty
        }
    }
    
    init(cardo:Cardo) {
        time = cardo.time
        cardos = [cardo]
    }
    init(time:String) {
        self.time = time
        cardos = []
    }
    
    /// add a cardo
    /// - Parameter cardo: The new cardo to append to the array cardos.
    /// - Returns: the new cardo's index
    mutating func append(cardo:Cardo) -> Int {
        cardos.append(cardo)
        return cardos.endIndex-1
    }
    
    /// remove a cardo
    /// - Parameter at: The position of the element to remove. index must be a valid index of the array.
    /// - Returns: cardos is empty or not
    mutating func remove(at:Int) -> Bool{
        cardos.remove(at: at)
        return isEmpty
    }
    
}
