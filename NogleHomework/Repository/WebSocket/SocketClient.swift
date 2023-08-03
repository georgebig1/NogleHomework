//
//  SocketClient.swift
//  NogleHomework
//
//  Created by Tseng Han Teng on 2023/8/2.
//

import RxCocoa
import RxSwift
import Foundation

public enum SocketTopicType: String {
    case coinIndex = "coinIndex"
}

public enum SocketResponseTopicKey {
    // response
    static let coinIndex = "coinIndex"
}

protocol SocketClientDelegate {
    func updateMarcketPrices(_ data: JsonObject)
}

class SocketClient {
    private var socket: RxWebSocket!
    private var disposeBag = DisposeBag()
    private var urlString: String = "wss://ws.btse.com/ws/futures"
    private var isConnected: Bool = false
    private var pingTimer: Timer?
    let socketConnected = PublishSubject<Void>()
    
    var delegate: SocketClientDelegate?
    var message: ControlProperty<String> {
        socket!.rx.text
    }
    
    func connect() {
        guard self.socket == nil, self.isConnected == false else {
            self.socket.connect()
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        self.socket = RxWebSocket(url: url)
        self.socket.respondToPingWithPong = false
        self.bindSocketEvent()
        self.socket.connect()
    }
    
    private func bindSocketEvent() {
        self.disposeBag = DisposeBag()
        self.socket.rx.text.subscribe(onNext: { [unowned self] (message) in
            if let jsonObject = message.jsonToDictionary(), let result = Json(json: jsonObject) {
                let response = Result.success(result)
                
                print("[ LOG ] socket.respone == ", result)
                switch response {
                case .success(.object(let value)):
                    if let key = value["topic"] as? String, let data = value["data"] as? JsonObject {
                        switch key {
                        case SocketResponseTopicKey.coinIndex:
                            self.delegate?.updateMarcketPrices(data)
                        default:
                            break
                        }
                    }
                default:
                    break
                }
            }
        }).disposed(by: disposeBag)
        
        self.socket.rx.connect.subscribe(onNext:{ [unowned self] in
            NSLog("[ LOG ] socket connect")
            self.isConnected = true
            self.initPingTimer()
            self.socketConnected.onNext(())
        }).disposed(by: disposeBag)

        self.socket.rx.disconnect.subscribe(onNext: { [unowned self] (error) in
            NSLog("[ LOG ] socket disconnect")
            self.isConnected = false
            self.connectRetry()
        }).disposed(by: disposeBag)
    }
    
    func disconnect() {
        self.resetPingTimer()
        self.socket.disconnect()
    }
    
    private func connectRetry() {
        guard self.isConnected == false else {
            return
        }
        
        self.resetPingTimer()
        self.connect()
    }
    
    private func resetPingTimer() {
        self.pingTimer?.invalidate()
    }
    
    private func initPingTimer() {
        self.resetPingTimer()
        
        self.pingTimer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true, block: { [weak self] timer in
            guard let self = self, self.isConnected == true else {
                self?.resetPingTimer()
                return
            }
            
            NSLog("[ LOG ] socket send PING")
            self.socket.write(string: "ping")
        })
    }
}
