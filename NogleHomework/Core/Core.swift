//
//  Core.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/2.
//

import RxCocoa
import RxSwift
import Foundation

enum SortType {
    case nameAscending
    case nameDescending
    case priceAscending
    case priceDescending
}

class Core: NSObject {
    static let shared = Core()
    private(set) var apiHelper: ApiProtocol
    let disposeBag = DisposeBag()
    
    private(set) var allMarketList = [MarketRecord]()
    private(set) var spotList = BehaviorRelay<[MarketRecord]>(value: [])
    private(set) var futuresList = BehaviorRelay<[MarketRecord]>(value: [])
    private(set) var updateedMarketData = BehaviorRelay<JsonObject>(value: JsonObject())
    
    let socket: SocketClient = SocketClient()
    
    init(apiHelper: ApiProtocol = ApiClient()) {
        self.apiHelper = apiHelper
    }
    
    func getMarketData() -> Completable {
        return apiHelper.getMarketData().do(onSuccess: {[weak self] response in
            guard let self = self else { return }
            
            self.allMarketList = response.data
            var spot = [MarketRecord]()
            var futures = [MarketRecord]()
            
            self.allMarketList.forEach { record in
                if record.future {
                    futures.append(record)
                }
                else {
                    spot.append(record)
                }
            }
            
            self.spotList.accept(spot)
            self.futuresList.accept(futures)
        }).asCompletable()
    }
    
    func updateMarket(List: [MarketRecord]) {
        self.allMarketList = List
    }
    
    func sortList(_ list: [MarketRecord], type: SortType) -> [MarketRecord] {
        switch type {
        case .nameAscending:
            return list.sorted(by: { $0.symbol < $1.symbol })
        case .nameDescending:
            return list.sorted(by: { $0.symbol > $1.symbol })
        case .priceAscending:
            return list.sorted(by: { ($0.price ?? 0) < ($1.price ?? 0) })
        case .priceDescending:
            return list.sorted(by: { ($0.price ?? 0) > ($1.price ?? 0) })
        }
    }
}
