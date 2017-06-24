//
//  LinuxCompatibility.swift
//  SourceKitten
//
//  Created by JP Simard on 8/19/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Foundation

#if os(Linux)
    #if !swift(>=3.1)
        public typealias Process = Task
        public typealias NSRegularExpression = RegularExpression
    #endif

    extension CharacterSet {
        public func bridge() -> NSCharacterSet {
            return _bridgeToObjectiveC()
        }
    }
    #if !swift(>=3.1)
        extension NSString {
            public var isAbsolutePath: Bool { return absolutePath }
        }
    #endif
    extension Dictionary {
        public func bridge() -> NSDictionary {
            return NSDictionary(dictionary: self)
        }
    }
    extension Array {
        public func bridge() -> NSArray {
            return NSArray(array: self)
        }
    }
    extension String {
        public func bridge() -> NSString {
            return NSString(string: self)
        }
    }
    extension NSString {
        public func bridge() -> String {
            return _bridgeToSwift()
        }
    }
#else
    extension CharacterSet {
        public func bridge() -> NSCharacterSet {
            return self as NSCharacterSet
        }
    }
    extension Dictionary {
        public func bridge() -> NSDictionary {
            return self as NSDictionary
        }
    }
    extension Array {
        public func bridge() -> NSArray {
            return self as NSArray
        }
    }
    extension String {
        public func bridge() -> NSString {
            return self as NSString
        }
    }
    extension NSString {
        public func bridge() -> String {
            return self as String
        }
    }
    #if !swift(>=4.0)
        extension NSTextCheckingResult {
            func range(at idx: Int) -> NSRange {
                return rangeAt(idx)
            }
        }
    #endif

#endif
