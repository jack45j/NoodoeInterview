//
//  UserInfoAdapter.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import Foundation

protocol UserInfoLoginUseCase {
    func login(userName: String, password: String)
}

final class UserInfoLoginAdapter: UserInfoLoginUseCase, ResourceView {
    private var controller: LoginView?
    var presenter: ResourceLoadingPresenter<UserInfoItem, UserInfoLoginAdapter>?
    
    init(controller: LoginViewController? = nil, presenter: ResourceLoadingPresenter<UserInfoItem, UserInfoLoginAdapter>? = nil) {
        self.controller = controller
        self.presenter = presenter
    }
    
    func login(userName: String, password: String) {
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
                  storer: { data in
                // TODO: Encrypt and Store Data
                UserDefaults.standard.set(data, forKey: "Noodoe.UserInfoItem")
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
    
    func display(_ viewModel: UserInfoItem) {
        guard let controller = controller else { return }
        controller.onFinish?(viewModel)
    }
}
