//
//  Coordinator.swift
//  CombineTest
//
//  Created by Zakaria Bounouar on 2020-08-12.
//  Copyright © 2020 Zakaria Bounouar. All rights reserved.
//

import UIKit
import Combine

class Coordinator: ObservableSubjectManager {
    var editTabNavigationController: UINavigationController = UINavigationController()
    var viewTabNavigationController: UINavigationController = UINavigationController()
    var tabBar: UITabBarController = UITabBarController()
    
    var subject: PassthroughSubject<CountModel, Error> = PassthroughSubject<CountModel, Error>()
    var publisher: AnyPublisher<CountModel, Error> {
        // Here we're "erasing" the information of which type
        // that our subject actually is, only letting our outside
        // code know that it's a read-only publisher:
        subject.eraseToAnyPublisher()
    }
    
    var countModel: CountModel {
        didSet {
            subject.send(countModel)
        }
    }
    
    var initialViewController: UIViewController {
        return tabBar
    }
    
    init() {
        let model = CountModel(count: 0, color: .blue)
        self.countModel = model
    }
    
    func start() {
        let editViewController = TestViewController(countModel: countModel,
                                                    enableActions: true,
                                                    navigationEnabled: false,
                                                    delegate: self)
        let viewViewController = TestViewController(countModel: countModel,
                                                    enableActions: false,
                                                    navigationEnabled: false,
                                                    delegate: self)
        setupObserver(editViewController)
        setupObserver(viewViewController)
        editTabNavigationController.viewControllers = [editViewController]
        viewTabNavigationController.viewControllers = [viewViewController]
        
        configureTabBarItem(for: editTabNavigationController, title: "Edit")
        configureTabBarItem(for: viewTabNavigationController, title: "View")
        
        tabBar.viewControllers = [editTabNavigationController, viewTabNavigationController]
        tabBar.selectedViewController = editTabNavigationController
        tabBar.tabBar.backgroundColor = .white
    }
    
    func configureTabBarItem(for viewController: UIViewController, title: String) {
        let homeItem = UITabBarItem(title: title,
                                    image: nil,
                                    selectedImage: nil)
        viewController.tabBarItem = homeItem
    }
    
}

extension Coordinator: TestViewControllerDelegate {
    func changeColor(to color: UIColor) {
        countModel.color = color
    }
    
    func increaseCount() {
        countModel.count += 1
    }
    
    func decreaseCount() {
        countModel.count -= 1
    }
}
