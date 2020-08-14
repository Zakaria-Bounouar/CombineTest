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
    
    func update(forStatus status: ObservableCountStatus)
}

protocol ObservableSubjectManager: class {
    var subject: PassthroughSubject<ObservableCountStatus, Never> { get }
    var publisher: AnyPublisher<ObservableCountStatus, Never> { get }
    
    func setupObserver(_ observer: Observer)
}

extension ObservableSubjectManager {
    func setupObserver(_ observer: Observer) {
        observer.cancellable = self.publisher.sink(receiveValue: { subjectStatus in
            observer.update(forStatus: subjectStatus)
        })
    }
}
