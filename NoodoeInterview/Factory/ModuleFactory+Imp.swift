//
//  ModuleFactory+Imp.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import Foundation

final class ModuleFactoryImp: ModuleFactory {
    func makeMainModule(store: LocalUserInfoStore) -> MainViewController {
        let module = MainViewController.instantiate()
        
        let adapter = UserInfoUpdateDataAdapter(controller: module, store: store)
        adapter.presenter = ResourceLoadingPresenter(
            resourceView: adapter,
            loadingView: module,
            errorView: module,
            mapper: { $0 }
        )
        module.onLogOutShouldStart = adapter.signOut
        module.onPatchTimeZoneShouldStart = { adapter.patchTimeZone(to: Int.random(in: 0...8)) }
        
        return module
    }
    
    func makeLoginModule(store: LocalUserInfoStore) -> LoginViewController {
        let module = LoginViewController.instantiate()
        
        let adapter = UserInfoLoginAdapter(controller: module, store: store)
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
