//
//  LaunchViewOutput.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/9.
//

import Foundation

protocol LaunchViewOutput {
    var onFinish: (() -> Void)? { get set }
}

protocol LaunchView: LaunchViewOutput {}
