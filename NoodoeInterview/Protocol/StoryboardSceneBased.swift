//
//  StoryboardSceneBased.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/3.
//

import UIKit

protocol StoryboardBased: AnyObject {
    static var sceneStoryboard: UIStoryboard { get }
}

extension StoryboardBased {
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
    }
}

extension StoryboardBased where Self: UIViewController {
    static func instantiate() -> Self {
        let viewController = sceneStoryboard.instantiateInitialViewController()
        guard let typedViewController = viewController as? Self else {
            fatalError("The initialViewController of '\(sceneStoryboard)' is not of class '\(self)'")
        }
        return typedViewController
    }
}
