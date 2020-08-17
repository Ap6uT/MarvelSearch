//
//  Navigator.swift
//  MarvelSearch
//
//  Created by Alexander Grishin on 12.08.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit
import RxCocoa


class Navigator {
  lazy private var defaultStoryboard = UIStoryboard(name: "Main", bundle: nil)

  // MARK: - segues list
  enum Segue {
    case search
    case characterDetail(ResponseResult)
  }

  // MARK: - invoke a single segue
  func show(segue: Segue, sender: UIViewController) {
    switch segue {
        case .search:
            let vm = SearchViewModel()
            show(target: SearchViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard, viewModel: vm), sender: sender)
        case .characterDetail(let character):
            let vm = CharacterDetailViewModel(character: character)
            show(target: CharacterDetailViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard, viewModel: vm), sender: sender)
    }
  }

  private func show(target: UIViewController, sender: UIViewController) {
    if let nav = sender as? UINavigationController {
      nav.pushViewController(target, animated: false)
      return
    }

    if let nav = sender.navigationController {
      nav.pushViewController(target, animated: true)
    } else {
      sender.present(target, animated: true, completion: nil)
    }
  }
}

