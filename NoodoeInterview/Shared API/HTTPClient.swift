//
//  HTTPClient.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import Foundation

protocol HTTPClientSharedUseCase {
    var header: URLSessionHTTPClient.Header { get }
}

final class LoginHTTPClient: HTTPClientSharedUseCase {
    var header: URLSessionHTTPClient.Header {
        return [
            "X-Parse-Application-Id": "vqYuKPOkLQLYHhk4QTGsGKFwATT4mBIGREI2m8eD"
        ]
    }
}

protocol HTTPClientTask {
    func cancel()
}

protocol HTTPClient {
    typealias Header = [String: String]
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func get(from url: URL, header: Header, completion: @escaping (Result) -> Void) -> HTTPClientTask
    
    @discardableResult
    func post(from url: URL, header: Header, completion: @escaping (Result) -> Void) -> HTTPClientTask
    
    @discardableResult
    func put(from url: URL, header: Header, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
