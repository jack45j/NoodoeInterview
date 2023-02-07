//
//  ResourceView.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/7.
//

import Foundation

protocol ResourceView {
    associatedtype ResourceViewModel
    
    func display(_ viewModel: ResourceViewModel)
}
