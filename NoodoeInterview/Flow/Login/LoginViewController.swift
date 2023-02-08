//
//  LoginViewController.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import UIKit

class LoginViewController: UIViewController, StoryboardBased, LoginView {
    
    // MARK: - var
    var onFinish: ((UserInfoItem?) -> Void)?
    var onLoginBtnDidTouch: ((String, String) -> Void)?
    
    // MARK: - Outlet
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(frame: view.frame)
        loadingView.style = .large
        view.addSubview(loadingView)
        return loadingView
    }()
    
    // MARK: - Action
    @IBAction func didTouchLoginButton(_ sender: Any) {
        onLoginBtnDidTouch?(userNameTextField.text ?? "", passwordTextField.text ?? "")
    }
}

extension LoginViewController: ResourceLoadingView, ResourceErrorView {
    func display(_ viewModel: ResourceLoadingViewModel) {
        DispatchQueue.main.async {
            if viewModel.isLoading {
                self.loadingView.startAnimating()
            } else {
                self.loadingView.stopAnimating()
            }
        }
    }
    
    func display(_ viewModel: ResourceErrorViewModel) {
        guard let errorMessage = viewModel.message else { return }
        
        DispatchQueue.main.async {
            let errorView = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            self.present(errorView, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                errorView.dismiss(animated: true)
            }
        }
    }
}
