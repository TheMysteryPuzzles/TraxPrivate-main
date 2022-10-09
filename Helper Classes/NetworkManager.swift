//
//  NetworkManager.swift
//  Trax
//
//  Created by mac on 25/08/2022.
//

import UIKit
import Foundation

class AppManager: NSObject {
    
    class var sharedInstance: AppManager {
           struct Singleton {
               static let instance = AppManager()
           }
           return Singleton.instance
       }
    
    func checkValidEmail(data: String) -> Bool {
           let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
           let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
           return (emailTest.evaluate(with: data))
       }
    
    func validateMobileNumber(data: String) -> Bool{
        
        if !data.isValidPhoneNumber() {
            return false
        }
        if data.count < 10 {
            return false
        }
        return true
    }
    
    func append (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
    {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }

    func getSingleRowSectionSizeAndFont() -> Double {
        let bounds = UIScreen.main.bounds
        
        if (bounds.height > 700) {
            return 0.23
        }else{
            return 0.25
        }
    }
    
    func getCouponsLitingCellSize() -> Double {
        let bounds = UIScreen.main.bounds
        
        if (bounds.height > 700) {
            return 0.28
        }else{
            return 0.36 
        }
    }
    
    
    
    func getRedemptionPopUpSize() -> Double {
        let bounds = UIScreen.main.bounds
        
        if (bounds.height > 700) {
            return 0.5
        }else{
            return 0.65
        }
    }
    
    
    
    func getDetailedSectionSize() -> Double {
        let bounds = UIScreen.main.bounds
        
        if (bounds.height > 700) {
            return 0.3
        }else{
            return 0.33
        }
    }
    
    func getCategorySectionSize() -> Double{
        let bounds = UIScreen.main.bounds
        
        if (bounds.height > 700) {
            return 0.18
        }else{
            return 0.21
        }
    }
    
    func getBrandsSectionSize() -> Double {
        
        let bounds = UIScreen.main.bounds
        
        if (bounds.height > 700) {
            return 0.35
        }else{
            return 0.4
        }
        
    }
    
    
    
    
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }

        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}


extension UIScreen {

    enum SizeType: CGFloat {
        case Unknown = 0.0
        case se = 1334.0
        case normal = 1920.0
    }

    var sizeType: SizeType {
        let height = nativeBounds.height
        guard let sizeType = SizeType(rawValue: height) else { return .Unknown }
        return sizeType
    }
}
