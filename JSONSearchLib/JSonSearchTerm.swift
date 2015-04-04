//
//  JSonSearchTerm.swift
//  JSONSearch
//
//  Created by Jeremy Pereira on 03/04/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Foundation

public protocol Searchable
{
    func search(key: String, recursive: Bool) -> ResultSet;
}

public class ResultSet: Searchable
{
    private var results: [JSON] = []

    public var count: Int { return results.count }

    func append(aThing: JSON)
    {
        results.append(aThing)
    }

    func append(someResults: ResultSet)
    {
        results += someResults.results
    }

    public func search(key: String, recursive: Bool = false) -> ResultSet
    {
        var ret = ResultSet()
        for anObject in results
        {
            ret.append(anObject.search(key, recursive: recursive))
        }
        return ret
    }
}

public class JSONSearch
{

}

public class JSONSearchTerm
{

}
