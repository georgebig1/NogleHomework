//
//  Record.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/1.
//

import Foundation

struct Record: JSONCodable {
    let future: Bool
    let symbol: String
    var price: Double?
}
