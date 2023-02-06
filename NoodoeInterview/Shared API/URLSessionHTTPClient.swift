//
//  URLSessionHTTPClient.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    enum HTTPRequestMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    func get(from url: URL, header: Header, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        executeRequest(from: url, method: .get, header: header, completion: completion)
    }
    
    func post(from url: URL, header: Header, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        executeRequest(from: url, method: .post, header: header, completion: completion)
    }
    
    func put(from url: URL, header: Header, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        executeRequest(from: url, method: .put, header: header, completion: completion)
    }
    
    private func executeRequest(from url: URL, method: HTTPRequestMethod, header: Header, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = header
        
        let task = session.dataTask(with: request) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}
