//
//  UserInfoEndPoint.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/7.
//

import Foundation

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
