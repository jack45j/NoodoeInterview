//
//  UserInfoEndPointTests.swift
//  NoodoeInterviewTests
//
//  Created by 林翌埕-20001107 on 2023/2/8.
//

import XCTest

final class UserInfoEndPointTests: XCTestCase {

    func test_userInfo_signIn_endpointURL() {
        let baseURL = URL(string: "http://any.com")!
        
        let received = UserInfoEndPoint.signIn.url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "http", "Invalid scheme")
        XCTAssertEqual(received.host, "any.com", "Invalid host")
        XCTAssertEqual(received.path, "/login", "Invalid path")
        XCTAssertNil(received.query, "queryItem should be nil")
    }
    
    func test_userInfo_patch_timezone_endpointURL() {
        let baseURL = URL(string: "http://any.com")!
        let objectId = "SomeObjectId"
        
        let received = UserInfoEndPoint.patchTimezone(objectId: objectId).url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "http", "Invalid scheme")
        XCTAssertEqual(received.host, "any.com", "Invalid host")
        XCTAssertEqual(received.path, "/users/SomeObjectId", "Invalid path")
        XCTAssertNil(received.query, "queryItem should be nil")
    }
}
