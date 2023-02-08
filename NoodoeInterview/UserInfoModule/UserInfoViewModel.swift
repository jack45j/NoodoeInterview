//
//  UserInfoViewModel.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/7.
//

import Foundation

struct UserInfoItem: Hashable {
    var username: String
    var phone: String
    var createdDate: Date
    var updatedDate: Date
    var objectId: String
    var sessionToken: String
}

final class UserInfoMapper {
    private struct UsefInfoPatchItem: Decodable {
        var updatedAt: Date
        
        enum CodingKeys: CodingKey {
            case updatedAt
        }
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
            if let updatedAt = UserInfoMapper.formatter.date(from: updatedAtString) {
                self.updatedAt = updatedAt
            } else {
                throw DecodingError.typeMismatch(Date.self, .init(codingPath: [CodingKeys.updatedAt], debugDescription: "createAt expect an ISO8601 time String but got incorrect format"))
            }
        }
    }
    
    private struct RemoteUserInfoItem: Decodable {
        var username: String
        var phone: String
        var createdAt: Date
        var updatedAt: Date
        var objectId: String
        var sessionToken: String
        
        init(username: String, phone: String, createdAt: Date, updatedAt: Date, objectId: String, sessionToken: String) {
            self.username = username
            self.phone = phone
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.objectId = objectId
            self.sessionToken = sessionToken
        }
        
        var user: UserInfoItem {
            return .init(username: username,
                         phone: phone,
                         createdDate: createdAt,
                         updatedDate: updatedAt,
                         objectId: objectId,
                         sessionToken: sessionToken)
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
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.username = try container.decode(String.self, forKey: .username)
            self.phone = try container.decode(String.self, forKey: .phone)
            let createdAtString = try container.decode(String.self, forKey: .createdAt)
            if let createdAt = UserInfoMapper.formatter.date(from: createdAtString) {
                self.createdAt = createdAt
            } else {
                throw DecodingError.typeMismatch(Date.self, .init(codingPath: [CodingKeys.createdAt], debugDescription: "createAt expect an ISO8601 time String but got incorrect format"))
            }
            
            let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
            if let updatedAt = UserInfoMapper.formatter.date(from: updatedAtString) {
                self.updatedAt = updatedAt
            } else {
                throw DecodingError.typeMismatch(Date.self, .init(codingPath: [CodingKeys.updatedAt], debugDescription: "createAt expect an ISO8601 time String but got incorrect format"))
            }
            self.objectId = try container.decode(String.self, forKey: .objectId)
            self.sessionToken = try container.decode(String.self, forKey: .sessionToken)
        }
    }
    
    static var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
        return formatter
    }
    
    enum Error: Swift.Error {
        case invalidData
    }
    
    static func map(dateData: Data) -> Date? {
        guard let item = try? JSONDecoder().decode(UsefInfoPatchItem.self, from: dateData) else {
            return nil
        }
        
        return item.updatedAt
    }
    
    static func map(data: Data) -> Result<UserInfoItem, Error> {
        guard let root = try? JSONDecoder().decode(RemoteUserInfoItem.self, from: data) else {
            return .failure(Error.invalidData)
        }
        
        return .success(root.user)
    }
    
    static func map(data userData: UserInfoItem) -> Result<Data, Error> {
        let json: [String: Any] = [
            "username": userData.username,
            "phone": userData.phone,
            "createdAt": UserInfoMapper.formatter.string(from: userData.createdDate),
            "updatedAt": UserInfoMapper.formatter.string(from: userData.updatedDate),
            "objectId": userData.objectId,
            "sessionToken": userData.sessionToken
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: json) else {
            return .failure(.invalidData)
        }
        
        return .success(data)
    }
}

protocol DataStore {
    associatedtype DataStoreError: Error
    func deleteCacheData() -> Result<Void, DataStoreError>
    func retrieve() -> Result<UserInfoItem, DataStoreError>
    func cacheData(_ data: Data?) -> Result<Void, DataStoreError>
}

final class LocalUserInfoStore: DataStore {
    
    enum LocalDataStoreConfig {
        case `default`
        case custom(key: String)
        
        var key: String {
            switch self {
            case .default:
                return "Noodoe.UserInfoitem"
            case let .custom(key):
                return key
            }
        }
    }
    
    private let config: LocalDataStoreConfig
    
    init(config: LocalDataStoreConfig = .default) {
        self.config = config
    }
    
    enum DataStoreError: Error, CustomStringConvertible {
        var description: String {
            switch self {
            case .noCacheData:  return "noCacheData"
            case .invalidData:  return "invalidData"
            }
        }
        
        case noCacheData
        case invalidData
    }
    @discardableResult
    
    func deleteCacheData() -> Result<Void, DataStoreError> {
        UserDefaults.standard.set(nil, forKey: config.key)
        return .success(())
    }
    
    @discardableResult
    func retrieve() -> Result<UserInfoItem, DataStoreError> {
        if let data = UserDefaults.standard.data(forKey: config.key) {
            switch UserInfoMapper.map(data: data) {
            case .success(let item):
                return .success(item)
            case .failure:
                return .failure(.noCacheData)
            }
        } else {
            return .failure(.noCacheData)
        }
    }
    
    @discardableResult
    func cacheData(_ data: Data?) -> Result<Void, DataStoreError> {
        guard let data = data else { return .failure(.noCacheData) }
        switch UserInfoMapper.map(data: data) {
        case .success:
            UserDefaults.standard.set(data, forKey: config.key)
            return .success(())
        case .failure: return .failure(.invalidData)
        }
    }
}
