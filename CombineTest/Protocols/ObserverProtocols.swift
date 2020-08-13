//
//  ObserverProtocols.swift
//  CombineTest
//
//  Created by Zakaria Bounouar on 2020-08-13.
//  Copyright © 2020 Zakaria Bounouar. All rights reserved.
//

import UIKit
import Combine

// This is just an example of what we could do with Combine. In practice we could make these
// protocols generic to be able to work with any model type, not only CountModel.

protocol Observer: class {
    var cancellable: AnyCancellable? { get set }
    
    func update(forResult result: Result<CountModel, Error>)
}

protocol Observant: class {
    var subject: PassthroughSubject<CountModel, Error> { get }
    var publisher: AnyPublisher<CountModel, Error> { get }
    
    func setupObserver(_ observer: Observer)
}

extension Observant {
    func setupObserver(_ observer: Observer) {
        observer.cancellable = self.publisher.sink(receiveCompletion: { (subscriberCompletion) in
            switch subscriberCompletion {
            case .failure(let error):
                observer.update(forResult: .failure(error))
            case .finished:
                // Not sure what to do here
                break
            }
        }, receiveValue: { countModel in
            observer.update(forResult: .success(countModel))
        })
    }
}
