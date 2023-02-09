//
//  PersonDetailViewController.swift
//  TvMaze
//
//  Created by Douglas Immig on 08/02/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PersonDetailViewController: TvMazeBaseViewController<PersonDetailViewModel> {
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var showsTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var castCreditsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupTableViewCells()
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        showsTableView
            .rx.modelSelected(ShowModel.self)
            .bind(to: viewModel.onPersonTouched)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        personImageView.loadImage(imageURL: viewModel.person.image?.medium ?? "", genericImage: UIImage())
        nameLabel.text = viewModel.person.name
        
        viewModel.tvShowCells
            .filter { $0.count == 0 }
            .map { _ in "No cast credits" }
            .bind(to: castCreditsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .tvShowCells
            .bind(to: showsTableView.rx.items(cellIdentifier: ShowListTableViewCell.identifier,
                                         cellType: ShowListTableViewCell.self)) { (row, element, cell) in
                cell.bind(model: element)
            }.disposed(by: disposeBag)
    }
    
    private func setupTableViewCells() {
        showsTableView.register(UINib(nibName: ShowListTableViewCell.nibName,
                                 bundle: .main),
                           forCellReuseIdentifier: ShowListTableViewCell.identifier)
    }
}
