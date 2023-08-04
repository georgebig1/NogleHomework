//
//  ApiProtocol.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/2.
//

import Foundation
import RxSwift
import RxCocoa

protocol ApiProtocol {
    func getMarketData() -> Single<Response<Record>>
}
