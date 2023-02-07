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
    var presenter: ResourceLoadingPresenter<UserInfoViewModel, UserInfoLoginAdapter>?
    
    init(controller: LoginViewController? = nil, presenter: ResourceLoadingPresenter<UserInfoViewModel, UserInfoLoginAdapter>? = nil) {
        self.controller = controller
        self.presenter = presenter
    }
    
    func login(userName: String, password: String) {
        presenter?.didStartLoading()
        
        let loginEndpoint = UserInfoEndPoint.post
        
        let parameters: [String: String] = [
            "username": userName,
            "password": password
        ]
        
        URLSessionHTTPClient(session: .init(configuration: .ephemeral))
            .post(from: loginEndpoint.url(),
                  header: UserInfoEndPoint.header,
                  params: parameters,
                  encoder: JsonEncoder()) { [weak self] result in
                switch result {
                case let .success((data, response)):
                    guard let item = UserInfoViewModel.map(data: data, from: response) else { return }
                    self?.display(item)
                case let .failure(error):
                    self?.presenter?.didFinishLoading(error: error)
                }
            }
    }
    
    func display(_ viewModel: UserInfoViewModel) {
        guard let controller = controller else { return }
        controller.onFinish?(viewModel)
    }
}