//
//  SingleExtension.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/2.
//

import RxSwift
import RxCocoa

extension PrimitiveSequenceType where Trait == SingleTrait {
    public func subscribeSuccess(_ callback:((Element) -> Void)? = nil) -> Disposable {
        return subscribe(onSuccess: {
            callback?($0)
        }, onFailure: {
            ErrorHandler.handle($0)
        })
    }

    public func subscribeOn(success successCallback:((Element) -> Void)? = nil,
                            failure failureCallback:((Swift.Error) -> Void)? = nil,
                            finished finishCallback:(() -> Void)? = nil) -> Disposable {
        return subscribe(onSuccess: {
            finishCallback?()
            successCallback?($0)
        }, onFailure: {
            finishCallback?()
            guard let customFailureCallback = failureCallback else {
                ErrorHandler.handle($0)
                return
            }
            customFailureCallback($0)
        })
    }
    
    public func subscribeSuccess<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, Self.Element == Observer.Element {
        return  subscribeSuccess(observer.onNext)
    }
    
}
