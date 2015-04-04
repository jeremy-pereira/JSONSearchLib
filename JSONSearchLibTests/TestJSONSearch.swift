//
//  TestJSONSearch.swift
//  JSONSearch
//
//  Created by Jeremy Pereira on 04/04/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa
import XCTest
import JSONSearchLib

class TestJSONSearch: XCTestCase
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
            if let someJSON = someJSON
            {
                theJSON = someJSON
            }
            else
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
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSimpleKeySearch()
    {
        let results = theJSON.search("Q039")
        XCTAssert(results.count == 1, "Failed to get the right number of results")
    }

    func testRecursiveKeySearch()
    {
        let results = theJSON.search("error", recursive: true)
        XCTAssert(results.count == 118, "Failed to get the right number of results, \(results.count)")
    }


    func testChainedKeySearch()
    {
        let results = theJSON.search("Q054").search("error", recursive: true)
        XCTAssert(results.count == 2, "Failed to get the right number of results, \(results.count)")
    }


    func testPerformanceExample()
    {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}