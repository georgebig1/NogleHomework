//
//  NetworkProtocol.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/2.
//

import Foundation
import Alamofire

public enum HttpBodyEncoding {
    case UrlEnconing
    case JsonEncoding
}

public enum MimeType:String {
    case Image = "image/jpeg"
    case Audio = "audio/mpeg3"
}

public enum Result<T> {
    case success(T)
    case error(Error)
}

public protocol NetworkProtocol {
    func request(
        _ url: URL,
        method: HTTPMethod,
        parameters: [String: Any]?,
        timeoutInterval: TimeInterval,
        encoding: HttpBodyEncoding?,
        headers: [String: String]?,
        completion: @escaping (Result<Json>) -> Void)
        -> Void
}


public typealias JsonObject = [String: Any]

public enum Json {
    case object(_: JsonObject)
    case array(_: [JsonObject])
    
    init?(json: Data) {
        do {
            if let object = try JSONSerialization.jsonObject(with: json) as? JsonObject {
                self = .object(object)
                return
            }
            
            if let array = try JSONSerialization.jsonObject(with: json) as? [JsonObject] {
                self = .array(array)
                return
            }
        } catch {
            return nil
        }
        
        return nil
    }
    
    init?(json: Any) {
        if let object = json as? JsonObject {
            self = .object(object)
            return
        }
        
        if let array = json as? [JsonObject] {
            self = .array(array)
            return
        }
        
        return nil
    }
}
