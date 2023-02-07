//
//  ModuleFactory+Imp.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import Foundation

final class ModuleFactoryImp: ModuleFactory {
    func makeMainModule() -> MainViewController {
        let module = MainViewController.instantiate()
        
        return module
    }
    
    func makeLoginModule() -> LoginViewController {
        let module = LoginViewController.instantiate()
        
        let adapter = UserInfoLoginAdapter(controller: module)
        adapter.presenter = ResourceLoadingPresenter(
            resourceView: adapter,
            loadingView: module,
            errorView: module,
            mapper: { $0 })
        module.onLoginBtnDidTouch = adapter.login
        
        module.isModalInPresentation = true
        return module
    }
}
