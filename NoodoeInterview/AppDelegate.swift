//
//  AppDelegate.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/3.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var rootController: UINavigationController {
        guard let rootController = self.window?.rootViewController as? UINavigationController else { fatalError("window has been deallocated or not been init") }
        return rootController
    }

    // Use lazy var to avoid deallocate
    private lazy var appCoordinator: Coordinator = {
        let coordinator = ApplicationCoordinator(
            coordinatorFactory: CoordinatorFactoryImp(),
            factory: ModuleFactoryImp(),
            router: RouterImp(rootController: self.rootController))
        return coordinator
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController()
        window?.makeKeyAndVisible()
        appCoordinator.start()
        return true
    }
}
