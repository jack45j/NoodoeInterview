//
//  URLSessionHTTPClientTests.swift
//  NoodoeInterviewTests
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import XCTest

final class URLSessionHTTPClientTests: XCTestCase {

    override func setUpWithError() throws {
        URLProtocolStub.removeStub()
    }
    
    func test_getHttpMethod_matches() {
        let url = anyURL()
        let header = anyHeader()
        let params = anyParams()
        let jsonEncoder = JsonEncoder()
        
        let exp = expectation(description: "Wait for requests")
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.httpMethod, URLSessionHTTPClient.HTTPRequestMethod.get.rawValue)
            XCTAssertTrue(request.allHTTPHeaderFields!.contains(dict: header))
            exp.fulfill()
        }
        makeSUT().get(from: url, header: header, params: params, encoder: jsonEncoder) { _ in }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_postHttpMethod_matches() {
        let url = anyURL()
        let header = anyHeader()
        let params = anyParams()
        let jsonEncoder = JsonEncoder()
        
        let exp = expectation(description: "Wait for requests")
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.httpMethod, URLSessionHTTPClient.HTTPRequestMethod.post.rawValue)
            XCTAssertTrue(request.allHTTPHeaderFields!.contains(dict: header))
            exp.fulfill()
        }
        makeSUT().post(from: url, header: header, params: params, encoder: jsonEncoder) { _ in }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_putHttpMethod_matches() {
        let url = anyURL()
        let header = anyHeader()
        let params = anyParams()
        let jsonEncoder = JsonEncoder()
        
        let exp = expectation(description: "Wait for requests")
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.httpMethod, URLSessionHTTPClient.HTTPRequestMethod.put.rawValue)
            XCTAssertTrue(request.allHTTPHeaderFields!.contains(dict: header))
            exp.fulfill()
        }
        makeSUT().put(from: url, header: header, params: params, encoder: jsonEncoder) { _ in }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_cancelGetFromURLTask_cancelsURLRequest() {
        let exp = expectation(description: "Wait for request")
        URLProtocolStub.observeRequests { _ in exp.fulfill() }

        let receivedError = resultErrorFor(taskHandler: { $0.cancel() }) as NSError?
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(receivedError?.code, URLError.cancelled.rawValue)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let requestError = anyNSError()
        
        let receivedError = resultErrorFor((data: nil, response: nil, error: requestError))
        
        XCTAssertNotNil(receivedError)
    }
    
    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        XCTAssertNotNil(resultErrorFor((data: nil, response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor((data: nil, response: nonHTTPURLResponse(), error: nil)))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nil, error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: nil, response: nonHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: nil, response: anyHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nonHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: anyHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nonHTTPURLResponse(), error: nil)))
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValuesFor((data: data, response: response, error: nil))
        
        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValuesFor((data: nil, response: response, error: nil))
        
        let emptyData = Data()
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = URLSessionHTTPClient(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func resultValuesFor(_ values: (data: Data?, response: URLResponse?, error: Error?),
                                 file: StaticString = #filePath, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let result = resultFor(values, file: file, line: line)
        switch result {
        case let .success(values):
            return values
        default:
            XCTFail("Expected success, got \(result) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultErrorFor(_ values: (data: Data?, response: URLResponse?, error: Error?)? = nil,
                                taskHandler: (HTTPClientTask) -> Void = { _ in },
                                file: StaticString = #filePath, line: UInt = #line) -> Error? {
        let result = resultFor(values, taskHandler: taskHandler, file: file, line: line)
        
        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure, got \(result) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultFor(_ values: (data: Data?, response: URLResponse?, error: Error?)?,
                           taskHandler: (HTTPClientTask) -> Void = { _ in },
                           file: StaticString = #filePath, line: UInt = #line) -> HTTPClient.Result {
        values.map { URLProtocolStub.stub(data: $0, response: $1, error: $2) }
        
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        
        var receivedResult: HTTPClient.Result!
        taskHandler(sut.get(from: anyURL(), header: anyHeader(), params: anyParams(), encoder: JsonEncoder()) { result in
            receivedResult = result
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }
}

private extension Dictionary where Key: Hashable, Value: Equatable {
    func contains(dict: Dictionary) -> Bool {
        dict.allSatisfy {
            return self[$0.key] == $0.value
        }
    }
}
