//
//  FutureViewModel.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/2.
//

import RxCocoa
import RxSwift

class FutureViewModel {
    private let core: Core
    private let disposeBag = DisposeBag()
    private var sortType: SortType = .nameAscending
    
    var futuresList: BehaviorRelay<[MarketRecord]> = BehaviorRelay(value: [])
    
    init(mCore: Core = Core.shared) {
        core = mCore
        let _ = core.futuresList.subscribeSuccess {[weak self] records in
            guard let self = self else { return }
            self.futuresList.accept(self.core.sortList(records, type: sortType))
        }.disposed(by: disposeBag)
    }
    
    func toggleNameSorting() {
        sortType = sortType == .nameAscending ? .nameDescending : .nameAscending
        sortFutures()
    }
    
    func togglePriceSorting() {
        sortType = sortType == .priceAscending ? .priceDescending : .priceAscending
        sortFutures()
    }
    
    func sortFutures() {
        let futures = core.allMarketList.filter({ $0.future })
        let sorted = self.core.sortList(futures, type: sortType)
        self.futuresList.accept(sorted)
    }
}
