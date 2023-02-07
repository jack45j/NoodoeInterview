//
//  UserInfoUpdateDataAdapter.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/7.
//

import Foundation

protocol UserInfoUpdateDataUseCase {
    func signOut()
    func patchTimeZone()
}

final class UserInfoUpdateDataAdapter: UserInfoUpdateDataUseCase, ResourceView {
    private var controller: UserInfoView?
    var presenter: ResourceLoadingPresenter<UserInfoItem, UserInfoUpdateDataAdapter>?
    
    init(controller: UserInfoView? = nil, presenter: ResourceLoadingPresenter<UserInfoItem, UserInfoUpdateDataAdapter>? = nil) {
        self.controller = controller
        self.presenter = presenter
    }
    
    func signOut() {
        UserDefaults.standard.set(nil, forKey: "Noodoe.UserInfoItem")
        controller?.userDataDidChange(user: nil)
    }
    
    func patchTimeZone() {
        presenter?.didStartLoading()
        guard
            let userData = UserDefaults.standard.data(forKey: "Noodoe.UserInfoItem"),
            let user = UserInfoMapper.map(data: userData)
        else {
            presenter?.didFinishLoading(errorMessage: "Session expired or Incorrect User Info")
            return
        }
    }
    
    func display(_ viewModel: UserInfoItem?) {
        guard let controller = controller else { return }
        controller.onFinish?()
    }
}
