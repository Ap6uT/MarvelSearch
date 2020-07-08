//
//  SceneCoordinatorType.swift
//  MarvelSearch
//
//  Created by Alexander Grishin on 08.07.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit
import RxSwift


protocol SceneCoordinatorType {
  /// transition to another scene
  @discardableResult
  func transition(to scene: Scene, type: SceneTransitionType) -> Completable

  /// pop scene from navigation stack or dismiss current modal
  @discardableResult
  func pop(animated: Bool) -> Completable
}

extension SceneCoordinatorType {
  @discardableResult
  func pop() -> Completable {
    return pop(animated: true)
  }
}
