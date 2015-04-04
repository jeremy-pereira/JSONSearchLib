//
//  JSON.swift
//  JSONSearch
//
//  Created by Jeremy Pereira on 03/04/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Foundation

public class JSON
{
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
                ret = JSON.from(cocoaObject: jsonObject)
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

    class func from(#cocoaObject: AnyObject) -> JSON
    {
        var ret: JSON
		if let cocoaObject = cocoaObject as? [AnyObject]
        {
            ret = JSONArray(cocoaObject)
        }
        else if let cocoaObject = cocoaObject as? [String : AnyObject]
        {
            ret = JSONObject(cocoaObject)
        }
        else if let cocoaObject = cocoaObject as? String
        {
            ret = JSONString(cocoaObject)
        }
        else if let cocoaObject = cocoaObject as? NSNumber
        {
            ret = JSONNumber(cocoaObject)
        }
        else if let cocoaObject = cocoaObject as? NSNull
        {
            ret = JSONNull.null
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
}

public class JSONArray : JSON
{
    var children: [JSON] = []

    init(_ cocoaObject: [AnyObject])
    {
		for anObject in cocoaObject
        {
            children.append(JSON.from(cocoaObject: anObject))
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
}

public class JSONObject : JSON
{
    var children : [String : JSON] = [:]

    init(_ cocoaObject: [String : AnyObject])
    {
        for aKey in cocoaObject.keys
        {
            children[aKey] = JSON.from(cocoaObject: cocoaObject[aKey]!)
        }
    }

    override public subscript(i : String) -> JSON?
    {
            return children[i]
    }

}

public class JSONNumber : JSON
{
    var value : NSNumber

    init(_ cocoaObject: NSNumber)
    {
        value = cocoaObject
    }

}

public class JSONString : JSON
{
    var value : String

    init(_ cocoaObject: String)
    {
        value = cocoaObject
    }
}

public class JSONBool : JSON
{

}


public class JSONNull : JSON
{
	static let null = JSONNull()
}