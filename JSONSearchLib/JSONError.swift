//
//  JSONError.swift
//  JSONSearch
//
//  Created by Jeremy Pereira on 03/04/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Foundation

public class JSONError: Printable
{
    private var _message: String
    private var _nsError: NSError?

    public var message: String { return _message }
    public var nsError: NSError? { return _nsError }

    public init(message: String)
    {
		self._message = message
    }

    public convenience init(nsError: NSError)
    {
        self.init(message: nsError.localizedDescription as String)
        _nsError = nsError
    }

    public var description: String
    {
		return message
    }
}
