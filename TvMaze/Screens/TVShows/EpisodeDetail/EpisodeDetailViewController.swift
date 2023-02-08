//
//  EpisodeDetailViewController.swift
//  TvMaze
//
//  Created by Douglas Immig on 07/02/23.
//

import UIKit
import RxCocoa
import RxSwift

class EpisodeDetailViewController: TvMazeBaseViewController<EpisodeDetailViewModel> {
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var seasonAndEpisodeNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func bindInputs() {
        super.bindInputs()
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        episodeImageView.loadImage(imageURL: viewModel.episode.image?.original ?? "", genericImage: UIImage())
        summaryLabel.text = viewModel.episode.summary?.htmlDecoded
        episodeNameLabel.text = viewModel.episode.name
        seasonAndEpisodeNumberLabel.text = "S0\(viewModel.episode.season) | E0\(viewModel.episode.number)"
    }
}
