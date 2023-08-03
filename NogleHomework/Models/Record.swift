//
//  Record.swift
//  NogleHomework
//
//  Created by Tseng Han Teng on 2023/8/1.
//

import Foundation

struct Record: JSONCodable {
    let future: Bool
    let symbol: String
    var price: Double?
}
