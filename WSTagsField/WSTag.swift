//  WSTag.swift
//  LTW
//  Created by Ranjeet Raushan on 22/07/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import Foundation

public struct WSTag: Hashable {

    public let text: String

    public init(_ text: String) {
        self.text = text
    }

    public func equals(_ other: WSTag) -> Bool {
        return self.text == other.text
    }

}

public func == (lhs: WSTag, rhs: WSTag) -> Bool {
    return lhs.equals(rhs)
}
