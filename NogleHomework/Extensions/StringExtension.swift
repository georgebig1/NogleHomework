//
//  StringExtension.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/3.
//

import Foundation

extension String {
    func jsonToDictionary() -> [String:Any]? {
        let data = self.data(using: .utf8)!
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any] {
                return jsonObject
            }
        } catch {
            return nil
        }
        return nil
    }
}
