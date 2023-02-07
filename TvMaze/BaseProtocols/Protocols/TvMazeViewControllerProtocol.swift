//
//  TvMazeViewControllerProtocol.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import Foundation

protocol TvMazeViewControllerProtocol {
    func bindInputs()
    func bindOutputs()
}

extension TvMazeViewControllerProtocol {
    func bind() {
        bindInputs()
        bindOutputs()
    }
}
