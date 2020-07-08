//
//  SearchViewModel.swift
//  MarvelSearch
//
//  Created by Alexander Grishin on 08.07.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Action


struct SearchViewModel {
    
    let sceneCoordinator: SceneCoordinatorType
    let characterService: CharacterServiceType
    
    let disposeBag = DisposeBag()
    
    
    init(characterService: CharacterServiceType, coordinator: SceneCoordinatorType) {
        self.characterService = characterService
        self.sceneCoordinator = coordinator
    }
}
