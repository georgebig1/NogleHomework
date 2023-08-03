//
//  ApiClient.swift
//  NogleHomework
//
//  Created by Tseng Han Teng on 2023/8/2.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class ApiClient: NSObject {
    private var baseUrl: String = "https://api.btse.com/futures/api"
    private var networkInteractor: NetworkProtocol = NetworkImp()
    private var headers: [String:String] = [:]
    private let disposeBag = DisposeBag()
    
    init(helper: NetworkProtocol = NetworkImp()) {
        super.init()
        networkInteractor = helper
    }
    
    func request<T: JSONCodable>(_ suffixUrl: String, method: HTTPMethod, parameters: JsonObject? = nil, timeoutInterval: TimeInterval = 60, encoding: HttpBodyEncoding? = .JsonEncoding, header:[String:String]=[:]) -> Single<T> {
        return Single<T>.create(subscribe: { [unowned self] (single) -> Disposable in
            guard let url = URL(string: "\(self.baseUrl)\(suffixUrl)") else {
                let err = NSError(domain: NSCocoaErrorDomain, code: -1, userInfo: ["message":"Invalid API URL = \(self.baseUrl)\(suffixUrl)"])
                single(.failure(err))
                return Disposables.create()
            }
            
            self.networkInteractor.request(url, method: method, parameters: parameters, timeoutInterval: timeoutInterval, encoding: encoding, headers: self.headers.merging(header, uniquingKeysWith: { (_, new) in new }), completion: { (response:Result<Json>) in
                switch response {
                case .success(.object(let value)):
                    print(url)
                    print(value)
                    if let result = T(json: value) {
                        single(.success(result))
                    }
                    else {
                        let err = NSError(domain: NSCocoaErrorDomain, code: -1, userInfo: ["message":"API Json format error = \(suffixUrl)"])
                        single(.failure(err))
                    }
                case .success(.array(let value)):
                    let newValue: [String:Any] = ["data":value]
                    if let result = T(json: newValue) {
                        single(.success(result))
                    }
                    else {
                        let err = NSError(domain: NSCocoaErrorDomain, code: -1, userInfo: ["message":"API Json format error = \(suffixUrl)"])
                        single(.failure(err))
                    }
                case .error(let err):
                    print(url)
                    print(err)
                    let newErr = NSError(domain: NSCocoaErrorDomain, code: -1, userInfo: ["message": err.localizedDescription])
                    single(.failure(newErr))
                }
            })
            return Disposables.create()
        })
    }
}

extension ApiClient: ApiProtocol {
    func getMarketData() -> Single<Response<Record>> {
        let path = ApiDefinition.GET_MARKET_DATA
        return request(path, method: .get)
    }
}
