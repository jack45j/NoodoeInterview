//
//  ResourceLoadingPresenter.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/7.
//

import Foundation

final class ResourceLoadingPresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) throws -> View.ResourceViewModel
    private let resourceView: View
    private let loadingView: ResourceLoadingView
    private let errorView: ResourceErrorView
    private let mapper: Mapper
    
    public init(resourceView: View,
                loadingView: ResourceLoadingView,
                errorView: ResourceErrorView,
                mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    func didStartLoading() {
        loadingView.display(.init(isLoading: true))
        errorView.display(.noError)
    }
    
    func didFinishLoading(resource: Resource) {
        let mappedResource = Result {
            try mapper(resource)
        }
        switch mappedResource {
        case let .success(resource):
            resourceView.display(resource)
            loadingView.display(.init(isLoading: false))
        case let .failure(err):
            errorView.display(.error(message: err.localizedDescription))
        }
    }
    
    func didFinishLoading(errorMessage: String) {
        errorView.display(.error(message: errorMessage))
        loadingView.display(.init(isLoading: false))
    }
    
    func didFinishLoading(error: Error) {
        errorView.display(.error(message: error.localizedDescription))
        loadingView.display(.init(isLoading: false))
    }
}
