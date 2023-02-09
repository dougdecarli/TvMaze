//
//  PeopleListViewModel.swift
//  TvMaze
//
//  Created by Douglas Immig on 08/02/23.
//

import Foundation
import RxSwift
import RxCocoa

class PeopleListViewModel: TvMazeBaseViewModel<PeopleRouterProtocol> {
    //MARK: Properties
    private let service: TvMazePeopleServiceProtocol
    
    let searchBarTextField = BehaviorRelay(value: ""),
        onPersonSelected = PublishRelay<Person>()
    
    var peopleCells: Observable<[Person]> {
        setupPeopleCells(searchBarTextField.asObservable())
    }
    
    init(router: PeopleRouterProtocol,
         service: TvMazePeopleServiceProtocol) {
        self.service = service
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnPersonSelected()
    }
    
    //MARK: Input
    private func setupOnPersonSelected() {
        onPersonSelected
            .subscribe(onNext: { [weak self] person in
                guard let self = self else { return }
                self.router.goToPersonDetail(person: person,
                                             service: self.service)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Output
    private func setupPeopleCells(_ textFieldString: Observable<String>) -> Observable<[Person]> {
        let searching = textFieldString
            .filter { $0.count > 0 }
            .flatMapLatest(service.getPeople(by:))
        
        let notSearching = textFieldString
            .filter { $0.count == 0 }
            .map { _ in [Person]() }
        
        return Observable.merge(searching, notSearching)
    }
}
