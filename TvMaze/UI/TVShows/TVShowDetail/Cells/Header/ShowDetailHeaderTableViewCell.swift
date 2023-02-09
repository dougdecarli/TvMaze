//
//  ShowDetailHeaderTableViewCell.swift
//  TvMaze
//
//  Created by Douglas Immig on 07/02/23.
//

import UIKit

class ShowDetailHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tvShowName: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    static let identifier = "ShowDetailHeaderTableViewCell",
               nibName: String = "ShowDetailHeaderTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func bind(model: ShowModel) {
        posterImageView.loadImage(imageURL: model.image?.medium ?? "", genericImage: UIImage())
        genresLabel.text = model.genres.joined(separator: ", ")
        tvShowName.text = model.name
        scheduleLabel.text = "At \(model.schedule.time) on \(model.schedule.days.joined(separator: ", "))"
        summaryLabel.text = model.summary?.htmlDecoded
    }
}
