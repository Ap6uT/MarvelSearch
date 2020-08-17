//
//  CharacterDetailViewController.swift
//  MarvelSearch
//
//  Created by Alexander Grishin on 08.07.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit
import RxSwift
import Action


class CharacterDetailViewController: UIViewController, BindableType {
    
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterInfo: UILabel!
    
    var viewModel: CharacterDetailViewModel!
    fileprivate var navigator: Navigator!

    static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: CharacterDetailViewModel) -> CharacterDetailViewController {
        let vc = storyboard.instantiateViewController(withIdentifier: "CharacterDetailViewController") as! CharacterDetailViewController
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let character = viewModel.character!
        
        characterInfo.text = character.description
        
        let imageURL = URL(string: character.thumbnail.path + "." + character.thumbnail.fileExtension)
        
        characterImage.kf.setImage(with: imageURL)
        
    }
    
    func bindViewModel() {
        
    }


}
