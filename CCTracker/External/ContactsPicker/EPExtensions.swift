//
//  EPExtensions.swift
//  EPContactPicker
//
//  Created by Prabaharan Elangovan on 14/10/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit
import Foundation

class EPExtensions: NSObject {

}

extension String {
    subscript (r: Range<Int>) -> String? {
        get {
            let stringCount = self.count as Int
            if (stringCount < r.endIndex) || (stringCount < r.startIndex){
                return nil
            }
            let startIndex = self.index(self.startIndex, offsetBy: r.startIndex)
            let endIndex = self.index(self.startIndex, offsetBy: r.endIndex - r.startIndex)
            
            
//            return self[Range(start: startIndex, end: endIndex)]
            return ""
        }
    }
    
    func containsAlphabets() -> Bool {
        //Checks if all the characters inside the string are alphabets
        let set = NSCharacterSet.letters
        
        //TODO - Fix the below line
//        return self.utf16.contains({ return set($0.characterIsMember)  })
        return true
        
    }
}
