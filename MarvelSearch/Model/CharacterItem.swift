//
//  CharacterItem.swift
//  MarvelSearch
//
//  Created by Alexander Grishin on 08.07.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources


class CharacterItem: Object {
    @objc dynamic var uid: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var added: Date = Date()
  
    override class func primaryKey() -> String? {
        return "uid"
    }
}

extension CharacterItem: IdentifiableType {
  var identity: Int {
    return self.isInvalidated ? 0 : uid
  }
}
