//
//  PersonDetailViewModel.swift
//  TvMaze
//
//  Created by Douglas Immig on 08/02/23.
//

import Foundation
import RxSwift
import RxCocoa

class PersonDetailViewModel: TvMazeBaseViewModel<PeopleRouterProtocol> {
    //MARK: Properties
    private let service: TvMazeServiceProtocol
    
    let person: Person
    
    var tvShowCells: Observable<[ShowModel]> {
        setupShowsCells()
    }
    
    init(router: PeopleRouterProtocol,
         person: Person,
         service: TvMazeServiceProtocol) {
        self.person = person
        self.service = service
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
    }
    
    //MARK: Outputs
    private func setupShowsCells() -> Observable<[ShowModel]> {
        service
            .getShowsByPerson(personId: person.id)
    }
}
