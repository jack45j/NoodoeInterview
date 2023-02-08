//
//  UserInfoStore.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/8.
//

import Foundation

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
