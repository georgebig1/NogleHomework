//
//  RootViewModel.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/2.
//

import RxCocoa
import RxSwift

class RootViewModel {
    private let core: Core
    private let disposeBag = DisposeBag()
    
    init(mCore: Core = Core.shared) {
        core = mCore
        core.getMarketData().subscribeSuccess {[weak self] in
            guard let self = self else { return }
            
            self.core.initSocket()
            self.core.socket.socketConnected.subscribeSuccess {
                self.core.subscribeCoinIndex()
            }.disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
}
