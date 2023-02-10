//
//  FavoritesViewController.swift
//  TvMaze
//
//  Created by Douglas Immig on 08/02/23.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoritesViewController: TvMazeBaseViewController<FavoritesViewModel> {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewCells()
        bind()
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        tableView
            .rx.modelSelected(ShowModel.self)
            .bind(to: viewModel.onFavoriteTouched)
            .disposed(by: disposeBag)
        
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
