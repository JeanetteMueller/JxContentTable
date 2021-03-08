//
//  RightDetailCell.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 09.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager

public extension UITableViewController {
    func registerRightDetailCell() {
        self.tableView.register(RightDetailCell.classForCoder(), forCellReuseIdentifier: JxContentTableViewCell.RightDetailCell.rawValue)
        self.tableView.register(UINib(nibName: "RightDetailCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: JxContentTableViewCell.RightDetailCell.rawValue)
    }
}

public extension DetailViewCell {

    typealias RightDetailCellAction = (_ cell: RightDetailCell, _ indexpath: IndexPath) -> Void

    class func RightDetailCell(withLeftText left: String, andRightText right: String?, andHeight height: Any = "auto", andTextColorLeft leftTextColor: UIColor? = nil, andTextColorRight rightTextColor: UIColor? = nil, isSelected selected: Bool = false, andAction action: RightDetailCellAction? = nil) -> ContentTableViewCellData {

        let theme = ThemeManager.currentTheme()
        
        var dict = ["cell": JxContentTableViewCell.RightDetailCell,
                    "height": height,
                    "text": left as Any,
                    "leftfont": UIFont(name: theme.fontRegular, size: theme.fontSizeContenTitle) as Any,
                    "rightfont": UIFont(name: theme.fontRegular, size: theme.fontSizeContentLarge) as Any,
                    "textColor": leftTextColor as Any,
                    "textColorRight": rightTextColor as Any,
                    "right": right as Any,
                    "selected": selected as Any,
                    "textFrameReduce": (UIScreen.main.bounds.size.width - (theme.contentInsetFromDisplayBorder * 2)) * 0.7
        ]

        if action != nil {
            dict["action"] = action as Any
        }
        return dict
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
