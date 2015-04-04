//
//  JSON.swift
//  JSONSearch
//
//  Created by Jeremy Pereira on 03/04/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Foundation

public class JSON: Searchable
{
    private weak var _parent: JSON?
    public var parent: JSON? { return _parent }

    init(parent: JSON?)
    {
        _parent = parent
    }

    public class func load(#fileName: String, inout error: JSONError?) -> JSON?
    {
        var ret: JSON?
		if let data = loadFile(fileName, error: &error)
        {
            var nsError: NSError?
			if let jsonObject: AnyObject
                = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(),
                                                                 error: &nsError)
            {
                ret = JSON.from(cocoaObject: jsonObject, parent: nil)
            }
            else
            {
                error = JSONError(nsError: nsError!)
            }
        }
        return ret
    }

    class func loadFile(fileName: String, inout error: JSONError?) -> NSData?
    {
        var ret: NSData?

        var nsError: NSError?
        ret = NSData(contentsOfFile: fileName,
                            options: NSDataReadingOptions(),
                              error: &nsError)

        if ret == nil
        {
            error = JSONError(nsError: nsError!)
        }
        return ret
    }

    class func from(#cocoaObject: AnyObject, parent: JSON?) -> JSON
    {
        var ret: JSON
		if let cocoaObject = cocoaObject as? [AnyObject]
        {
            ret = JSONArray(cocoaObject, parent: parent)
        }
        else if let cocoaObject = cocoaObject as? [String : AnyObject]
        {
            ret = JSONObject(cocoaObject, parent: parent)
        }
        else if let cocoaObject = cocoaObject as? String
        {
            ret = JSONString(cocoaObject, parent: parent)
        }
        else if let cocoaObject = cocoaObject as? NSNumber
        {
            println("objCType: \(cocoaObject.objCType)")
            if cocoaObject.isBool
            {
                ret = JSONBool(cocoaObject, parent: parent)
            }
            else
            {
                ret = JSONNumber(cocoaObject, parent: parent)
            }
        }
        else if let cocoaObject = cocoaObject as? NSNull
        {
            ret = JSONNull(parent: parent)
        }
        else
        {
            fatalError("Do not understand \(cocoaObject)")
        }
        return ret
    }

    public subscript(i : String) -> JSON?
    {
		return nil
    }

    public subscript(i : Int) -> JSON?
    {
        return nil
    }

    public func search(key: String, recursive: Bool = false) -> ResultSet
    {
        var ret: ResultSet = ResultSet()

        return ret
    }

    public func search(index: Int) -> ResultSet
    {
        var ret: ResultSet = ResultSet()

        return ret
    }
}

public class JSONArray : JSON
{
    var children: [JSON] = []

    init(_ cocoaObject: [AnyObject], parent: JSON?)
    {
        super.init(parent: parent)
		for anObject in cocoaObject
        {
            children.append(JSON.from(cocoaObject: anObject, parent: self))
        }
    }

    public override subscript(i : Int) -> JSON?
    {
        var ret: JSON?
		if i >= 0 && i < children.count
        {
            ret = children[i]
        }
        return ret
    }

    override public func search(key: String, recursive: Bool = false) -> ResultSet
    {
        var ret: ResultSet = ResultSet()

        if recursive
        {
            for aValue in self.children
            {
                ret.append(aValue.search(key, recursive: true))
            }
        }

        return ret
    }

    override public func search(index: Int) -> ResultSet
    {
        var ret: ResultSet = ResultSet()

        if let theResult = self[index]
        {
            ret.append(theResult)
        }

        return ret
    }
}

public class JSONObject : JSON
{
    var children : [String : JSON] = [:]

    init(_ cocoaObject: [String : AnyObject], parent: JSON?)
    {
        super.init(parent: parent)
        for aKey in cocoaObject.keys
        {
            children[aKey] = JSON.from(cocoaObject: cocoaObject[aKey]!, parent: self)
        }
    }

    override public subscript(i : String) -> JSON?
    {
            return children[i]
    }

    override public func search(key: String, recursive: Bool = false) -> ResultSet
    {
        var ret: ResultSet = ResultSet()

        if let firstResult = self[key]
        {
            ret.append(firstResult)
        }

        if recursive
        {
            for aValue in self.children.values
            {
                ret.append(aValue.search(key, recursive: true))
            }
        }

        return ret
    }

}

public class JSONNumber : JSON
{
    private var value : NSNumber

    init(_ cocoaObject: NSNumber, parent: JSON?)
    {
        value = cocoaObject
        super.init(parent: parent)
    }

    public var number: NSNumber { return value }
}

public class JSONString : JSON
{
    private var value : String

    init(_ cocoaObject: String, parent: JSON?)
    {
        value = cocoaObject
        super.init(parent: parent)
    }

    public var string: String { return value }
}

public class JSONBool : JSON, BooleanType
{
    private var _value : Bool

    init(_ cocoaObject: NSNumber, parent: JSON?)
    {
        _value = cocoaObject.boolValue
        super.init(parent: parent)
    }

    public var boolValue: Bool { return _value }
}


public class JSONNull : JSON
{
}

private let trueNumber = NSNumber(bool: true)
private let falseNumber = NSNumber(bool: false)
private let trueObjCType = String.fromCString(trueNumber.objCType)
private let falseObjCType = String.fromCString(falseNumber.objCType)

extension NSNumber
{
    var isBool: Bool
     {
        get
        {
            var ret: Bool = false
            let myCType = String.fromCString(self.objCType)

            return (self.compare(trueNumber) == NSComparisonResult.OrderedSame &&  myCType == trueObjCType)
               ||  (self.compare(falseNumber) == NSComparisonResult.OrderedSame && myCType == falseObjCType)
        }
    }
}
