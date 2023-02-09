//
//  ShowDetailCellsDataSource.swift
//  TvMaze
//
//  Created by Douglas Immig on 07/02/23.
//

import UIKit
import RxDataSources

typealias ShowDetailsSectionModel = SectionModel<String, ShowDetailCellsDataSource>
typealias DataSource = RxTableViewSectionedReloadDataSource<ShowDetailsSectionModel>

enum ShowDetailCellsDataSource {
    case header(model: ShowModel)
    case episodes(model: Episode)
}

extension ShowDetailCellsDataSource {
    func cellIn(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch self {
        case .header(let model):
            if let cell = tableView.dequeueReusableCell(withIdentifier: ShowDetailHeaderTableViewCell.identifier) as? ShowDetailHeaderTableViewCell {
                cell.bind(model: model)
                return cell
            }
            return UITableViewCell()
            
        case .episodes(let episode):
            if let cell = tableView.dequeueReusableCell(withIdentifier: ShowDetailTableViewCell.identifier) as? ShowDetailTableViewCell {
                cell.bind(episode: episode)
                return cell
            }
            return UITableViewCell()
        }
    }
}
