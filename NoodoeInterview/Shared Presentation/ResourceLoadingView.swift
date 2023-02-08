//
//  ResourceLoadingView.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import Foundation
import UIKit

protocol ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel)
}

extension ResourceLoadingView where Self: UIViewController {
    var loadingView: UIActivityIndicatorView {
        let loadingView = UIActivityIndicatorView(frame: self.view.frame)
        loadingView.style = .large
        view.addSubview(loadingView)
        return loadingView
    }
}
