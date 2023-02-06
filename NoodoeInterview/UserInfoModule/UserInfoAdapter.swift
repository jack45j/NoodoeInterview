//
//  UserInfoAdapter.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import Foundation

protocol ResourceView {
    associatedtype ResourceViewModel
    
    func display(_ viewModel: ResourceViewModel)
}

protocol UserInfoUseCase {
    func login(userName: String, password: String)
}

enum UserInfoEndPoint {
    static var baseURL: URL = URL(string: "https://watch-master-staging.herokuapp.com/api/login")!
    static var header: URLSessionHTTPClient.Header = ["X-Parse-Application-Id": "vqYuKPOkLQLYHhk4QTGsGKFwATT4mBIGREI2m8eD"]
    case post
    
    func url(baseURL: URL = baseURL) -> URL {
        switch self {
        case .post:      return baseURL
        }
    }
}

public final class UserInfoPresenter {
    private let loadingView: ResourceLoadingView
    private let errorView: ResourceErrorView
    
    init(loadingView: ResourceLoadingView, errorView: ResourceErrorView) {
        self.loadingView = loadingView
        self.errorView = errorView
    }
}

final class UserInfoAdapter: UserInfoUseCase {
    
    var presenter: UserInfoPresenter?
    
    func login(userName: String, password: String) {
        let loginEndpoint = UserInfoEndPoint.post
        
        let parameters: [String: String] = [
            "username": userName,
            "password": password
        ]
        
        URLSessionHTTPClient(session: .init(configuration: .default))
            .post(from: loginEndpoint.url(), header: UserInfoEndPoint.header, params: parameters, encoder: JsonEncoder()) { result in
                switch result {
                case let .success(data, response):
                    return
                case let .failure(error):
                    return
                }
            }
    }
}
