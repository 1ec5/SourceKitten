//
//  JSONOutput.swift
//  SourceKitten
//
//  Created by Thomas Goyne on 9/17/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

public func declarationsToJSON(decl: [String: [SourceDeclaration]]) -> String {
    return toJSON([decl.map(toOutputDictionary)])
}

extension Dictionary {
    func map<T>(block: Value -> T) -> [Key: T] {
        var ret = [Key: T]()
        for (key, value) in self {
            ret[key] = block(value)
        }
        return ret
    }
}

private func toOutputDictionary(decl: SourceDeclaration) -> [String: AnyObject] {
    var dict = [String: AnyObject]()
    func set(key: SwiftDocKey, _ value: AnyObject?) {
        if let value = value {
            dict[key.rawValue] = value
        }
    }
    func setA(key: SwiftDocKey, _ value: [AnyObject]) {
        if value.count > 0 {
            dict[key.rawValue] = value
        }
    }

    set(.Kind, decl.type?.rawValue)
    set(.FilePath, decl.location.file)
    set(.DocFile, decl.location.file)
    set(.DocLine, String(decl.location.line))
    set(.DocColumn, String(decl.location.column))
    set(.Name, decl.name)
    set(.DocUSR, decl.usr)
    set(.ParsedDeclaration, decl.declaration)

    setA(.DocumentationComment, decl.discussion.map(toOutputDictionary))
    setA(.DocResultDiscussion, decl.returnDiscussion.map(toOutputDictionary))

    setA(.DocParameters, decl.parameters.map(toOutputDictionary))
    setA(.Substructure, decl.children.map(toOutputDictionary))

    set(.FullXMLDocs, "")

    return dict
}

private func toOutputDictionary(decl: [SourceDeclaration]) -> [String: AnyObject] {
    return ["key.substructure": decl.map(toOutputDictionary), "key.diagnostic_stage": ""]
}

private func toOutputDictionary(param: Parameter) -> [String: AnyObject] {
    return ["name": param.name, "discussion": param.discussion.map(toOutputDictionary)]
}

private func toOutputDictionary(text: Text) -> [String: AnyObject] {
    switch text {
    case .Para(let str, let kind):
        return ["kind": kind ?? "", "Para": str]
    }
}
