//
//  CharacterService.swift
//  MarvelSearch
//
//  Created by Alexander Grishin on 08.07.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift


enum CharacterServiceError: Error {
  case creationFailed
  case updateFailed(CharacterItem)
  case deletionFailed(CharacterItem)
}

protocol CharacterServiceType {
  @discardableResult
  func createCharacter(title: String) -> Observable<CharacterItem>
  
  @discardableResult
  func delete(character: CharacterItem) -> Observable<Void>
  
  @discardableResult
  func update(character: CharacterItem, title: String) -> Observable<CharacterItem>
  
  func characters() -> Observable<Results<CharacterItem>>
  
}
