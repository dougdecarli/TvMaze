//
//  PeopleTableViewCell.swift
//  TvMaze
//
//  Created by Douglas Immig on 08/02/23.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var peopleImageView: UIImageView!
    
    static let identifier = "PeopleTableViewCell",
               nibName: String = "PeopleTableViewCell"
    
    func bind(person: Person) {
        peopleImageView.loadImage(imageURL: person.image?.medium ?? "", genericImage: UIImage())
        nameLabel.text = person.name
    }
}
