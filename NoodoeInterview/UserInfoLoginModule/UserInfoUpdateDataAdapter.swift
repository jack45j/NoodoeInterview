//
//  UserInfoUpdateDataAdapter.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/7.
//

import Foundation

protocol UserInfoUpdateDataUseCase {
    
}

final class UserInfoUpdateDataAdapter: UserInfoUpdateDataUseCase, ResourceView {
    private var controller: UserInfoView?
    var presenter: ResourceLoadingPresenter<UserInfoItem, UserInfoUpdateDataAdapter>?
    
    func display(_ viewModel: UserInfoItem) {
        guard let controller = controller else { return }
        controller.onFinish?()
    }
}
