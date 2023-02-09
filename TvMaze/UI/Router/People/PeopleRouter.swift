//
//  PeopleRouter.swift
//  TvMaze
//
//  Created by Douglas Immig on 08/02/23.
//

import UIKit

protocol PeopleRouterProtocol {
    func goToPersonDetail(person: Person,
                          service: TvMazePeopleServiceProtocol)
}

class PeopleRouter: PeopleRouterProtocol {
    private let navigationController: UINavigationController,
                peopleStoryboard = UIStoryboard(name: "People", bundle: nil)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func goToPersonDetail(person: Person,
                          service: TvMazePeopleServiceProtocol) {
        guard let vc = peopleStoryboard.instantiateViewController(withIdentifier: "personDetailVc") as? PersonDetailViewController else { return }
        vc.viewModel = PersonDetailViewModel(router: self,
                                             person: person,
                                             service: service)
        navigationController.pushViewController(vc, animated: true)
    }
}
