//
//  ViewPagerTabView.swift
//  ViewPager-Swift
//
//  Created by Nishan on 1/9/17.
//  Copyright © 2017 Nishan. All rights reserved.
//

import UIKit

public final class ViewPagerTabView: UIView {
    
    internal enum SetupCondition {
        case fitAllTabs
        case distributeNormally
    }

    internal var titleLabel:UILabel?
    internal var imageView:UIImageView?
    internal var badgeLabel:UILabel?
    internal var dotLabel:UILabel?
    
    /*--------------------------
     MARK:- Initialization
     ---------------------------*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*--------------------------
     MARK:- Tab Setup
     ---------------------------*/
    
    /**
     Sets up tabview for ViewPager. The type of tabview is automatically obtained from
     the options passed in this function.
     */
    internal func setup(tab:ViewPagerTab, options:ViewPagerOptions , condition:SetupCondition) {
        
        switch options.tabType {
            
        case ViewPagerTabType.basic:
            setupBasicTab(condition: condition, options: options, tab: tab)
            
        case ViewPagerTabType.image:
            setupImageTab(condition: condition, withText: false,options: options, tab:tab)
            
        case ViewPagerTabType.imageWithText:
            setupImageTab(condition: condition, withText: true, options: options, tab:tab)
        
        case ViewPagerTabType.textWithBadge:
            setupBadgeTab(options: options, tab: tab)
            
        case ViewPagerTabType.textWithDot:
            setupDotTab(options: options, tab: tab)
        }
    }
    
    
    /**
     * Creates tab containing only one label with provided options and add it as subview to this view.
     *
     * Case FitAllTabs: Creates a tabview of provided width. Does not consider the padding provided from ViewPagerOptions.
     *
     * Case DistributeNormally: Creates a tabview. Width is calculated from title intrinsic size. Considers the padding
     * provided from options too.
     */
    fileprivate func setupBasicTab(condition:SetupCondition, options:ViewPagerOptions, tab:ViewPagerTab) {
        
        switch condition {
            
        case .fitAllTabs:
            
            buildTitleLabel(withOptions: options, text: tab.title)
            titleLabel?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            self.addSubview(titleLabel!)
            
        case .distributeNormally:
            
            buildTitleLabel(withOptions: options, text: tab.title)

            // Resetting TabView frame again with the new width
            let currentFrame = self.frame
            let labelWidth = titleLabel!.intrinsicContentSize.width + options.tabViewPaddingLeft + options.tabViewPaddingRight

            let newFrame = CGRect(x: currentFrame.origin.x, y: currentFrame.origin.y, width: labelWidth + options.tabViewEdgeInsets, height: currentFrame.height)
            self.frame = newFrame
            
            // Setting TitleLabel frame
            titleLabel?.frame = CGRect(x: 0, y: 0, width: labelWidth, height: currentFrame.height)
            self.addSubview(titleLabel!)
        }
    }
    
    /**
     * Creates tab containing with label and badge with provided options and add it as subview to this view.
     *
     * Case FitAllTabs: Creates a tabview of provided width. Does not consider the padding provided from ViewPagerOptions.
     *
     * Case DistributeNormally: Creates a tabview. Width is calculated from title intrinsic size. Considers the padding
     * provided from options too.
     */
    fileprivate func setupBadgeTab(options:ViewPagerOptions, tab:ViewPagerTab) {
        
        let badgeWidth = 20.0
        let badgeHeight = 20.0
        let tabWidth = self.frame.size.width

        buildTitleLabel(withOptions: options, text: tab.title)
        let textWidth = titleLabel?.intrinsicContentSize.width ?? 0.0
        let xTextPosition:CGFloat = tabWidth/2 - textWidth/2
        let yTextPosition:CGFloat = 0
        let textHeight = (titleLabel?.intrinsicContentSize.height ?? 0.0) / 4
        titleLabel?.frame = CGRect(x: xTextPosition, y: yTextPosition, width: textWidth, height: self.frame.size.height)
        
        buildBadge(withOptions: options, count: tab.badgeCount ?? 0)
        badgeLabel?.frame = CGRect(x: xTextPosition + textWidth + 2, y: yTextPosition + textHeight, width: badgeWidth, height: badgeHeight)
        
        self.addSubview(badgeLabel!)
        self.addSubview(titleLabel!)
    }
    
    fileprivate func setupDotTab(options:ViewPagerOptions, tab:ViewPagerTab) {
        
        let badgeWidth = 12.0
        let badgeHeight = 12.0
        let tabWidth = self.frame.size.width

        buildTitleLabel(withOptions: options, text: tab.title)
        let textWidth = titleLabel?.intrinsicContentSize.width ?? 0.0
        let xTextPosition:CGFloat = tabWidth/2 - textWidth/2
        let yTextPosition:CGFloat = 0
        let textHeight = (titleLabel?.intrinsicContentSize.height ?? 0.0) / 4
        titleLabel?.frame = CGRect(x: xTextPosition, y: yTextPosition, width: textWidth, height: self.frame.size.height)
        
        buildDot(withOptions: options, setDot: tab.setDot ?? false)
        dotLabel?.frame = CGRect(x: xTextPosition + textWidth + 2, y: yTextPosition + textHeight, width: badgeWidth, height: badgeHeight)
        
        self.addSubview(dotLabel!)
        self.addSubview(titleLabel!)
    }
    
    /**
     * Creates tab containing image or image with text. And adds it as subview to this view.
     *
     * Case FitAllTabs: Creates a tabview of provided width. Doesnot consider padding provided from ViewPagerOptions.
     * ImageView is centered inside tabview if tab type is Image only. Else image margin are used to calculate the position
     * in case of tab type ImageWithText.
     *
     * Case DistributeNormally: Creates a tabView. Width is automatically calculated either from imagesize or text whichever
     * is larger. ImageView is centered inside tabview with provided paddings if tab type is Image only. Considers both padding
     * and image margin incase tab type is ImageWithText.
     */
    fileprivate func setupImageTab(condition:SetupCondition, withText:Bool, options:ViewPagerOptions, tab:ViewPagerTab) {
        
        let imageSize = options.tabViewImageSize
        
        switch condition {
            
        case .fitAllTabs:
            
            let tabHeight = options.tabViewHeight
            let tabWidth = self.frame.size.width
            
            if withText {
                
                // Calculate image position
                let xImagePosition:CGFloat = (tabWidth - imageSize.width) / 2
                let yImagePosition:CGFloat = options.tabViewImageMarginTop
                
                // calculating text position
                let xTextPosition:CGFloat = 0
                let yTextPosition:CGFloat = yImagePosition + options.tabViewImageMarginBottom + imageSize.height
                let textHeight:CGFloat = options.tabViewHeight - yTextPosition - options.tabIndicatorViewHeight
                
                // Creating image view
                buildImageView(withOptions: options, image: tab.image)
                imageView?.frame = CGRect(x: xImagePosition, y: yImagePosition, width: imageSize.width, height: imageSize.height)
                
                // Creating text label
                buildTitleLabel(withOptions: options, text: tab.title)
                titleLabel?.frame = CGRect(x: xTextPosition, y: yTextPosition, width: frame.size.width, height: textHeight)
                
                self.addSubview(imageView!)
                self.addSubview(titleLabel!)
                
            } else {
                
                // Calculate image position
                let xPosition = ( tabWidth - imageSize.width ) / 2
                let yPosition = ( tabHeight - imageSize.height ) / 2
                
                // Creating imageview
                buildImageView(withOptions: options, image: tab.image)
                imageView?.frame = CGRect(x: xPosition, y: yPosition, width: imageSize.width, height: imageSize.height)
                
                self.addSubview(imageView!)
            }
            
            
        case .distributeNormally:
            
            if withText {
                
                // Creating image view
                buildImageView(withOptions: options, image: tab.image)
                
                // Creating text label
                buildTitleLabel(withOptions: options, text: tab.title)
                
                // Resetting tabview frame again with the new width
                let widthFromImage = imageSize.width + options.tabViewPaddingRight + options.tabViewPaddingLeft
                let widthFromText = titleLabel!.intrinsicContentSize.width + options.tabViewPaddingLeft + options.tabViewPaddingRight
                let tabWidth = (widthFromImage > widthFromText ) ? widthFromImage : widthFromText
                let currentFrame = self.frame
                let newFrame = CGRect(x: currentFrame.origin.x, y: currentFrame.origin.y, width: tabWidth, height: currentFrame.height)
                self.frame = newFrame
                
                // Setting imageview frame
                let xImagePosition:CGFloat  = (tabWidth - imageSize.width) / 2
                let yImagePosition:CGFloat = options.tabViewImageMarginTop
                imageView?.frame = CGRect(x: xImagePosition, y: yImagePosition , width: imageSize.width, height: imageSize.height)
                
                // Setting titleLabel frame
                let xTextPosition:CGFloat = 0
                let yTextPosition = yImagePosition + options.tabViewImageMarginBottom + imageSize.height
                let textHeight:CGFloat = options.tabViewHeight - yTextPosition - options.tabIndicatorViewHeight
                titleLabel?.frame = CGRect(x: xTextPosition, y: yTextPosition, width: tabWidth - options.tabViewSpacing, height: textHeight)
                
                self.addSubview(imageView!)
                self.addSubview(titleLabel!)
                
            } else {
                
                // Creating imageview
                buildImageView(withOptions: options, image: tab.image)
                
                // Resetting TabView frame again with the new width
                let currentFrame = self.frame
                let tabWidth = imageSize.width + options.tabViewPaddingRight + options.tabViewPaddingLeft
                let newFrame = CGRect(x: currentFrame.origin.x, y: currentFrame.origin.y, width: tabWidth, height: currentFrame.height)
                self.frame = newFrame
                
                // Setting ImageView Frame
                let xPosition = ( tabWidth - imageSize.width ) / 2
                let yPosition = (options.tabViewHeight - imageSize.height ) / 2
                imageView?.frame = CGRect(x: xPosition, y: yPosition, width: imageSize.width, height: imageSize.height)
                
                self.addSubview(imageView!)
            }
        }        
    }
    
    /*--------------------------
     MARK:- Helper Methods
     ---------------------------*/
    
    fileprivate func buildTitleLabel(withOptions options:ViewPagerOptions, text:String) {
        
        titleLabel = UILabel()
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = options.tabViewTextDefaultColor
        titleLabel?.numberOfLines = 0
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.font = options.tabViewTextFont
        titleLabel?.text = text
        titleLabel?.layer.masksToBounds = true
        titleLabel?.layer.cornerRadius = 5
        titleLabel?.backgroundColor = options.tabViewBackgroundDefaultColor
    }
    

    fileprivate func buildImageView(withOptions options:ViewPagerOptions, image:UIImage?) {
        
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFit
        imageView?.image = image?.withRenderingMode(.alwaysTemplate)
        imageView?.tintColor = options.tabViewTextDefaultColor
    }
    
    fileprivate func buildBadge(withOptions options:ViewPagerOptions, count: Int) {
        
        badgeLabel = UILabel()
        badgeLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        badgeLabel?.textAlignment = .center
        badgeLabel?.text = count > 9 ? "\(9)+" : "\(count)"
        badgeLabel?.isHidden = count == 0
        badgeLabel?.textColor = .white
        badgeLabel?.backgroundColor = UIColor.red
        badgeLabel?.layer.backgroundColor = UIColor.clear.cgColor
        badgeLabel?.layer.cornerRadius = 10.0
        badgeLabel?.layer.masksToBounds = true
    }
    
    fileprivate func buildDot(withOptions options:ViewPagerOptions, setDot: Bool) {
        
        dotLabel = UILabel()
        dotLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        dotLabel?.textAlignment = .center
        dotLabel?.text = " "
        dotLabel?.isHidden = !setDot
        dotLabel?.textColor = .white
        dotLabel?.backgroundColor = UIColor.red
        dotLabel?.layer.backgroundColor = UIColor.clear.cgColor
        dotLabel?.layer.cornerRadius = 6.0
        dotLabel?.layer.masksToBounds = true
    }
    
    /**
     * Updates the frame of the current tab view incase of EvenlyDistributedCondition. Also propagates those
     * changes to titleLabel and imageView based on ViewPagerTabType.
     */
    internal func updateFrame(atIndex index:Int, withWidth width:CGFloat, options:ViewPagerOptions) {
        
        // Updating frame of the TabView
        let tabViewCurrentFrame = self.frame
        let tabViewXPosition = CGFloat(index) * width
        let tabViewNewFrame = CGRect(x: tabViewXPosition, y: tabViewCurrentFrame.origin.y, width: width, height: tabViewCurrentFrame.height)
        self.frame = tabViewNewFrame
        
        switch options.tabType {
            
        case .basic:
            
            // Updating frame for titleLabel
            titleLabel?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - options.tabViewSpacing, height: self.frame.size.height)
            
            self.setNeedsUpdateConstraints()
            
        case .image:
            
            // Updating frame for ImageView
            let xPosition = ( width - options.tabViewImageSize.width ) / 2
            let yPosition = (options.tabViewHeight - options.tabViewImageSize.height ) / 2
            imageView?.frame = CGRect(x: xPosition, y: yPosition, width: options.tabViewImageSize.width, height: options.tabViewImageSize.height)
            
            self.setNeedsUpdateConstraints()
            
        case .imageWithText:
            
            // Setting imageview frame
            let xImagePosition:CGFloat  = (width - options.tabViewImageSize.width) / 2
            let yImagePosition:CGFloat = options.tabViewImageMarginTop
            imageView?.frame = CGRect(x: xImagePosition, y: yImagePosition , width: options.tabViewImageSize.width, height: options.tabViewImageSize.height)
            
            // Setting titleLabel frame
            let xTextPosition:CGFloat = 0
            let yTextPosition = yImagePosition + options.tabViewImageMarginBottom + options.tabViewImageSize.height
            let textHeight:CGFloat = options.tabViewHeight - yTextPosition - options.tabIndicatorViewHeight
            titleLabel?.frame = CGRect(x: xTextPosition, y: yTextPosition, width: width, height: textHeight)
            
            self.setNeedsUpdateConstraints()
            
        case .textWithBadge:
            
            let badgeWidth = 20.0
            // Setting titleLabel frame
            titleLabel?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - options.tabViewSpacing - badgeWidth, height: self.frame.size.height)
            
            // Setting badge frame
            badgeLabel?.frame = CGRect(x: self.frame.size.width - options.tabViewSpacing - badgeWidth + width, y: 0, width: badgeWidth, height: badgeWidth)
            
            self.setNeedsUpdateConstraints()
            
        case .textWithDot:
            
            let badgeWidth = 12.0
            // Setting titleLabel frame
            titleLabel?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - options.tabViewSpacing - badgeWidth, height: self.frame.size.height)
            
            // Setting badge frame
            badgeLabel?.frame = CGRect(x: self.frame.size.width - options.tabViewSpacing - badgeWidth + width, y: 0, width: badgeWidth, height: badgeWidth)
            
            self.setNeedsUpdateConstraints()
        }
    }
    
    internal func addHighlight(options:ViewPagerOptions) {
        
        self.titleLabel?.backgroundColor = options.tabViewBackgroundHighlightColor
        self.titleLabel?.textColor = options.tabViewTextHighlightColor
        self.titleLabel?.font = options.tabViewTextHighlightFont ?? options.tabViewTextFont
        self.imageView?.tintColor = options.tabViewTextHighlightColor
    }
    
    internal func removeHighlight(options:ViewPagerOptions) {
        
        self.titleLabel?.backgroundColor = options.tabViewBackgroundDefaultColor
        self.titleLabel?.textColor = options.tabViewTextDefaultColor
        self.titleLabel?.font = options.tabViewTextFont
        self.imageView?.tintColor = options.tabViewTextDefaultColor
    }
}
