//
//  SharedTestHelper.swift
//  NoodoeInterviewTests
//
//  Created by 林翌埕-20001107 on 2023/2/7.
//

import Foundation
import XCTest

extension XCTest {
     func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
     func anyURL() -> URL {
        return URL(string: "http://anyURL.com")!
    }
    
     func anyHeader() -> URLSessionHTTPClient.Header {
        return ["SomeHeaderKey": "SomeHeaderValue"]
    }
    
     func anyParams() -> URLSessionHTTPClient.Params {
        return ["someParamsKey": "anyParamsValue"]
    }
    
    func anyData() -> Data {
        return Data("any data".utf8)
    }
    
     func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
     func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}
