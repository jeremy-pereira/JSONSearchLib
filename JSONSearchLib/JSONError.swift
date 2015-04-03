//
//  JSONError.swift
//  JSONSearch
//
//  Created by Jeremy Pereira on 03/04/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Foundation

public class JSONError
{
    private var _message: String
    private var _nsError: NSError?

    public var message: String { return _message }

    public init(message: String)
    {
		self._message = message
    }

    public convenience init(nsError: NSError)
    {
        self.init(message: nsError.localizedDescription as String)
        _nsError = nsError
    }
}
