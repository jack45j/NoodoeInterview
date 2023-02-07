//
//  AppCoordinator.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/3.
//

import UIKit

private enum LaunchInstructor {
    case main(UserInfoItem?)
    
    static func configure() -> LaunchInstructor {
        if let userData = UserDefaults.standard.data(forKey: "Noodoe.UserInfoItem"),
           let user = UserInfoMapper.map(data: userData) {
            return .main(user)
        }
        return .main(nil)
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
        case let .main(user): runMainFlow(user: user)
        }
    }
    
    private func runMainFlow(user: UserInfoItem?) {
        let mainViewModule = factory.makeMainModule()
        mainViewModule.onLoginBtnDidTouch = { [unowned self] in
            let loginModule = factory.makeLoginModule()
            loginModule.onFinish = { [unowned self, weak mainViewModule] user in
                if let user = user {
                    mainViewModule?.setUserInfoItem(user: user)
                }
                self.router.dismissModule()
            }
            router.present(loginModule)
        }
        
        router.setRootModule(mainViewModule, hideBar: true)
        if let user = user {
            mainViewModule.loadViewIfNeeded()
            mainViewModule.setUserInfoItem(user: user)
        }
    }
}
