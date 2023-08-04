//
//  Core.Socket.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/3.
//

import RxCocoa
import RxSwift
import Foundation

extension Core {
    private static var socketDispoeBag = DisposeBag()
    private static var subscribedTopics: Set<String> = Set<String>()
    private static var newCommand: PublishRelay<SocketCommand> = PublishRelay()
    
    func initSocket() {
        socket.delegate = self
        connectSocket()
    }
    
    func disconnectSocket() {
        Core.socketDispoeBag = DisposeBag()
        socket.disconnect()
    }
    
    func connectSocket() {
        self.bindSocketAction()
        self.socket.connect()
    }
    
    func subscribeCoinIndex() {
        self.subscribe(topicType: .coinIndex)
    }
}

private extension Core {
    
    func bindSocketAction() {
        print("[ LOG ] socket action binding")
        Core.socketDispoeBag = DisposeBag()
        Core.newCommand.subscribeSuccess { [unowned self] (command) in
            guard let json = command.json else {
                return
            }
            print("[ LOG ] socket new command ", json)
            self.socket.message.onNext(json)
        }.disposed(by: Core.socketDispoeBag)
        
        self.socket.socketConnected.subscribeSuccess { _ in
            guard Core.subscribedTopics.count > 0 else { return }
            let command = SocketCommand(op: "subscribe", args: Array(Core.subscribedTopics))
            self.sendCommand(command)
        }.disposed(by: Core.socketDispoeBag)
    }
    
    func subscribe(topicType: SocketTopicType) {
        Core.subscribedTopics.insert(topicType.rawValue)
        let command = SocketCommand(op: "subscribe", args: Array(Core.subscribedTopics))
        self.sendCommand(command)
    }
    
    func sendCommand(_ command: SocketCommand) {
        Core.newCommand.accept(command)
        print("[ LOG ] socket.request == \(command.json ?? "")")
    }
}

extension Core: SocketClientDelegate {
    func updateMarcketPrices(_ data: JsonObject) {
        self.updateedMarketData.accept(data)
        
//        print(data)
        var all = self.allMarketList

        for i in 0..<all.count {
            var record = all[i]
            if let item = data["\(record.symbol)_1"] as? JsonObject {
                record.price = (item["price"] as? Double) ?? nil
                all[i] = record
            }
        }

        self.updateMarket(List: all)
        print("[ LOG ] socket done update value")
    }
}
