//
//  CharacterType.swift
//  MarvelSearch
//
//  Created by Alexander Grishin on 08.07.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm


struct CharacterService: CharacterServiceType {

  init() {
    // create a few default tasks
    /*do {
      let realm = try Realm()
      if realm.objects(TaskItem.self).count == 0 {
        ["Chapter 5: Filtering operators",
         "Chapter 4: Observables and Subjects in practice",
         "Chapter 3: Subjects",
         "Chapter 2: Observables",
         "Chapter 1: Hello, RxSwift"].forEach {
          self.createTask(title: $0)
        }
      }
    } catch _ {
    }*/
  }

  private func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
    do {
      let realm = try Realm()
      return try action(realm)
    } catch let err {
      print("Failed \(operation) realm with error: \(err)")
      return nil
    }
  }

  @discardableResult
  func createCharacter(title: String) -> Observable<CharacterItem> {
    let result = withRealm("creating") { realm -> Observable<CharacterItem> in
      let character = CharacterItem()
      character.title = title
      try realm.write {
        character.uid = (realm.objects(CharacterItem.self).max(ofProperty: "uid") ?? 0) + 1
        realm.add(character)
      }
      return .just(character)
    }
    return result ?? .error(CharacterServiceError.creationFailed)
  }

  @discardableResult
  func delete(character: CharacterItem) -> Observable<Void> {
    let result = withRealm("deleting") { realm-> Observable<Void> in
      try realm.write {
        realm.delete(character)
      }
      return .empty()
    }
    return result ?? .error(CharacterServiceError.deletionFailed(character))
  }

  @discardableResult
  func update(character: CharacterItem, title: String) -> Observable<CharacterItem> {
    let result = withRealm("updating") { realm -> Observable<CharacterItem> in
      try realm.write {
        character.title = title
      }
      return .just(character)
    }
    return result ?? .error(CharacterServiceError.updateFailed(character))
  }

  func characters() -> Observable<Results<CharacterItem>> {
    let result = withRealm("getting characters") { realm -> Observable<Results<CharacterItem>> in
      let realm = try Realm()
      let characters = realm.objects(CharacterItem.self)
      return Observable.collection(from: characters)
    }
    return result ?? .empty()
  }
}

