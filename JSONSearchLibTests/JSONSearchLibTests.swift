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

    let resourceName = "s10rules_england_en"
    let resourceExtension  = "json"
    var testFileName: String = ""

    override func setUp()
    {
        super.setUp()
        let theBundle = NSBundle(forClass: JSONSearchLibTests.self)
        if let resourcePath = theBundle.pathForResource(resourceName, ofType: resourceExtension)
        {
            var error: JSONError?
            testFileName = resourcePath
        }
        else
        {
            fatalError("Cannot resolve resource path for \(resourceName).\(resourceExtension)")
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
        XCTAssert(someJson != nil, "Failed to load the JSON, reason \(error)")

    }

    func testFailedLoadJSON()
    {
        var error: JSONError?

        var someJson: JSON? = JSON.load(fileName: "foobarbuzz.json", error: &error)
        XCTAssert(someJson == nil, "Loaded a non existen file")
        if (someJson == nil)
        {
            XCTAssertNotNil(error,"No error returned")
            if let error = error
            {
                XCTAssertNotNil(error.nsError, "Error doesn't contain an NSError")
                if let nsError = error.nsError
                {
                    let expectedDomain = NSCocoaErrorDomain
                    let expectedCode = NSFileReadNoSuchFileError
                    XCTAssert(nsError.domain == expectedDomain, "Wrong error domain \(nsError.domain), expected \(expectedDomain)")
					XCTAssert(nsError.code == expectedCode, "Wrong error code \(nsError.code), expected \(expectedCode)")
                }
            }
        }
        
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
