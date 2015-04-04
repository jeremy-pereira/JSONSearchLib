//
//  TestJSONSearchObjects.swift
//  JSONSearch
//
//  Created by Jeremy Pereira on 04/04/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa
import XCTest
import JSONSearchLib

class TestJSONSearchObjects: XCTestCase
{

    let resourceName = "s10rules_england_en"
    let resourceExtension  = "json"

    var theJSON : JSON!

    override func setUp()
    {
        super.setUp()
        var testFileName: String
        let theBundle = NSBundle(forClass: JSONSearchLibTests.self)
        if let resourcePath = theBundle.pathForResource(resourceName, ofType: resourceExtension)
        {
            var error: JSONError?
            testFileName = resourcePath
            var someJSON = JSON.load(fileName: testFileName, error: &error)
            if (someJSON == nil)
            {
                fatalError("Cannot find the test JSON, error: \(error)")
            }
        }
        else
        {
            fatalError("Cannot resolve resource path for \(resourceName).\(resourceExtension)")
        }
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of
        // each test method in the class.
        super.tearDown()
    }

    func testGetRoot()
    {
        XCTAssert(false, "Not implemented yet")
    }

    func testGetChild()
    {
        XCTAssert(false, "Not implemented yet")
    }

    func testGetParent()
    {
        XCTAssert(false, "Not implemented yet")
    }

    func testGetRecursiveDescent()
    {
        XCTAssert(false, "Not implemented yet")
    }

    func testWildCard()
    {
        XCTAssert(false, "Not implemented yet")
    }

    func testSubscript()
    {
        XCTAssert(false, "Not implemented yet")
    }

    func testUnion()
    {
        XCTAssert(false, "Not implemented yet")
    }

}
