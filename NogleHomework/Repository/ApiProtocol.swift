//
//  ApiProtocol.swift
//  NogleHomework
//
//  Created by Tseng Han Teng on 2023/8/2.
//

import Foundation
import RxSwift
import RxCocoa

protocol ApiProtocol {
    func getMarketData() -> Single<Response<Record>>
}
