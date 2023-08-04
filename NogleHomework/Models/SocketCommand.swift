//
//  SocketCommand.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/3.
//

import Foundation

struct SocketCommand: JSONCodable {
    let op: String
    let args: [String]
}
