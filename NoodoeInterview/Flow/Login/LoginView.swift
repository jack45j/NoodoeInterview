//
//  LoginView.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import Foundation

protocol LoginViewOutput {
    var onFinish: ((UserInfoItem?) -> Void)? { get set }
}

protocol LoginView: LoginViewOutput {}
