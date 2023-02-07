//
//  TvMazeShowListViewController.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class TvMazeShowListViewController: TvMazeBaseViewController<TvMazeShowListViewModel> {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenLayout()
        setupTableViewCells()
        setupViewModel()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewDidLoad.accept(())
    }
    
    private func setupScreenLayout() {
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupViewModel() {
        let router = ShowsRouter(navigationController: navigationController ?? UINavigationController())
        viewModel = TvMazeShowListViewModel(router: router,
                                            service: TvMazeShowService())
        
    }
    
    override func bindInputs() {
        super.bindInputs()
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
