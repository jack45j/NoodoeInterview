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
    private let store: LocalUserInfoStore
    
    private var instructor: LaunchInstructor {
        return LaunchInstructor.configure()
    }
    
    init(coordinatorFactory: CoordinatorFactory, factory: ModuleFactory, router: Router, store: LocalUserInfoStore) {
        self.coordinatorFactory = coordinatorFactory
        self.factory = factory
        self.router = router
        self.store = store
    }
    
    override func start() {
        switch instructor {
        case .main: runMainFlow()
        }
    }
    
    private func runMainFlow() {
        let user = try? store.retrieve().get()
        let mainViewModule = factory.makeMainModule(store: store)
        mainViewModule.onLoginShouldStart = { [unowned self] in
            let loginModule = factory.makeLoginModule(store: store)
            loginModule.onFinish = { [unowned self, weak mainViewModule] user in
                if let user = user {
                    mainViewModule?.userDataDidChange(user: user)
                }
                self.router.dismissModule()
            }
            router.present(loginModule)
        }
        
        router.setRootModule(mainViewModule, hideBar: true)
        mainViewModule.loadViewIfNeeded()
        mainViewModule.userDataDidChange(user: user)
    }
}
