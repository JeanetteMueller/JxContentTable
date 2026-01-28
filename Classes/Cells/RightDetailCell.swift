//
//  RightDetailCell.swift
//  JxContentTable
//
//  Created by Jeanette Müller on 09.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager

public extension UITableViewController {
    func registerRightDetailCell() {
        self.tableView.register(RightDetailCell.classForCoder(), forCellReuseIdentifier: "RightDetailCell")
        self.tableView.register(UINib(nibName: "RightDetailCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: "RightDetailCell")
    }
}

public extension DetailViewCell {

    struct RightDetailCellData: ContentTableViewCellData {
        public var height: CGFloat?
        public let key: String?
        
        public var left: String?
        public var leftFont: UIFont?
        public var leftColor: UIColor?
        
        public var right: String?
        public var rightFont: UIFont?
        public var rightColor: UIColor?
        
        public var options: [String]? = nil
        public var defaultValue: String? = nil
        public var isSelected: Bool = false
        
        public var textFrameReduce: CGFloat = 0
        
        public var action: Action?
    }
    
    class func RightDetailCell(key: String? = nil,
                               withLeftText left: String? = nil,
                               andRightText right: String? = nil,
                               andHeight height: CGFloat? = nil,
                               andTextColorLeft leftTextColor: UIColor? = nil,
                               andTextColorRight rightTextColor: UIColor? = nil,
                               options: [String]? = nil,
                               defaultValue: String? = nil,
                               isSelected selected: Bool = false,
                               andAction action: ContentTableViewCellData.Action? = nil) -> JxContentTableViewCell {

        let theme = ThemeManager.currentTheme()
        
        let data = RightDetailCellData(height: height,
                                       key: key,
                                       left: left,
                                       leftFont: theme.getFont(name: theme.fontRegular, size: theme.fontSizeContenTitle),
                                       leftColor: leftTextColor,
                                       
                                       right: right,
                                       rightFont: theme.getFont(name: theme.fontRegular, size: theme.fontSizeContentLarge),
                                       rightColor: rightTextColor,
                                       
                                       options: options,
                                       defaultValue: defaultValue,
                                       isSelected: selected,
                                       textFrameReduce: (UIScreen.main.bounds.size.width - (theme.contentInsetFromDisplayBorder * 2)) * 0.7,
                                       
                                       action: action)
        
        return JxContentTableViewCell.RightDetailCell(data)
    }
}

public class RightDetailCell: DetailViewCell {

    @IBOutlet public var leftText: UILabel!
    @IBOutlet public var rightText: UILabel!
    
    @IBOutlet weak var leftBorder: NSLayoutConstraint!
    @IBOutlet weak var rightBorder: NSLayoutConstraint!
    
    public override func updateConstraints() {
        
        let theme = ThemeManager.currentTheme()
        
        leftBorder.constant = theme.contentInsetFromDisplayBorder
        rightBorder.constant = theme.contentInsetFromDisplayBorder
        
        super.updateConstraints()
    }
}
