//
//  ResourceLoadingPresenterTests.swift
//  NoodoeInterviewTests
//
//  Created by 林翌埕-20001107 on 2023/2/8.
//

import XCTest

final class ResourceLoadingPresenterTests: XCTestCase {

    func test_didStartLoading_deliverEmptyErrorMessage_startLoading() throws {
        let (sut, spy) = makeSUT()
        sut.didStartLoading()
        
        XCTAssertEqual(spy.messages, [
            .display(isLoading: true),
            .display(errorMessage: nil)
        ])
    }
    
    func test_didFinishLoadingWithMapperSuccess_deliverEmptyErrorMessage_startLoading() throws {
        let (sut, spy) = makeSUT { resource in
            resource + " Delivered"
        }
        sut.didFinishLoading(resource: "Finish With Resources")
        
        XCTAssertEqual(spy.messages, [
            .display(resourceViewModel: "Finish With Resources Delivered"),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingWithMapperFailure_deliverErrorMessage_finishLoading() throws {
        let (sut, spy) = makeSUT { _ in
            throw self.anyNSError()
        }
        
        sut.didFinishLoading(resource: "Finish With Resources")
        
        XCTAssertEqual(spy.messages, [
            .display(errorMessage: self.anyNSError().localizedDescription),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingWithErrorMessage_deliverErrorMessage_finishLoading() throws {
        let (sut, spy) = makeSUT()
        
        sut.didFinishLoading(errorMessage: "SomeErrorMessage")
        
        XCTAssertEqual(spy.messages, [
            .display(errorMessage: "SomeErrorMessage"),
            .display(isLoading: false)
        ])
    }
    
    private typealias SUT = ResourceLoadingPresenter<String, ViewSpy>
    
    private func makeSUT(mapper: @escaping SUT.Mapper = { _ in "String" }) -> (sut: SUT, spy: ViewSpy) {
        let spy = ViewSpy()
        let sut = SUT(resourceView: spy,
                      loadingView: spy,
                      errorView: spy,
                      mapper: mapper)
        return (sut: sut, spy: spy)
    }
    
    private class ViewSpy: ResourceView, ResourceLoadingView, ResourceErrorView {
        
        typealias ResourceViewModel = String
        
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(resourceViewModel: String)
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: ResourceErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: ResourceLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: String) {
            messages.insert(.display(resourceViewModel: viewModel))
        }
    }
}
