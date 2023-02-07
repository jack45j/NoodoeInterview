//
//  UserInfoItemMapperTests.swift
//  NoodoeInterviewTests
//
//  Created by 林翌埕-20001107 on 2023/2/7.
//

import XCTest

final class UserInfoItemMapperTests: XCTestCase {

    func test_deliverNil_on_200HttpResponse_but_InvalidJsonData() {
        let invalidJsonData = Data("Some Invalid Values".utf8)
        
        XCTAssertNil(UserInfoMapper.map(data: invalidJsonData))
    }
    
    func test_deliverUserInfoItem_on_200HttpResponse_with_ValidJson() throws {
        
        let (item, json) = makeItem(name: "SomeName",
                                    phone: "1237891273891",
                                    create: "2023-02-07T14:44:44.444Z",
                                    update: "2023-02-07T15:55:55.555Z",
                                    objectId: "SomeObjectId",
                                    token: "SomeSessionToken",
                                    timeFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSz")
        
        let jsonData = try JSONSerialization.data(withJSONObject: json)
        let result = UserInfoMapper.map(data: jsonData)
        
        XCTAssertEqual(item, result)
    }
    
    func test_deliverNil_on_200HttpResponse_with_ValidJson_but_incorrect_timeFormat() throws {
        let (_, json) = makeItem(name: "SomeName",
                                    phone: "1237891273891",
                                    create: "2023:02:07T14:44:44Z",
                                    update: "2023:02:07T15:55:55Z",
                                    objectId: "SomeObjectId",
                                    token: "SomeSessionToken",
                                    timeFormat: "yyyy:MM:dd'T'HH:mm:ssz")
        
        let jsonData = try JSONSerialization.data(withJSONObject: json)
        let result = UserInfoMapper.map(data: jsonData)
        
        XCTAssertNil(result)
    }
    
    private func makeItem(name: String, phone: String, create: String, update: String, objectId: String, token: String, timeFormat: String?) -> (model: UserInfoItem, json: [String: Any]) {
        let formatter = DateFormatter()
        formatter.dateFormat = timeFormat
        let item = UserInfoItem(username: name,
                                phone: phone,
                                createdDate: formatter.date(from: create)!,
                                updatedDate: formatter.date(from: update)!,
                                objectId: objectId,
                                sessionToken: token)
        
        let json: [String: String] = [
            "username": name,
            "phone": phone,
            "createdAt": create,
            "updatedAt": update,
            "objectId": objectId,
            "sessionToken": token
        ]
        
        return (item, json)
    }
}
