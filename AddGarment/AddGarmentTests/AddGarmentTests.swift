//
//  AddGarmentTests.swift
//  AddGarmentTests
//
//  Created by Matthew Ferguson on 8/12/21.
//

import XCTest
@testable import AddGarment
import CoreData
@testable import DataFlowFunnelCD

/// A view that displays one or more lines of read-only text. [...]
/// UITableViewDelegate conformance
class AddGarmentTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testDataCleanErrorLogs() throws {
        DataFlowFunnel.shared.addOperation(XCTestRemoveAllErrorLogOperation())
        sleep(3)
    }

    
    func testDataCleanGarments() throws {
        DataFlowFunnel.shared.addOperation(XCTestRemoveAllGarmentOperation())
        sleep(3)
    }
    
    
    func testBulkDataAdd() throws {
        let testGarmentCollection:[String] = ["apple","orange","zoofruit","banana","stawberry","blueberries","mango","sogood","wannabefruit","green chili","hops"]
        DataFlowFunnel.shared.addOperation(XCTextLoadOperation(initNames: testGarmentCollection))
        sleep(3)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
