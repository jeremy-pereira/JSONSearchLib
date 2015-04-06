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

extension JSON
{
    var isSerialisable: Bool
    {
		return NSJSONSerialization.isValidJSONObject(self)
    }
}

class TestJSONObjects: XCTestCase
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
        // Put teardown code here. This method is called after the invocation of
        // each test method in the class.
        super.tearDown()
    }

    func testGetChild()
    {
        if let q039 = theJSON["Q039"]
        {
			if let rules = q039["rules"]
            {
				if let secondRule = rules[1]
                {
                    // Hooray
                }
                else
                {
                    XCTFail("Failed to get rule[1]")
                }
            }
            else
            {
                XCTFail("Failed to get rules from Q039")
            }
        }
        else
        {
            XCTFail("Failed to get Q039 from the JSON")
        }
    }

    func testGetParent()
    {
        let q039 = theJSON["Q039"]
        let rules = theJSON["Q039"]!["rules"]
        XCTAssert(rules!.parent === q039!, "Q039 is not the parent of rules")
    }

    func testGetBool()
    {
        if let aBool = theJSON["TestStuff"]?["aBool"] as? JSONBool
        {
            XCTAssert(aBool, "aBool should be true")
        }
        else
        {
            XCTFail("Didn't find aBool or it's not a JSONBool")
        }
        if let aBool = theJSON["TestStuff"]?["anotherBool"] as? JSONBool
        {
            XCTAssert(!aBool, "aBool should be true")
        }
        else
        {
            XCTFail("Didn't find anotherBool or it's not a JSONBool")
        }
    }

    func testGetNumber()
    {
        if let aNumber = theJSON["TestStuff"]?["aNumber"] as? JSONNumber
        {
            XCTAssert(aNumber.number.compare(NSNumber(integer: 10)) == NSComparisonResult.OrderedSame, "Got the wrong number")
        }
        else
        {
            XCTFail("Didn't find aNumber or it's not a JSONNumber")
        }
    }
    func testGetString()
    {
        if let aString = theJSON["Q017"]?["page"] as? JSONString
        {
            XCTAssert(aString.string == "4", "Got the wrong number")
        }
        else
        {
            XCTFail("Didn't find @017.page or it's not a JSONString")
        }
    }

    func testGetNull()
    {
        let aNull = theJSON["TestStuff"]?["null"] as? JSONNull
        XCTAssert(aNull != nil, "Didn't find the null object")
    }

    func testSave()
    {
        let someResults = theJSON ** "error"
        let someJson = someResults.toJSONArray()
        let data = someJson.toData(prettyPrint: true)
        println("\(someJson)")
    }
}
