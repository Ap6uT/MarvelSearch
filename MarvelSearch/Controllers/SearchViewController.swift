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
//import Then


class SearchViewController: UIViewController, BindableType {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let bag = DisposeBag()
    
    var viewModel: SearchViewModel!
    fileprivate var navigator: Navigator!

    static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: SearchViewModel) -> SearchViewController {
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        //tableView.rx.setDelegate(self).disposed(by: bag)
        bindViewModel()
    }
    
    

    func bindViewModel() {
        viewModel.search.searchCharacterById(1010727)
        

        //self.tableView.delegate = self
        self.tableView.dataSource = nil
        viewModel.search.characters
            .bind(to: tableView.rx.items(cellIdentifier: "CharacterCell", cellType: CharacterTableViewCell.self)) { (row,item,cell) in
                cell.configure(with: item)
            }
        .disposed(by: bag)
        
    }
    
    

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.search.searchCharacterByName(searchBar.text!)
    }
}


extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView.deselectRow(at: indexPath, animated: false)
    let character = self.viewModel.search.characters.value[indexPath.row]
    self.navigator.show(segue: .characterDetail(character), sender: self)
  }
}
