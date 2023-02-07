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
    
    @discardableResult
    func get(from url: URL, header: Header, params: Params,
             encoder: ParametersEncoder,
             storer: ((Data) -> Void)?,
             completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        executeRequest(from: url, method: .get, header: header, params: params, encoder: encoder, storer: storer, completion: completion)
    }
    
    @discardableResult
    func post(from url: URL, header: Header, params: Params,
              encoder: ParametersEncoder,
              storer: ((Data) -> Void)?,
              completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        executeRequest(from: url, method: .post, header: header, params: params, encoder: encoder, storer: storer, completion: completion)
    }
    
    @discardableResult
    func put(from url: URL, header: Header, params: Params,
             encoder: ParametersEncoder,
             storer: ((Data) -> Void)?,
             completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        executeRequest(from: url, method: .put, header: header, params: params, encoder: encoder, storer: storer, completion: completion)
    }
    
    private func executeRequest(
        from url: URL, method: HTTPRequestMethod, header: Header,
        params: Params, encoder: ParametersEncoder,
        storer: ((Data) -> Void)?,
        completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = header
            encoder.encode(parameters: params, request: &request)
            
            let task = session.dataTask(with: request) { data, response, error in
                completion(Result {
                    if let error = error {
                        throw error
                    } else if let data = data, let response = response as? HTTPURLResponse {
                        storer?(data)
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
