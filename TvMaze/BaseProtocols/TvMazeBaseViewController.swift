//
//  TvMazeBaseViewController.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import RxCocoa
import RxSwift
import UIKit

class TvMazeBaseViewController<ViewModel: TvMazeViewModelProtocol>: UIViewController {
    let disposeBag = DisposeBag()
    var viewModel: ViewModel!
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.color = .gray
        $0.style = .large
        return $0
    }(UIActivityIndicatorView())
    
    open func bindInputs() {
        if let viewModel = viewModel as? TvMazeLoadableViewModel {
            viewModel.isLoaderShowing.asObservable()
                .subscribe(onNext: toggleLoaderState)
                .disposed(by: disposeBag)
        }
    }
    
    open func bindOutputs() {}
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addLoaderToSubview()
        viewModel.setupBindings()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.cleanBindings()
    }
    
    private func addLoaderToSubview() {
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    internal func toggleLoaderState(_ showLoader: Bool) {
        toggleIsUserInteractionEnabled(showLoader)
        
        showLoader ?
        activityIndicatorView.startAnimating() :
        activityIndicatorView.stopAnimating()
    }
    
    private func toggleIsUserInteractionEnabled(_ showLoader: Bool) {
        view.isUserInteractionEnabled = !showLoader
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}
