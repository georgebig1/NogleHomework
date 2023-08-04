//
//  ErrorHandler.swift
//  NogleHomework
//
//  Created by George Tseng on 2023/8/2.
//

import UIKit

class ErrorHandler {
    static func handle(_ error: Error, completion:(() -> Void)? = nil) {
        let err = error as NSError
        let msg = err.userInfo["message"] as? String ?? "Unknown Error"
        AppRuntime.rootViewController?.showAlert(title: "Error: \(err.code)", message: msg)
    }
}
