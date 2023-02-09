//
//  ModuleFactory.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import Foundation

protocol ModuleFactory {
    func makeMainModule(store: LocalUserInfoStore) -> MainViewController
    func makeLoginModule(store: LocalUserInfoStore) -> LoginViewController
}
