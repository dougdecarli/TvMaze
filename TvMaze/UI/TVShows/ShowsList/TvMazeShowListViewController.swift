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
    
    private let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium),
                emptyView = UIView()
    
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
                                            service: TvMazeService())
        
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        tableView
            .rx
            .modelSelected(ShowModel.self)
            .bind(to: viewModel.onTvShowSelected)
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchBarTextField)
            .disposed(by: disposeBag)
        
        viewModel.isFetchingData
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.isFetchingData
            .map { [weak self] isFetching -> UIView in
                guard let self = self else { return self!.emptyView }
                return isFetching ? self.activityIndicator : self.emptyView
            }
            .bind(to: tableView.rx.tableFooterView)
            .disposed(by: disposeBag)
        
        //MARK: Pagination
        tableView
            .rx.willDisplayCell
            .subscribe(onNext: { [weak self] (cell) in
                guard let self = self else { return }
                let offsetY = self.tableView.contentOffset.y
                let contentHeight = self.tableView.contentSize.height
                if offsetY > contentHeight - self.tableView.frame.height {
                    self.viewModel.tableViewDidScrollToBottom.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        viewModel.isTableViewHiddenDriver
            .drive(tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
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
