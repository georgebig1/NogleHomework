//
//  MarketListCellViewModel.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/3.
//

import RxCocoa
import RxSwift

class MarketListCellViewModel {
    private let core: Core
    private let disposeBag = DisposeBag()
    
    var price: BehaviorRelay<Double> = BehaviorRelay(value: 0)
    
    init(mCore: Core = Core.shared, symbol: String) {
        core = mCore
        core.updateedMarketData.subscribeSuccess {[weak self] data in
            guard let self = self else { return }
            
            if let value = data["\(symbol)_1"] as? JsonObject,
               let price = (value["price"] as? Double) {
                self.price.accept(price)
            }
        }.disposed(by: disposeBag)
    }
}
