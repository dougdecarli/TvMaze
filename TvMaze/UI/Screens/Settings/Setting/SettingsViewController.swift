//
//  SettingsViewController.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: TvMazeBaseViewController<SettingsViewModel> {
    @IBOutlet weak var pinCodeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        pinCodeSwitch.rx.isOn.changed
            .bind(to: viewModel.onSwitchTouched)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
    }
}
