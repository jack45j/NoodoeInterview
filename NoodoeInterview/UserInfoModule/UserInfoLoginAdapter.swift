//
//  UserInfoAdapter.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import Foundation

protocol UserInfoLoginUseCase {
    var store: LocalUserInfoStore { get set }
    func login(userName: String, password: String)
}

final class UserInfoLoginAdapter: UserInfoLoginUseCase, ResourceView {
    private var controller: LoginView?
    var presenter: ResourceLoadingPresenter<UserInfoItem, UserInfoLoginAdapter>?
    private let store: LocalUserInfoStore
    
    init(controller: LoginViewController? = nil,
         presenter: ResourceLoadingPresenter<UserInfoItem, UserInfoLoginAdapter>? = nil,
         store: LocalUserInfoStore) {
        self.controller = controller
        self.presenter = presenter
        self.store = store
    }
    
    func login(userName: String, password: String) {
        guard userName != "" && password != "" else {
            presenter?.didFinishLoading(errorMessage: "Username and Password should not be Empty")
            return
        }
        
        presenter?.didStartLoading()
        
        let loginEndpoint = UserInfoEndPoint.signIn
        
        let parameters: [String: String] = [
            "username": userName,
            "password": password
        ]
        
        URLSessionHTTPClient(session: .init(configuration: .ephemeral))
            .post(from: loginEndpoint.url(),
                  header: UserInfoEndPoint.header,
                  params: parameters,
                  encoder: JsonEncoder(),
                  completion: { [weak self] result in
                switch result {
                case let .success((data, _)):
                    switch UserInfoMapper.map(data: data) {
                    case let .success(user):
                        self?.store.cacheData(data)
                        self?.presenter?.didFinishLoading(resource: user)
                    case .failure:
                        self?.presenter?.didFinishLoading(errorMessage: "Login Failed")
                    }
                case let .failure(error):
                    self?.presenter?.didFinishLoading(error: error)
                }
            })
    }
    
    func display(_ viewModel: UserInfoItem) {
        guard let controller = controller else { return }
        controller.onFinish?(viewModel)
    }
}
