//
//  MainViewController.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/3.
//

import UIKit

class MainViewController: UIViewController, StoryboardBased {
    
    // MARK: - Outlet
    @IBOutlet weak var userInfoContainerView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var patchTimeZoneButton: UIButton!
    
    // MARK: - output
    var onLoginBtnDidTouch: (() -> Void)?
    
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
    
    func setUserInfoItem(user: UserInfoItem) {
        DispatchQueue.main.async {
            self.userNameLabel.text = user.username
            self.phoneNumLabel.text = user.phone
            self.lastUpdatedLabel.text = DateFormatter.localizedString(
                from: user.updatedDate,
                dateStyle: .short,
                timeStyle: .short
            )
            self.signInButton.isHidden = true
            self.patchTimeZoneButton.isHidden = false
        }
    }
    
    // MARK: - Action
    @IBAction func didTouchLoginButton(_ sender: Any) {
        onLoginBtnDidTouch?()
    }
    
    @IBAction func didTouchPatchTimeZoneButton(_ sender: Any) {
        
    }
}
