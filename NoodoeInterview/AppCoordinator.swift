//
//  AppCoordinator.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/3.
//

import UIKit

private enum LaunchInstructor {
    case main
    
    static func configure() -> LaunchInstructor {
        return .main
    }
}

final class ApplicationCoordinator: BaseCoordinator {
    
    private let coordinatorFactory: CoordinatorFactory
    private let factory: ModuleFactory
    private let router: Router
    
    private var instructor: LaunchInstructor {
        return LaunchInstructor.configure()
    }
    
    init(coordinatorFactory: CoordinatorFactory, factory: ModuleFactory, router: Router) {
        self.coordinatorFactory = coordinatorFactory
        self.factory = factory
        self.router = router
    }
    
    override func start() {
        switch instructor {
        case .main: runMainFlow()
        }
    }
    
    private func runMainFlow() {
        let mainViewController = factory.makeMainModule()
        mainViewController.onLoginBtnDidTouch = { [unowned self] in
            let loginModule = factory.makeLoginModule()
            loginModule.onFinish = { [unowned self] userInfo in
                self.router.dismissModule()
            }
            router.present(loginModule)
        }
        
        router.setRootModule(mainViewController, hideBar: true)
    }
}
