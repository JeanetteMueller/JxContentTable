//
//  BasicHeaderView.swift
//  JxContentTable
//
//  Created by Jeanette Müller on 29.04.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager

open class BasicHeaderView: UITableViewHeaderFooterView {
    
    public var didSetupConstraints = false
    public var section: Int = 0
    
    @IBOutlet public weak var separator: UIView?
    @IBOutlet public weak var separatorLeft: NSLayoutConstraint?
    @IBOutlet public weak var separatorRight: NSLayoutConstraint?
    @IBOutlet public weak var separatorHeight: NSLayoutConstraint?
    
    open override func updateConstraints() {
        
        let theme = ThemeManager.currentTheme()
        
        separatorLeft?.constant = theme.contentInsetFromDisplayBorder
        separatorRight?.constant = theme.contentInsetFromDisplayBorder
        separatorHeight?.constant = theme.minimalBorderWidth
        
        super.updateConstraints()
    }
    open func updateAppearance() {
        let theme = ThemeManager.currentTheme()
        
#if os(OSX) || os(iOS)
        self.separator?.backgroundColor = theme.tableViewSeparatorColor
#endif
        
        if self.backgroundView == nil {
            let b = UIView(frame: self.bounds)
            b.backgroundColor = theme.tableViewHeadlineBackgroundColor
            self.backgroundView = b
        }
    }
    open func update(withSection section: Int) {
        self.section = section
        
        updateAppearance()
        setNeedsUpdateConstraints()
    }
    open func updateBackground(with alpha: CGFloat) {
        var useAlpha = alpha
        
        if useAlpha > 0.75 {
            useAlpha = 0.75
        }
        if self.backgroundView == nil {
            let b = UIView(frame: self.bounds)
            self.backgroundView = b
        }
        
        if let b = self.backgroundView {
            b.alpha = useAlpha
        }
        
        self.separator?.alpha = 1 - alpha
    }
    
    private var backgroundRect: CGRect {
        let theme = ThemeManager.currentTheme()
        
        return CGRect(x: theme.contentInsetFromDisplayBorder,
                      y: 0,
                      width: self.bounds.size.width - (theme.contentInsetFromDisplayBorder * 2),
                      height: self.bounds.size.height)
    }
}
