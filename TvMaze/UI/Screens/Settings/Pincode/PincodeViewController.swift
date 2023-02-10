//
//  PincodeViewController.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import UIKit

final class PincodeViewController: TvMazeBaseViewController<PincodeViewModel> {
    @IBOutlet weak var pinCodeTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        isModalInPresentation = !viewModel.isCreatingPinCode
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        continueButton
            .rx.tap
            .bind(to: viewModel.onContinueButtonTouched)
            .disposed(by: disposeBag)
        
        viewModel.dismissViewController
            .subscribe(onNext: { [weak self] in
                self?.dismissVC()
            })
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        pinCodeTextField.rx.text.orEmpty
            .startWith("")
            .bind(to: viewModel.pinCodeTextFieldString)
            .disposed(by: disposeBag)
    }
    
    private func dismissVC() {
        dismiss(animated: true)
    }
}
