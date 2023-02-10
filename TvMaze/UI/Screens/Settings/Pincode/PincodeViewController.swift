//
//  PincodeViewController.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import UIKit

final class PincodeViewController: TvMazeBaseViewController<PincodeViewModel> {
    @IBOutlet weak var pinCodeTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var biometryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        hideKeyboardWhenTappedAround()
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
        
        biometryButton
            .rx.tap
            .bind(to: viewModel.onBiometryAuthButtonTouched)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        pinCodeTextField.rx.text.orEmpty
            .startWith("")
            .bind(to: viewModel.pinCodeTextFieldString)
            .disposed(by: disposeBag)
        
        viewModel.isButtonEnabled
            .drive(continueButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel
            .emitError
            .map { !$0 }
            .bind(to: errorMessageLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func dismissVC() {
        self.dismiss(animated: true)
    }
}
