//
//  MarketRecord.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/1.
//

import Foundation

struct MarketRecord: JSONCodable {
    let future: Bool
    let symbol: String
    var price: Double?
}
