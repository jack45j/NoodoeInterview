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
        
        let patchTimeZoneEndpoint = UserInfoEndPoint.patchTimezone(objectId: user.objectId)
        
        var header = UserInfoEndPoint.header
        header["X-Parse-Session-Token"] = user.sessionToken
        
        let parameter = [
            "timezone": 8
        ]
        
        URLSessionHTTPClient(session: .init(configuration: .ephemeral))
            .put(from: patchTimeZoneEndpoint.url(),
                 header: header,
                 params: parameter,
                 encoder: JsonEncoder(),
                 storer: { data in
                // TODO: Encrypt and Store Data
                
            },
                 completion: { [weak self] result in
                switch result {
                case let .success((data, _)):
                    guard let item = UserInfoMapper.map(data: data) else { return }
                    self?.display(item)
                case let .failure(error):
                    self?.presenter?.didFinishLoading(error: error)
                }
            })
    }
    
    func display(_ viewModel: UserInfoItem?) {
        guard let controller = controller else { return }
        controller.onFinish?()
    }
}
