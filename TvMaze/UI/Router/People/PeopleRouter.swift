//
//  PeopleRouter.swift
//  TvMaze
//
//  Created by Douglas Immig on 08/02/23.
//

import UIKit

protocol PeopleRouterProtocol {
    func goToPersonDetail(person: Person,
                          service: TvMazeServiceProtocol)
    var showsRouter: ShowsRouterProtocol { get set }
}

class PeopleRouter: PeopleRouterProtocol {
    private let navigationController: UINavigationController,
                peopleStoryboard = UIStoryboard(name: "People", bundle: nil)
    
    var showsRouter: ShowsRouterProtocol
    
    init(navigationController: UINavigationController,
         showsRouter: ShowsRouter) {
        self.navigationController = navigationController
        self.showsRouter = showsRouter
    }
    
    func goToPersonDetail(person: Person,
                          service: TvMazeServiceProtocol) {
        guard let vc = peopleStoryboard.instantiateViewController(withIdentifier: "personDetailVc") as? PersonDetailViewController else { return }
        vc.viewModel = PersonDetailViewModel(router: self,
                                             person: person,
                                             service: service)
        navigationController.pushViewController(vc, animated: true)
    }
}
