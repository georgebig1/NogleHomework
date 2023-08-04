//
//  NetworkImp.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/2.
//

import Foundation
import Alamofire

struct Code53RequestInterceptor: RequestInterceptor {
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let errorCode = (error as NSError).code
        
        
        guard request.retryCount < 3 && errorCode == 53 else {
            completion(.doNotRetryWithError(error))
            return
        }
        print("🚧retrying, URLSession error")
        completion(.retryWithDelay(0.5))
    }
}

public class NetworkImp: NSObject, NetworkProtocol {
    private var sessionManager: Session!
    
    override init() {
        super.init()
        self.sessionManager = Alamofire.Session.default
    }
    
    public func request(_ url: URL, method: HTTPMethod, parameters: [String : Any]? = nil, timeoutInterval: TimeInterval, encoding: HttpBodyEncoding?, headers: [String : String]? = nil, completion: @escaping (Result<Json>) -> Void) {
        let httpHeaders = HTTPHeaders.init(headers ?? [:])
        var e: ParameterEncoding = URLEncoding.default
        if let encoding = encoding {
            switch encoding {
            case .UrlEnconing:
                e = URLEncoding.default
            case .JsonEncoding:
                e = JSONEncoding.default
            }
        }
        
        self.sessionManager.request(url, method: method, parameters: parameters, encoding: e, headers: httpHeaders, interceptor: Code53RequestInterceptor())
            .validate(statusCode: 200..<400)
            .responseData { response in
                switch response.result {
                case .success(let value):
                    guard let result = Json(json: value) else {
                        completion(.error(response.error!))
                        return
                    }
                    completion(.success(result))
                case .failure(let err):
                    completion(.error(err))
                }
            }
    }
}
