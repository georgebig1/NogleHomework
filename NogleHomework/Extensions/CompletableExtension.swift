//
//  CompletableExtension.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/2.
//

import RxCocoa
import RxSwift

extension PrimitiveSequenceType where Trait == CompletableTrait, Element == Swift.Never {
    public func subscribeSuccess(_ callback:(() -> Void)? = nil) -> Disposable {
        return subscribe(onCompleted: {
            callback?()
        }, onError: {
            ErrorHandler.handle($0)
        })
    }
    
    public func subscribeOn(completed completedCallback:(() -> Void)? = nil,
                            error errorCallback:((Swift.Error) -> Void)? = nil,
                            finished finishCallback:(() -> Void)? = nil) -> Disposable {
        return subscribe(onCompleted: {
            finishCallback?()
            completedCallback?()
        }, onError: {
            finishCallback?()
            guard let customErrorCallback = errorCallback else {
                ErrorHandler.handle($0)
                return
            }
            customErrorCallback($0)
        })
    }
}
