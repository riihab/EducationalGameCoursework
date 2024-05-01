//
//  LevelViewControllerTests.swift
//  Education Game CW Tests
//
//  Created by Rihab Mehboob on 03/01/2024.
//

import XCTest
@testable import Education_Game_CW

final class LevelViewControllerTests: XCTestCase {

    var viewcontroller: LevelViewController! = nil
    
    override func setUpWithError() throws {
        viewcontroller = LevelViewController()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCheckTimerAmount() throws {
        XCTAssertTrue(viewcontroller.totalTime == 60, 
                      "The timer should start at 60: \(viewcontroller.totalTime)")
    }
    
    func testGameOver() throws {
        viewcontroller.totalTime = 1
        viewcontroller.fireTimer()
        XCTAssertTrue(viewcontroller.totalTimer.isValid == false, 
                      "The timer should be invalid: \(viewcontroller.totalTimer.isValid)")
    }

}
