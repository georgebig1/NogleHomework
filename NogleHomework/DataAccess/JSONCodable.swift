//
//  JSONCodable.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/2.
//

import Foundation

public protocol JSONCodable: Codable {
    func toDictionary() -> JsonObject?
    init?(json: JsonObject)
}

extension JSONCodable {
    public func toDictionary() -> JsonObject? {
        // Encode the data
        if let jsonData = try? JSONEncoder().encode(self),
            // Create a dictionary from the data
            let dict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? JsonObject {
            return dict
        }
        return nil
    }
    
    public init?(jsonData: Data) {
        do {
            let object = try JSONDecoder().decode(Self.self, from: jsonData)
            self = object
        } catch let error {
            JSONCodableLog.debug("\n ************* JSONCodable Parser Error Begin *****************\n")
            JSONCodableLog.debug(jsonData)
            JSONCodableLog.debug(error)
            JSONCodableLog.debug("\n ************* JSONCodable Parser Error End *****************\n")
            return nil
        }
    }
    
    public init?(json: JsonObject) {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            let object = try JSONDecoder().decode(Self.self, from: data)
            self = object
        } catch let error {
            JSONCodableLog.debug("\n ************* JSONCodable Parser Error Begin *****************\n")
            JSONCodableLog.debug(json)
            JSONCodableLog.debug(error)
            JSONCodableLog.debug("\n ************* JSONCodable Parser Error End *****************\n")
            return nil
        }
    }
    
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

struct JSONCodableLog {
    static func debug<T>(_ message:T, file:String = #file, function:String = #function, line:Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("[Debug] [\(fileName)] [\(line)] [\(function)] \(message)")
        #endif
    }
}
