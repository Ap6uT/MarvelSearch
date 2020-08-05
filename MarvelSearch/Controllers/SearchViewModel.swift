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
import RxCocoa


class SearchViewModel {
    
    let sceneCoordinator: SceneCoordinatorType
    let characterService: CharacterServiceType
    
    let disposeBag = DisposeBag()
    let search = Search.shared
    
    let account: String = "hey"
    let characters = BehaviorRelay<[ResponseResult]>(value: [])
    var characters2: [ResponseResult] = []
    
    init(characterService: CharacterServiceType, coordinator: SceneCoordinatorType) {
        self.characterService = characterService
        self.sceneCoordinator = coordinator
    }
    
    func searchCharacter(_ character: String) {
        
        search.searchCharacterByName(character)
        //print(ch)
        //characters = ch
        //ch.asObservable()
           // .bind(to: characters)
        search.characters.asObservable()
            .subscribe(onNext: { ch in
                //print(ch)
                self.characters.accept(ch)
            })
            .disposed(by: disposeBag)
        
        //print(characters.value)
        
    }
}

