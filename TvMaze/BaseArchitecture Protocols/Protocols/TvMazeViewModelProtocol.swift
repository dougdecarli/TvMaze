//
//  TvMazeViewModelProtocol.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import RxCocoa
import RxSwift

protocol TvMazeViewModelProtocol {
    func setupBindings()
    func cleanBindings()
}
