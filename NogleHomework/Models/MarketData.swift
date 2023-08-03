//
//  Response.swift
//  NogleHomework
//
//  Created by Tseng Han Teng on 2023/8/1.
//

import Foundation

struct Response<T: JSONCodable>: JSONCodable {
    let code: Int
    let msg: String
    let time: Int
    let data: [T]
    let success: Bool
}
