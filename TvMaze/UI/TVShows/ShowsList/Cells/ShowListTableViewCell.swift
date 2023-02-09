//
//  ShowListTableViewCell.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import Foundation
import RxSwift
import RxCocoa
class ShowListTableViewCell: UITableViewCell {
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var viewModel: ShowListTableViewCellViewModel?
    
    static let identifier = "ShowListTableViewCell",
               nibName: String = "ShowListTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func bind(model: ShowModel) {
        viewModel = ShowListTableViewCellViewModel(model: model)
        guard let viewModel = viewModel else { return }
        
        favoriteButton.rx.tap
            .bind(to: viewModel.onFavoriteButtonTouched)
            .disposed(by: rx.disposeBag)
        
        viewModel.isShowFavorited
            .debug("favorite")
            .map { $0 ? UIImage.init(systemName: "heart.fill") : UIImage.init(systemName: "heart") }
            .bind(to: favoriteButton.rx.image())
            .disposed(by: rx.disposeBag)
        
        genresLabel.text = model.genres.joined(separator: ", ")
        titleLabel.text = model.name
        posterImageView.loadImage(imageURL: model.image?.medium ?? "", genericImage: UIImage())
    }
}

import Foundation
import RxSwift
import RxCocoa

class ShowListTableViewCellViewModel {
    private let disposeBag = DisposeBag(),
                model: ShowModel,
                favoriteManager: FavoritesUserDefaultsManager
    let onFavoriteButtonTouched = PublishRelay<Void>(),
        isShowFavorited = BehaviorRelay<Bool>(value: false)
    
    init(model: ShowModel,
         favoriteManager: FavoritesUserDefaultsManager = FavoritesUserDefaultsManager.shared) {
        self.model = model
        self.favoriteManager = favoriteManager
        getIsFavorited()
        setupOnFavoriteButtonTouched()
    }
    
    private func setupOnFavoriteButtonTouched() {
        onFavoriteButtonTouched
            .subscribe(onNext: { [weak self] in
                self?.toggleFavoriteStatus()
            })
            .disposed(by: disposeBag)
    }
    
    private func toggleFavoriteStatus() {
        if favoriteManager.getFavorite(withId: model.id) != nil {
            favoriteManager.removeFavorite(withId: model.id)
            isShowFavorited.accept(false)
            return
        }
        favoriteManager.addFavorite(tvShow: model)
        isShowFavorited.accept(true)
    }
    
    private func getIsFavorited() {
        isShowFavorited.accept(favoriteManager.getFavorite(withId: model.id) != nil)
    }
}
