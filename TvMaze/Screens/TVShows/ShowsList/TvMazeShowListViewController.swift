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
    
    private let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
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
        
        viewModel.isFetchingData.subscribe { [weak self] isFetchingData in
            DispatchQueue.main.async {
                self?.tableView.tableFooterView = isFetchingData ? self?.activityIndicator : UIView(frame: .zero)
            }
        }
        .disposed(by: disposeBag)
        
        //MARK: Pagination
        tableView
            .rx.willDisplayCell
            .subscribe(onNext: { [weak self] (cell) in
                guard let self = self else { return }
                let offsetY = self.tableView.contentOffset.y
                let contentHeight = self.tableView.contentSize.height
                if offsetY > contentHeight - self.tableView.frame.height {
                    print("BOTTOM")
                    self.viewModel.tableViewDidScrollToBottom.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.tvShowCells
            .map { $0.count == 0 }
            .bind(to: tableView.rx.isHidden)
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
