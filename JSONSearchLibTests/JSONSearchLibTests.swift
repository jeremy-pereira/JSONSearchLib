//
//  JSONSearchLibTests.swift
//  JSONSearchLibTests
//
//  Created by Jeremy Pereira on 03/04/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa
import XCTest
import JSONSearchLib

class JSONSearchLibTests: XCTestCase
{
    var testFileName: String = ""
    override func setUp()
    {
        super.setUp()

        let theBundle = NSBundle(forClass: JSONSearchLibTests.self)
        if let resourcePath = theBundle.pathForResource("s10rules_england_en", ofType: "json")
        {
            testFileName = resourcePath
        }
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadJSON()
    {
        var error: JSONError?

        var someJson: JSON? = JSON.load(fileName: testFileName, error: &error)
        XCTAssert(someJson != nil, "Failed to load the JSON, reason \(error?.message)")

    }
    
    func testPerformanceExample()
    {
        // This is an example of a performance test case.
        self.measureBlock()
        {
            // Put the code you want to measure the time of here.
        }
    }
    
}
