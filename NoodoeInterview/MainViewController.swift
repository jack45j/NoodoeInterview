//
//  MainViewController.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/3.
//

import UIKit

class LoadingView: ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel) {
        
    }
}

class ErrorView: ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel) {
        
    }
}

class MainViewController: UIViewController, StoryboardBased {
    override func viewDidLoad() {
        super.viewDidLoad()
//        UserInfoAdapter()
//            .login(userName: "test2@qq.com", password: "test1234qq")
    }
}
