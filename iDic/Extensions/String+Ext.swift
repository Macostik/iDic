//
//  String+Ext.swift
//  BinarySwipe
//
//  Created by Macostik on 5/23/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import Foundation
import UIKit

func GUID() -> String {
    return UUID().uuidString
}

extension Hashable {
    func toString() -> String {
        return "\(self)"
    }
}

func << (count: Int, value: String) -> String {
    let format = "%.\(count)f"
    let s = value.replacingOccurrences(of: ",", with: ".")
    let d = Double(s) ?? 0.0
    return String(format: format, d)
}

extension String {
    
    var URL: Foundation.URL? {
        return Foundation.URL(string: self as String)
    }
    var fileURL: Foundation.URL? {
        return Foundation.URL(fileURLWithPath: self as String)
    }
    var smartURL: Foundation.URL? {
        if isExistingFilePath {
            return fileURL
        } else {
            return URL
        }
    }
    var isExistingFilePath: Bool {
        if hasPrefix("http") {
            return false
        }
        return FileManager.default.fileExists(atPath: self as String)
    }
    
    var trim: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    fileprivate static let emailRegex = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&" +
    "'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|" +
    "\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9]" +
    "(?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4]" +
    "[0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-" +
    "\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    var isValidEmail: Bool {
        guard let predicate = try? NSRegularExpression(pattern: String.emailRegex,
                                                       options:[]) else { return false }
        return predicate.firstMatch(in: self,
                                    options: [],
                                    range: NSMakeRange(0, count - 1)) != nil
    }
    
    var isValidPhone: Bool {
        let phoneNumber = NSTextCheckingResult.CheckingType.phoneNumber.rawValue
        guard let detector = try? NSDataDetector(types: phoneNumber) else { return false }
        
        if let match = detector.matches(in: self as String,
                                        options: [],
                                        range: NSMakeRange(0, (self as String).count)).first?.phoneNumber {
            return match == self as String
        } else {
            return false
        }
    }
    
    var URLQuery: [String:String] {
        
        var parameters = [String:String]()
        for pair in components(separatedBy: "&") {
            let components = pair.components(separatedBy: "=")
            if components.count == 2 {
                parameters[components[0]] = components[1].removingPercentEncoding
            } else {
                continue
            }
        }
        
        return parameters
    }
    
    func clearPhoneNumber() -> String {
        var phone = ""
        for character in (self as String) {
            if character == "+" || "0"..."9" ~= character {
                phone.append(character)
            }
        }
        return phone
    }
    
    var ls: String {
        let string = self as String
        return Bundle.main.localizedString(forKey: string, value: string, table: nil)
    }
    
    func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var result = ""
        
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            let characterIndex = index(startIndex, offsetBy: randomIndex)
            result += String(characters[characterIndex])
        }
        
        return result
    }

    func toDouble() -> Double {
        return Double.init(self as String) ?? Double.infinity
    }
    
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    func subString(_ from: Int, offset: String.IndexDistance) -> String {
        return String(self[startIndex ..< index(startIndex, offsetBy: offset)])
    }
    
    func heightWithFont(_ font: UIFont, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let height = self.boundingRect(with: size,
                                       options: .usesLineFragmentOrigin,
                                       attributes: [.font : font],
                                       context: nil).height
        return ceil(height)
    }
}
