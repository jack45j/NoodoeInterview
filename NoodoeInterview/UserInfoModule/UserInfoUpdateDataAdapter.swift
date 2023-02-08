//
//  UserInfoUpdateDataAdapter.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/7.
//

import Foundation

protocol UserInfoUpdateDataUseCase {
    func signOut()
    func patchTimeZone(to timezone: Int)
}

final class UserInfoUpdateDataAdapter: UserInfoUpdateDataUseCase, ResourceView {
    private var controller: UserInfoView?
    var presenter: ResourceLoadingPresenter<UserInfoItem?, UserInfoUpdateDataAdapter>?
    
    init(controller: UserInfoView? = nil, presenter: ResourceLoadingPresenter<UserInfoItem?, UserInfoUpdateDataAdapter>? = nil) {
        self.controller = controller
        self.presenter = presenter
    }
    
    func signOut() {
        LocalUserInfoStore().deleteCacheData()
        controller?.userDataDidChange(user: nil)
    }
    
    func patchTimeZone(to timezone: Int) {
        presenter?.didStartLoading()
        guard let user = try? LocalUserInfoStore().retrieve().get() else {
            presenter?.didFinishLoading(errorMessage: "Session expired or Incorrect User Info")
            return
        }
        
        let patchTimeZoneEndpoint = UserInfoEndPoint.patchTimezone(objectId: user.objectId)
        
        var header = UserInfoEndPoint.header
        header["X-Parse-Session-Token"] = user.sessionToken
        
        let parameter = [
            "timezone": timezone
        ]
        
        URLSessionHTTPClient(session: .init(configuration: .ephemeral))
            .put(from: patchTimeZoneEndpoint.url(),
                 header: header,
                 params: parameter,
                 encoder: JsonEncoder(),
                 completion: { [weak self] result in
                switch result {
                case let .success((data, _)):
                    guard let updatedTime = UserInfoMapper.map(dateData: data),
                          var user = try? LocalUserInfoStore().retrieve().get()
                    else {
                        self?.presenter?.didFinishLoading(errorMessage: "Login Session expired or invalid User Data")
                        return
                    }
                    
                    user.updatedDate = updatedTime
                    guard let data = try? UserInfoMapper.map(data: user).get(),
                          let _ = try? LocalUserInfoStore().cacheData(data).get() else {
                        self?.presenter?.didFinishLoading(errorMessage: "Login Session expired or invalid User Data")
                        return
                    }
                    
                    self?.presenter?.didFinishLoading(resource: user)
                case let .failure(error):
                    self?.presenter?.didFinishLoading(error: error)
                }
            })
    }
    
    func display(_ viewModel: UserInfoItem?) {
        guard let controller = controller else { return }
        controller.userDataDidChange(user: viewModel)
    }
}
