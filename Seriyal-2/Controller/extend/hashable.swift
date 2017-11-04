//
//  hashable.swift
//  Seriyal-2
//
//  Created by Zsolt Nagy on 2017. 11. 04..
//  Copyright © 2017. Zsolt Nagy. All rights reserved.
//

import Foundation

open class HashableClass {
    public init() {}
}

// MARK: - <Hashable>

extension HashableClass: Hashable {
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
}

// MARK: - <Equatable>

extension HashableClass: Equatable {}
public func ==(lhs: HashableClass, rhs: HashableClass) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
