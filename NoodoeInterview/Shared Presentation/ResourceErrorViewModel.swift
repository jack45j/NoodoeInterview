//
//  ResourceErrorViewModel.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import Foundation

struct ResourceErrorViewModel {
    let message: String?
    
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
