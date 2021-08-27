//
//  InterAppFrameworkTests.swift
//  InterAppFrameworkTests
//
//  Created by Александр Соломатов on 10/10/2018.
//  Copyright © 2018 Александр Соломатов. All rights reserved.
//

import XCTest
@testable import InterAppFramework

class InterAppFrameworkTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDataArchiving() {
        let commandInput = IACommand.Input(.CheckService)
        
        guard let data = try? commandInput.archiveData() else { fatalError("Can't archive data!") }
        XCTAssertNotNil(data, "Data is nil")
        
        let dictData = NSKeyedArchiver.archivedData(withRootObject: data)
        XCTAssertNotNil(dictData, "Dict is nil")        
        
        if let outDictData = NSKeyedUnarchiver.unarchiveObject(with: dictData) as? Data {
            XCTAssertNotNil(outDictData, "Data is nil")
            
            if let commandOutput = IACommand.unarchiveObject(fromData: outDictData) {
                debugPrint("COMMAND", commandOutput)
                XCTAssertEqual(commandInput, commandOutput, "The values are not equal!")
            }
        }
    }
}
