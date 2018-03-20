//
//  Bundle+Ext.swift
//  ContentViewerSwift
//
//  Created by Yura Granchenko on 7/26/17.
//  Copyright © 2017 Adviscent. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {
    
    func plist(name: String) -> URL? {
        return url(forResource: name, withExtension: "plist")
    }
    
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
    
    var buildVersion: String? {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    var buildNumber: String? {
        return object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
}

extension Dictionary {
    
    static func plist(name: String) -> Dictionary? {
        guard let path = Bundle.main.plist(name: name), let data = try? Data(contentsOf: path),
            let hashTable = try? PropertyListSerialization.propertyList(from: data,
                                                                        options: [],
                                                                        format: nil) as? [Key: Value]
            else { return nil }
        return hashTable
    }
}

extension UIFont {
    class func iDic(_ size: CGFloat) -> UIFont! {
        return UIFont(name: "idic", size: size)
    }
}
