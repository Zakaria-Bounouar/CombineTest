//
//  ObservableCountStatus.swift
//  CombineTest
//
//  Created by Zakaria Bounouar on 2020-08-14.
//  Copyright © 2020 Zakaria Bounouar. All rights reserved.
//

import Foundation

enum ObservableCountStatus {
    // This status let's the observer know that the model has finished loading
    case didLoad(CountModel)
    // This status let's the observer know that the model is loading
    case isLoading
    // This status is in case of errors
    case error(Error)
}
