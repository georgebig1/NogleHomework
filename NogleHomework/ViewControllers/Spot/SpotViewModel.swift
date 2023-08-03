//
//  SpotViewModel.swift
//  NogleHomework
//
//  Created by Tseng Han Teng on 2023/8/2.
//

import RxCocoa
import RxSwift

class SpotViewModel {
    private let core: Core
    private let disposeBag = DisposeBag()
    private var sortType: SortType = .nameAscending
    
    var spotList: BehaviorRelay<[Record]> = BehaviorRelay(value: [])
    
    init(mCore: Core = Core.shared) {
        core = mCore
        let _ = core.spotList.subscribeSuccess {[weak self] records in
            guard let self = self else { return }
            self.spotList.accept(self.core.sortList(records, type: sortType))
        }.disposed(by: disposeBag)
    }
    
    func toggleNameSorting() {
        sortType = sortType == .nameAscending ? .nameDescending : .nameAscending
        sortSpot()
    }
    
    func togglePriceSorting() {
        sortType = sortType == .priceAscending ? .priceDescending : .priceAscending
        sortSpot()
    }
    
    func sortSpot() {
        let futures = core.allMarketList.filter({ !$0.future })
        let sorted = self.core.sortList(futures, type: sortType)
        self.spotList.accept(sorted)
    }
}
