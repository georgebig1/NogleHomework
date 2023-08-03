//
//  SocketCommand.swift
//  NogleHomework
//
//  Created by Tseng Han Teng on 2023/8/3.
//

import Foundation

struct SocketCommand: JSONCodable {
    let op: String
    let args: [String]
}
