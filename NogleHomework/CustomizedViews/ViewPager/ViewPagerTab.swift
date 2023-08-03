//
//  ViewPagerTab.swift
//  ViewPager-Swift
//
//  Created by Nishan on 1/9/17.
//  Copyright © 2017 Nishan. All rights reserved.
//

import Foundation
import UIKit

public enum ViewPagerTabType {
    /// Tab contains text only.
    case basic
    /// Tab contains images only.
    case image
    /// Tab contains image with text. Text is shown at the bottom of the image
    case imageWithText
    /// Tab contains badge with text.
    case textWithBadge
    /// Tab contains red dot with text. 
    case textWithDot
}

public struct ViewPagerTab {
    
    public var title:String!
    public var image:UIImage?
    public var badgeCount: Int?
    public var setDot: Bool?
    
    public init(title:String, image:UIImage?, badgeCount: Int? = nil, setDot: Bool? = nil) {
        self.title = title
        self.image = image
        self.badgeCount = badgeCount
        self.setDot = setDot
    }
}
