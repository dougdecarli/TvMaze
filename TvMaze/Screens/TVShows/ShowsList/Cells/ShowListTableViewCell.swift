//
//  ShowListTableViewCell.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import UIKit

class ShowListTableViewCell: UITableViewCell {
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    static let identifier = "ShowListTableViewCell",
               nibName: String = "ShowListTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func bind(model: ShowModel) {
        genresLabel.text = model.genres.joined(separator: ", ")
        titleLabel.text = model.name
        posterImageView.loadImage(imageURL: model.image.medium, genericImage: UIImage())
    }
}
