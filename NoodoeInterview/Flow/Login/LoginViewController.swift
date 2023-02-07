//
//  LoginViewController.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import UIKit

class LoginViewController: UIViewController, StoryboardBased, ResourceLoadingView, ResourceErrorView, LoginView {
    
    var onFinish: ((UserInfoItem?) -> Void)?
    var onLoginBtnDidTouch: ((String, String) -> Void)?
    
    @IBAction func didTouchLoginButton(_ sender: Any) {
        onLoginBtnDidTouch?("test2@qq.com", "test1234qq")
    }
    
    func display(_ viewModel: ResourceLoadingViewModel) {
        let loadingView = UIActivityIndicatorView(frame: view.frame)
        loadingView.style = .large
        view.addSubview(loadingView)
        if viewModel.isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
            loadingView.removeFromSuperview()
        }
    }
    
    func display(_ viewModel: ResourceErrorViewModel) {
        print("error: \(viewModel.message)")
    }
}
