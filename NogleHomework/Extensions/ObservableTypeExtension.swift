//
//  ObservableTypeExtension.swift
//  NogleHomework
//
//  Created by Tseng Han Teng on 2023/8/2.
//

import RxCocoa
import RxSwift

extension ObservableType {
    public func subscribeSuccess(_ callback:((Element) -> Void)?) -> Disposable {
        return subscribe(onNext: {
            callback?($0)
        }, onError: {
            ErrorHandler.handle($0)
        })
    }
    
    public func subscribeOn(next nextCallback:((Element) -> Void)? = nil,
                            error errorCallback:((Swift.Error) -> Void)? = nil,
                            finished finishCallback:(() -> Void)? = nil) -> Disposable {
        return subscribe(onNext: {
            finishCallback?()
            nextCallback?($0)
        }, onError: {
            finishCallback?()
            guard let customErrorCallback = errorCallback else {
                ErrorHandler.handle($0)
                return
            }
            customErrorCallback($0)
        })
    }
    
    public func subscribeSuccess<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, Self.Element == Observer.Element {
        return  subscribeSuccess(observer.onNext)
        
    }
    public func subscribeSuccess<Element>(_ observer: BehaviorRelay<Element>) -> Disposable where Self.Element == Element {
        return  subscribeSuccess(observer.accept)
    }
    
    func withPrevious(startWith first: Element) -> Observable<(Element, Element)> {
        return scan((first, first)) { ($0.1, $1) }.skip(1)
    }
}
