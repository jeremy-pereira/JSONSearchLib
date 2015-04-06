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
    func search(key: String, recursive: Bool) -> ResultSet
    func search(index: Int) -> ResultSet
    func search(wildCard: WildCard) -> ResultSet
}

public class ResultSet: Searchable
{
    private var results: [JSON] = []

    public var count: Int { return results.count }

    // MARK: Append various things to a result set

    func append(aThing: JSON)
    {
        results.append(aThing)
    }

    func append(someResults: ResultSet)
    {
        self.append(someResults.results)
    }

    func append(someResults: [JSON])
    {
        results += someResults
    }

    // MARK: Searchable protocol

    public func search(key: String, recursive: Bool = false) -> ResultSet
    {
        var ret = ResultSet()
        for anObject in results
        {
            ret.append(anObject.search(key, recursive: recursive))
        }
        return ret
    }

    public func search(index: Int) -> ResultSet
    {
        var ret = ResultSet()
        for anObject in results
        {
            ret.append(anObject.search(index))
        }
        return ret
    }

    public func search(wildCard: WildCard) -> ResultSet
    {
        var ret = ResultSet()
        for anObject in results
        {
            ret.append(anObject.search(wildCard))
        }
        return ret
    }

    public func toJSONArray() -> JSONArray
    {
        return JSONArray(results, parent: nil)
    }
}

public enum WildCard
{
    case Everything
}

// Operators

public func / (left: Searchable, right: String) -> ResultSet
{
    return left.search(right, recursive: false)
}

public func / (left: Searchable, right: Int) -> ResultSet
{
    return left.search(right)
}

infix operator **
{
	associativity left
	precedence 150
}

public func ** (left: Searchable, right: String) -> ResultSet
{
    return left.search(right, recursive: true)
}

postfix operator * {}

public postfix func * (operand: Searchable) -> ResultSet
{
	return operand.search(WildCard.Everything)
}
