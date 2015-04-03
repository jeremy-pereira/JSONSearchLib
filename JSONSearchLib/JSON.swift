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
    private var jsonObject: AnyObject

    public init(jsonObject: AnyObject)
    {
        self.jsonObject = jsonObject
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
                ret = JSON(jsonObject: jsonObject)
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

}