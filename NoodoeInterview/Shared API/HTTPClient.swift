//
//  HTTPClient.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import Foundation

protocol HTTPClientTask {
    func cancel()
}

protocol HTTPClient {
    typealias Header = [String: String]
    typealias Params = Encodable
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    typealias Completion = (Result) -> Void
    
    @discardableResult
    func get(from url: URL, header: Header, params: Params, encoder: ParametersEncoder, storer: ((Data) -> Void)?, completion: @escaping (Result) -> Void) -> HTTPClientTask
    
    @discardableResult
    func post(from url: URL, header: Header, params: Params, encoder: ParametersEncoder, storer: ((Data) -> Void)?, completion: @escaping (Result) -> Void) -> HTTPClientTask
    
    @discardableResult
    func put(from url: URL, header: Header, params: Params, encoder: ParametersEncoder, storer: ((Data) -> Void)?, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
