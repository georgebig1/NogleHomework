//
//  UIAlertControllerExtension.swift
//  NogleHomework
//
//  Created by Tseng Han Teng on 2023/8/2.
//

import Foundation
import UIKit

private class AlertViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        guard let rootViewController = AppRuntime.rootViewController else {
            return super.prefersStatusBarHidden
        }
        
        return rootViewController.prefersStatusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let rootViewController = AppRuntime.rootViewController else {
            return super.preferredStatusBarStyle
        }
        
        return rootViewController.preferredStatusBarStyle
    }
}

private class AlertWindow: UIWindow {
    static let shared = AlertWindow(frame: UIScreen.main.bounds)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.windowLevel = .alert
        self.backgroundColor = .clear
        
        let baseViewController = AlertViewController()
        baseViewController.view.backgroundColor = .clear
        
        self.rootViewController = baseViewController
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let viewHit = super.hitTest(point, with: event) else {
            return nil
        }
        
        if viewHit == self {
            return nil
        } else if let rootViewController = self.rootViewController, viewHit == rootViewController.view {
            return nil
        }
        
        return viewHit
    }
}

class AlertAction: UIAlertAction {
    public static func normal(title: String, handler: ((UIAlertAction) -> Void)?) -> AlertAction {
        return AlertAction(title: title, style: .default, handler: handler)
    }
    
    public static func cancel(title: String, handler: ((UIAlertAction) -> Void)?) -> AlertAction {
        return AlertAction(title: title, style: .cancel, handler: handler)
    }
}

class AlertController: UIAlertController {
    var completionHandler: (() -> Void)? = nil
    var dismissHandler: (() -> Void)? = nil
    
    static func alert(title: String?, message: String?, actions: [AlertAction]? = nil) -> AlertController {
        let alert = AlertController.init(title: title, message: message, preferredStyle: .alert)
        
        if let actions = actions, actions.count > 0 {
            for action in actions {
                alert.addAction(action)
            }
        }
        
        return alert
    }
    
    static func actionSheet(title: String?, message: String?, actions: [AlertAction]? = nil) -> AlertController {
        let actionSheet = AlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        
        if let actions = actions, actions.count > 0 {
            for action in actions {
                actionSheet.addAction(action)
            }
        }
        
        return actionSheet
    }
    
    func show(completion: (() -> Void)? = nil, dismiss: (() -> Void)? = nil) {
        self.completionHandler = completion
        self.dismissHandler = dismiss
        
        if self.actions.count == 0 {
            self.addAction(AlertAction.normal(title: "OK", handler: nil))
        }
        
        UIApplication.topViewController()?.present(self, animated: true) {
            if let completion = self.completionHandler {
                completion()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AlertWindow.shared.isHidden = true
        
        if let dismiss = self.dismissHandler {
            dismiss()
        }
    }
}
