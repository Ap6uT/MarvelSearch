//
//  SearchViewController.swift
//  MarvelSearch
//
//  Created by Alexander Grishin on 08.07.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import RxDataSources


class SearchViewController: UIViewController, BindableType {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let search = Search()
        search.printURL()
        print("aaa")
    }
    

    func bindViewModel() {
        
    }

}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell") as! CharacterTableViewCell
        cell.configure(with: viewModel.characters.value[indexPath.row])
        return cell
    }
}
