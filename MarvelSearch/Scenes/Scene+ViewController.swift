//
//  Scenes.swift
//  MarvelSearch
//
//  Created by Alexander Grishin on 08.07.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit


extension Scene {
  func viewController() -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    switch self {
      case .search(let viewModel):
        let nc = storyboard.instantiateViewController(withIdentifier: "Search") as! UINavigationController
        var vc = nc.viewControllers.first as! SearchViewController
        vc.bindViewModel(to: viewModel)
        return nc
      case .characterDetail(let viewModel):
        let nc = storyboard.instantiateViewController(withIdentifier: "CharacterDetail") as! UINavigationController
        var vc = nc.viewControllers.first as! CharacterDetailViewController
        vc.bindViewModel(to: viewModel)
        return nc
    }

  }
}
