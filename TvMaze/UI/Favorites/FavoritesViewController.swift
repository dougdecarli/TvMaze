//
//  FavoritesViewController.swift
//  TvMaze
//
//  Created by Douglas Immig on 08/02/23.
//

import UIKit
import RxSwift
import RxCocoa

class FavoritesViewController: TvMazeBaseViewController<FavoritesViewModel> {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewCells()
        setupViewModel()
        bind()
    }
    
    private func setupViewModel() {
        let router = FavoriteRouter(navigationController: navigationController ?? UINavigationController())
        viewModel = FavoritesViewModel(router: router)
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        rx.viewWillAppear
            .map { _ in }
            .bind(to: viewModel.onViewWillAppear)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        viewModel
            .tvShowCells
            .bind(to: tableView.rx.items(cellIdentifier: ShowListTableViewCell.identifier,
                                         cellType: ShowListTableViewCell.self)) { (row, element, cell) in
                cell.bind(model: element)
            }.disposed(by: disposeBag)
    }
    
    private func setupTableViewCells() {
        tableView.register(UINib(nibName: ShowListTableViewCell.nibName,
                                      bundle: .main),
                           forCellReuseIdentifier: ShowListTableViewCell.identifier)
    }
}
