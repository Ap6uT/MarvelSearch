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
    
    private let bag = DisposeBag()
    
    var viewModel: SearchViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        //tableView.rx.setDelegate(self).disposed(by: bag)
        bindViewModel()
    }
    
    

    func bindViewModel() {
        

        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        viewModel.characters.bind(to: tableView.rx.items(cellIdentifier: "CharacterCell", cellType: CharacterTableViewCell.self)) { (row,item,cell) in
            cell.configure(with: item)
        }.disposed(by: bag)

    }
    
    

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.searchCharacter(searchBar.text!)
    }
}
