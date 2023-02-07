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
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private lazy var viewSpinner: UIView = {
        let view = UIView(frame: CGRect(
                            x: 0,
                            y: 0,
                            width: view.frame.size.width,
                            height: 100)
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenLayout()
        setupTableViewCells()
        setupViewModel()
        bind()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
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
        
        viewModel.isLoadingSpinnerAvaliable.subscribe { [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                  let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.tableFooterView = isAvaliable ? self.viewSpinner : UIView(frame: .zero)
            }
        }
        .disposed(by: disposeBag)

        viewModel.refreshControlCompleted.subscribe { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
        .disposed(by: disposeBag)
        
        tableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.tableView.contentOffset.y
            let contentHeight = self.tableView.contentSize.height
            
            if offSetY > (contentHeight - self.tableView.frame.size.height - 186) {
                self.viewModel.tableViewDidScrollToBottom.onNext(())
            }
        }
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
    
    @objc private func refreshControlTriggered() {
        viewModel.tableViewDidRefreshed.onNext(())
    }
    
    private func setupTableViewCells() {
        tableView.register(UINib(nibName: ShowListTableViewCell.nibName,
                                 bundle: .main),
                           forCellReuseIdentifier: ShowListTableViewCell.identifier)
    }
}
