//
//  LoginViewController.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import UIKit

class LoginViewController: UIViewController, StoryboardBased, ResourceLoadingView, ResourceErrorView, LoginView {
    
    var onFinish: ((UserInfoViewModel?) -> Void)?
    var onLoginBtnDidTouch: ((String, String) -> Void)?
    
    @IBAction func didTouchLoginButton(_ sender: Any) {
        onLoginBtnDidTouch?("test2@qq.com", "test1234qq")
    }
    
    func display(_ viewModel: ResourceLoadingViewModel) {
        print("isLoading: \(viewModel.isLoading)")
    }
    
    func display(_ viewModel: ResourceErrorViewModel) {
        print("error: \(viewModel.message)")
    }
}
