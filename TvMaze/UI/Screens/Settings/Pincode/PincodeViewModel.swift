//
//  PincodeViewModel.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import RxSwift
import RxCocoa
import LocalAuthentication

final class PincodeViewModel: TvMazeBaseViewModel<SettingsRouterProtocol> {
    private let secureStore: SecureStore
    let isCreatingPinCode: Bool,
        onContinueButtonTouched = PublishRelay<Void>(),
        pinCodeTextFieldString = PublishRelay<String>(),
        dismissViewController = PublishRelay<Void>(),
        emitError = BehaviorRelay<Bool>(value: false),
        onBiometryAuthButtonTouched = PublishRelay<Void>()
    
    var isButtonEnabled: Driver<Bool> {
        setupIsButtonEnabled()
    }
    
    init(router: SettingsRouterProtocol,
         secureStore: SecureStore,
         isCreatingPinCode: Bool) {
        self.secureStore = secureStore
        self.isCreatingPinCode = isCreatingPinCode
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnContinueButtonTouched()
        setupOnBiometryAuthButtonTouched()
    }
    
    //MARK: Inputs
    private func setupOnContinueButtonTouched() {
        onContinueButtonTouched
            .withLatestFrom(pinCodeTextFieldString)
            .subscribe(onNext: { [weak self] pin in
                guard let self = self else { return }
                self.isCreatingPinCode ?
                self.savePin(pin: pin) :
                self.authenticatePin(pin: pin)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupOnBiometryAuthButtonTouched() {
        onBiometryAuthButtonTouched
            .subscribe(onNext: { [weak self] in
                self?.authenticateWithBiometrics()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Outputs
    private func setupIsButtonEnabled() -> Driver<Bool> {
        pinCodeTextFieldString
            .startWith("")
            .map { $0.count == 4 }
            .asDriver(onErrorJustReturn: false)
    }
    
    //MARK: Helper methods
    private func savePin(pin: String) {
        do {
            try secureStore.setValue(pin, for: SecureDataType.pinPassword)
            dismissViewController.accept(())
        } catch {
            setErrorMessage()
        }
    }
    
    private func authenticatePin(pin: String) {
        do {
            let pincode = try secureStore.getValue(for: SecureDataType.pinPassword)
            pincode != nil && pincode == pin ?
            dismissViewController.accept(()) :
            setErrorMessage()
        } catch {
            setErrorMessage()
        }
    }
    
    private func setErrorMessage() {
        emitError.accept(true)
    }
    
    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with Touch ID / Face ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                if success {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.dismissViewController.accept(())
                    }
                    UserDefaults.standard.set(true, forKey: "biometric")
                } else {
                    UserDefaults.standard.set(false, forKey: "biometric")
                }
            }
        } else {
            UserDefaults.standard.set(false, forKey: "biometric")
        }
    }
}
