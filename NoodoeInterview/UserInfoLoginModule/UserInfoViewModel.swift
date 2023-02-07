//
//  UserInfoViewModel.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/7.
//

import Foundation

struct UserInfoViewModel: Decodable {
    var username: String
    var phone: String
    var createdAt: Date
    var updatedAt: Date
    var objectId: String
    var sessionToken: String
    
    static func map(data: Data, from response: HTTPURLResponse) -> UserInfoViewModel? {
        guard response.statusCode == 200,
              let item = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        
        return item
    }
    
    enum CodingKeys: CodingKey {
        case username
        case phone
        case createdAt
        case updatedAt
        case objectId
        case sessionToken
    }
    
    init(from decoder: Decoder) throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.phone = try container.decode(String.self, forKey: .phone)
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        if let createdAt = formatter.date(from: createdAtString) {
            self.createdAt = createdAt
        } else {
            throw DecodingError.typeMismatch(Date.self, .init(codingPath: [CodingKeys.createdAt], debugDescription: "createAt expect an ISO8601 time String but got incorrect format"))
        }
        
        let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
        if let updatedAt = formatter.date(from: updatedAtString) {
            self.updatedAt = updatedAt
        } else {
            throw DecodingError.typeMismatch(Date.self, .init(codingPath: [CodingKeys.updatedAt], debugDescription: "createAt expect an ISO8601 time String but got incorrect format"))
        }
        self.objectId = try container.decode(String.self, forKey: .objectId)
        self.sessionToken = try container.decode(String.self, forKey: .sessionToken)
    }
}