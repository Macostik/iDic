//
//  User.swift
//  iDic
//
//  Created by Yura Granchenko on 10/10/17.
//  Copyright © 2017 Yura Granchenko. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var photoUrl: String = ""
    @objc dynamic var email: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
