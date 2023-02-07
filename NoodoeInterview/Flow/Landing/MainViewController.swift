//
//  MainViewController.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/3.
//

import UIKit

protocol UserInfoView {
    var onFinish: (() -> Void)? { get set }
    var onLoginShouldStart: (() -> Void)? { get set }
    var onLogOutShouldStart: (() -> Void)? { get set }
    var onPatchTimeZoneShouldStart: (() -> Void)? { get set }
    func userDataDidChange(user: UserInfoItem?)
}

class MainViewController: UIViewController, StoryboardBased, UserInfoView {
    
    // MARK: - Outlet
    @IBOutlet weak var userInfoContainerView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var patchTimeZoneButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    // MARK: - output
    var onFinish: (() -> Void)?
    var onLoginShouldStart: (() -> Void)?
    var onLogOutShouldStart: (() -> Void)?
    var onPatchTimeZoneShouldStart: (() -> Void)?
    
    // MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInfoContainerView()
    }
    
    private func setupUserInfoContainerView() {
        userInfoContainerView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        userInfoContainerView.clipsToBounds = false
        userInfoContainerView.layer.cornerRadius = 8
        userInfoContainerView.layer.shadowRadius = 8
        userInfoContainerView.layer.shadowColor = UIColor.lightGray.cgColor
        userInfoContainerView.layer.shadowOffset = .init(width: 0, height: 1)
        userInfoContainerView.layer.shadowOpacity = 0.4
    }
    
    func userDataDidChange(user: UserInfoItem?) {
        DispatchQueue.main.async {
            self.userNameLabel.text = user?.username ?? "未登入"
            self.phoneNumLabel.text = user?.phone ?? ""
            if let updatedDate = user?.updatedDate {
                self.lastUpdatedLabel.text = DateFormatter.localizedString(
                    from: updatedDate,
                    dateStyle: .short,
                    timeStyle: .short
                )
            } else {
                self.lastUpdatedLabel.text = ""
            }
            self.signInButton.isHidden = user != nil
            self.signOutButton.isHidden = user == nil
            self.patchTimeZoneButton.isHidden = user == nil
        }
    }
    
    // MARK: - Action
    @IBAction func didTouchLoginButton(_ sender: Any) {
        onLoginShouldStart?()
    }
    
    @IBAction func didTouchLogoutButton(_ sender: Any) {
        onLogOutShouldStart?()
    }
    
    @IBAction func didTouchPatchTimeZoneButton(_ sender: Any) {
        onPatchTimeZoneShouldStart?()
    }
}

extension MainViewController: ResourceErrorView, ResourceLoadingView {
    func display(_ viewModel: ResourceErrorViewModel) {
        
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
}
