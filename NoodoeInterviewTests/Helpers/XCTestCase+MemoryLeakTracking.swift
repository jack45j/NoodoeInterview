//
//  XCTestCase+MemoryLeakTracking.swift
//  NoodoeInterviewTests
//
//  Created by 林翌埕-20001107 on 2023/2/3.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
