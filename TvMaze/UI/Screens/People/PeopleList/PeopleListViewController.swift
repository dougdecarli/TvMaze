//
//  PeopleListViewController.swift
//  TvMaze
//
//  Created by Douglas Immig on 08/02/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class PeopleListViewController: TvMazeBaseViewController<PeopleListViewModel> {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let emptyMessageLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 16)
        $0.text = "Search for people"
        return $0
    }(UILabel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupTableViewCells()
        bind()
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        tableView
            .rx.modelSelected(Person.self)
            .bind(to: viewModel.onPersonSelected)
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchBarTextField)
            .disposed(by: disposeBag)
        
        viewModel.peopleCells
            .map { $0.count == 0 }
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        viewModel
            .peopleCells
            .bind(to: tableView.rx.items(cellIdentifier: PeopleTableViewCell.identifier,
                                         cellType: PeopleTableViewCell.self)) { (row, element, cell) in
                cell.bind(person: element)
            }.disposed(by: disposeBag)
    }
    
    private func setupTableViewCells() {
        tableView.register(UINib(nibName: PeopleTableViewCell.nibName,
                                 bundle: .main),
                           forCellReuseIdentifier: PeopleTableViewCell.identifier)
    }
}
