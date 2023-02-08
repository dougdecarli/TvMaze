//
//  TvShowDetailViewController.swift
//  TvMaze
//
//  Created by Douglas Immig on 07/02/23.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class TvShowDetailViewController: TvMazeBaseViewController<TvShowDetailViewModel> {
    @IBOutlet weak var episodesTableView: UITableView!
    
    private lazy var dataSource = DataSource(configureCell: { [weak self] (dataSource, table, indexPath, item) in
        guard let self = self else { return UITableViewCell() }
        let item = dataSource[indexPath]
        let cell = item.cellIn(tableView: table, at: indexPath)
        return cell
    }, titleForHeaderInSection: { dataSource, indexPath in
        return dataSource[indexPath].model
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        registerCells()
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        rx.viewWillAppear
            .map { _ in }
            .bind(to: viewModel.onViewWillAppear)
            .disposed(by: disposeBag)
        
        episodesTableView
            .rx
            .modelSelected(ShowDetailCellsDataSource.self)
            .bind(to: viewModel.onEpisodeSelected)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        viewModel
            .episodeSeasonCells
            .startWith([])
            .bind(to: episodesTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func registerCells() {
        episodesTableView.register(UINib(nibName: ShowDetailTableViewCell.nibName,
                                         bundle: .main),
                                   forCellReuseIdentifier: ShowDetailTableViewCell.identifier)
        episodesTableView.register(UINib(nibName: ShowDetailHeaderTableViewCell.nibName,
                                         bundle: .main),
                                   forCellReuseIdentifier: ShowDetailHeaderTableViewCell.identifier)
    }
}
