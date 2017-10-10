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
    dynamic var id: String = ""
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var photoUrl: String = ""
    dynamic var email: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
