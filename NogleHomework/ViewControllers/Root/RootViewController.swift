//
//  RootViewController.swift
//  NogleHomework
//
//  Created by Tseng Han Teng on 2023/8/1.
//

import UIKit
import SnapKit

class RootViewController: UIViewController {
    static func create() -> RootViewController {
        return RootViewController()
    }
    
    let vm = RootViewModel()
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    lazy var statusBarHeight: CGFloat = {
        var statusBarHeight: CGFloat = 0.0
        
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        
        return statusBarHeight
    }()
    
    private let viewPager = ViewPagerController()
    private var subVCs: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(statusBarHeight + 5)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let myOptions = ViewPagerOptions(viewPagerWithFrame: containerView.bounds)
        myOptions.tabType = ViewPagerTabType.basic
        myOptions.fitAllTabsInView = true
        myOptions.isEachTabEvenlyDistributed = true
        myOptions.isTabHighlightAvailable = true
        myOptions.isTabIndicatorAvailable = true
        myOptions.tabViewBackgroundDefaultColor = .clear
        myOptions.tabViewBackgroundHighlightColor = .clear
        myOptions.tabIndicatorViewHeight = 2
        myOptions.tabIndicatorViewBackgroundColor = .black
        myOptions.tabViewTextDefaultColor = .gray
        myOptions.tabViewTextHighlightColor = .black
        myOptions.tabViewTextFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        myOptions.tabViewTextHighlightFont = UIFont.systemFont(ofSize: 17, weight: .medium)
        myOptions.tabViewHeight = 48

        viewPager.options = myOptions
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.view.frame = view.bounds
        self.addChild(viewPager)
        self.containerView.addSubview(viewPager.view)
        viewPager.didMove(toParent: self)
    }
}

extension RootViewController : ViewPagerControllerDataSource, ViewPagerControllerDelegate
{
    func numberOfPages() -> Int {
        2
    }

    func viewControllerAtPosition(position: Int) -> UIViewController {
        if subVCs.count == 0 {
            let spotVC = SpotViewController.create()
            subVCs.append(spotVC)
            
            let futuresVC = FuturesViewController.create()
            subVCs.append(futuresVC)
        }
        return subVCs[position]
    }

    func tabsForPages() -> [ViewPagerTab] {

        let tabs: [ViewPagerTab] = [ViewPagerTab(title: "Spot", image: nil),
                                    ViewPagerTab(title: "Futures", image: nil)]
        return tabs
    }
}

extension RootViewController {
    func showAlert(title: String? = nil, message: String? = nil, completion: (() -> Void)? = nil, dismiss: (() -> Void)? = nil) {
        self.showAlert(title: title, message: message, style: .alert, actions: nil, completion: completion, dismiss: dismiss)
    }
    
    func showAlert(title: String? = nil, message: String? = nil, style: AlertController.Style, action1: AlertAction, action2: AlertAction, completion: (() -> Void)? = nil, dismiss: (() -> Void)? = nil) {
        self.showAlert(title: title, message: message, style: style, actions: [action1, action2], completion: completion, dismiss: dismiss)
    }
    
    func showAlert(title: String? = nil, message: String? = nil, attributedMessageText: NSMutableAttributedString? = nil, style: AlertController.Style, actions: [AlertAction]? = nil, completion: (() -> Void)?, dismiss: (() -> Void)? = nil) {
        view.endEditing(true)
        
        var alert: AlertController? = nil
        
        switch style {
            case .alert:
                alert = AlertController.alert(title: title, message: message, actions: actions)
            case .actionSheet:
                alert = AlertController.actionSheet(title: title, message: message, actions: actions)
            default:
                break
        }
        
        if let attributedMessageText = attributedMessageText {
            alert?.setValue(attributedMessageText, forKey: "attributedMessage")
        }
        
        if let alert = alert {
            alert.show(completion: completion, dismiss: dismiss)
        }
    }
}
