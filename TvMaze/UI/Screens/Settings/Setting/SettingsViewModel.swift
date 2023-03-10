//
//  SettingsViewModel.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import Security
import RxSwift
import RxCocoa

final class SettingsViewModel: TvMazeBaseViewModel<SettingsRouterProtocol> {
    private let secureStore: SecureStore
    lazy var onSwitchTouched = PublishRelay<Bool>()
    
    init(router: SettingsRouterProtocol,
         secureStore: SecureStore) {
        self.secureStore = secureStore
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnSwitchTouched()
    }
    
    //MARK: Inputs
    private func setupOnSwitchTouched() {
        onSwitchTouched
            .subscribe(onNext: { [weak self] isActiving in
                guard let self = self else { return }
                isActiving ?
                self.router.goToPinCodeViewController(isCreatingPinCode: true) :
                self.removePincode()
            })
            .disposed(by: disposeBag)
    }
    
    func userHasPincode() -> Bool {
        do {
            let pincode = try secureStore.getValue(for: SecureDataType.pinPassword)
            return pincode != nil
        } catch (let error) {
            print(error)
            return false
        }
    }
    
    private func removePincode() {
        do {
            try secureStore.removeAllValues()
        } catch (let error) {
            print(error)
        }
    }
}
