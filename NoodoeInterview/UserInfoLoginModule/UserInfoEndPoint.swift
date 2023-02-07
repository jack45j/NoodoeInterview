//
//  UserInfoEndPoint.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/7.
//

import Foundation

enum UserInfoEndPoint {
    static var baseURL: URL = URL(string: "https://watch-master-staging.herokuapp.com/api")!
    static var header: URLSessionHTTPClient.Header = ["X-Parse-Application-Id": "vqYuKPOkLQLYHhk4QTGsGKFwATT4mBIGREI2m8eD"]
    
    case signIn
    case patchTimezone(objectId: String)
    
    func url(baseURL: URL = baseURL) -> URL {
        switch self {
        case .signIn:
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/login"
            return components.url!
        case let .patchTimezone(objectId):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/users/\(objectId)"
            return components.url!
        }
    }
}
