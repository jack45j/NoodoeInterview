//
//  BaseCoordinatorTests.swift
//  NoodoeInterviewTests
//
//  Created by 林翌埕-20001107 on 2023/2/3.
//

import XCTest
@testable import NoodoeInterview

final class BaseCoordinatorTests: XCTestCase {

    func test_coordinator_child_append_and_remove() {
        let sut = MockCoordinator()
        let coordinator = MockCoordinator()
        sut.addDependency(coordinator)
        
        XCTAssertEqual(sut.childCoordinators.map { ($0 as? MockCoordinator)?.uuid }, [coordinator.uuid])
        
        sut.removeDependency(coordinator)
        trackForMemoryLeaks(sut)
        XCTAssertEqual(sut.childCoordinators.map { ($0 as? MockCoordinator)?.uuid }, [])
    }
    
    func test_coordinator_child_append_duplicate_expect_one() {
        let sut = MockCoordinator()
        let coordinator = MockCoordinator()
        sut.addDependency(coordinator)
        sut.addDependency(coordinator)
        sut.addDependency(coordinator)
        sut.addDependency(coordinator)
        
        XCTAssertEqual(sut.childCoordinators.map { ($0 as? MockCoordinator)?.uuid }, [coordinator.uuid])
    }
    
    private class MockCoordinator: BaseCoordinator {
        let uuid: UUID
        override init() {
            self.uuid = UUID()
            super.init()
        }
    }
}
