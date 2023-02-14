//
//  TvMazeBaseService.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import RxSwift
import RxCocoa
import SwiftyJSON

enum ServiceErrors: Error {
    case notFound
    case defaultError
    
    init(statusCode: Int) {
        switch statusCode {
        case 404:
            self = .notFound
        default:
            self = .defaultError
        }
    }
}

class TvMazeBaseService {
    private let decoder: JSONDecoder
    private var task: URLSessionTask?
    
    private var API_URL: String {
        get {
            return "http://api.tvmaze.com/"
        }
    }
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    func requestData(_ request: ServiceRequest) -> Observable<Data> {
        weak var wSelf = self
        guard let url = URL(string: url(for: request)) else {
            return Observable<Data>.error(ServiceErrors.notFound)
        }
        
        return Observable<Data>.create { observable in
            guard let wSelf = wSelf else { return Disposables.create() }
            wSelf.task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    observable.onError(ServiceErrors.notFound)
                }
                
                if let data = data {
                    observable.onNext(data)
                }
                observable.onCompleted()
            }
            self.task?.resume()
            return Disposables.create{}
        }
    }
    
    func request<Response: Decodable>(_ endpoint: ServiceRequest,
                                      responseType: Response.Type) -> Observable<Response> {
        requestData(endpoint)
            .decode(type: responseType, decoder: decoder)
    }
    
    private func url(for request: ServiceRequest) -> String {
        API_URL + request.endpoint
    }
}

