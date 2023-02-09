//
//  UserInfoView.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/9.
//

import Foundation

protocol UserInfoViewOutput {
    var onFinish: (() -> Void)? { get set }
}

protocol UserInfoView {
    var onLoginShouldStart: (() -> Void)? { get set }
    var onLogOutShouldStart: (() -> Void)? { get set }
    var onPatchTimeZoneShouldStart: (() -> Void)? { get set }
    func userDataDidChange(user: UserInfoItem?)
}
