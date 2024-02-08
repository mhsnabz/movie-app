//
//  ClassNameProtocol.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import Foundation
public protocol ClassNameProtocol {
    static var classname: String { get }
    var classname: String { get }
}

public extension ClassNameProtocol {
    static var classname: String {
        return String(describing: self)
    }

    var classname: String {
        return type(of: self).classname
    }
}

extension NSObject: ClassNameProtocol {
    public static var classname: String { return String(describing: self) }
}
