//
//  LaunchViewController.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/9.
//

import UIKit

class LaunchViewController: UIViewController, LaunchView, StoryboardBased {
    
    var onFinish: (() -> Void)?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserDefaults.standard.set(true, forKey: "Noodoe.LaunchScreenDidShow")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.onFinish?()
        }
    }
}
