//
//  CharacterTableViewCell.swift
//  MarvelSearch
//
//  Created by Alexander Grishin on 12.07.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit
import RxSwift


class CharacterTableViewCell: UITableViewCell {

    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    
    func configure(with character: ResponseResult) {
        characterNameLabel.text = character.name
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }

}
