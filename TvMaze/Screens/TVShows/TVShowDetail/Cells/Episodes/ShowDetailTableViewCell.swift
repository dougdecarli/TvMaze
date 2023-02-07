//
//  ShowDetailTableViewCell.swift
//  TvMaze
//
//  Created by Douglas Immig on 07/02/23.
//

import UIKit

final class ShowDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var episodeImageView: UIImageView!
    
    static let identifier = "ShowDetailTableViewCell",
               nibName: String = "ShowDetailTableViewCell"

    func bind(episode: Episode) {
        episodeImageView.loadImage(imageURL: episode.image?.original ?? "", genericImage: UIImage())
        episodeNameLabel.text = episode.name
    }
}
