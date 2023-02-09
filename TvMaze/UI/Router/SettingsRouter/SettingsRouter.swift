//
//  SettingsRouter.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import UIKit

protocol SettingsRouterProtocol {
    func goToPinCodeViewController(isCreatingPinCode: Bool)
}

class SettingsRouter: SettingsRouterProtocol {
    private let navigationController: UINavigationController,
                settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil),
                secureStore: SecureStore
    
    init(navigationController: UINavigationController,
         secureStore: SecureStore) {
        self.navigationController = navigationController
        self.secureStore = secureStore
    }
    
    func goToPinCodeViewController(isCreatingPinCode: Bool) {
        guard let vc = settingsStoryboard.instantiateViewController(withIdentifier: "pincodeVC") as? PincodeViewController else { return }
        vc.viewModel = PincodeViewModel(router: self,
                                        secureStore: secureStore,
                                        isCreatingPinCode: isCreatingPinCode)
        navigationController.present(vc, animated: true)
    }
}
