//
//  SwitchCell.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 09.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager

public extension UITableViewController {
    func registerSwitchCell() {
        self.tableView.register(SwitchCell.classForCoder(), forCellReuseIdentifier: JxContentTableViewCell.SwitchCell.rawValue)
        self.tableView.register(UINib(nibName: "SwitchCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: JxContentTableViewCell.SwitchCell.rawValue)
    }
}

public extension DetailViewCell {

    typealias SwitchCellAction = (_ cell: SwitchCell, _ indexpath: IndexPath, _ on: Bool) -> Void

    class func SwitchCell(withTitle title: String?, isOn on: Bool, andAction action: SwitchCellAction? = nil) -> ContentTableViewCellData {
        
        let theme = ThemeManager.currentTheme()

        var dict = ["cell": JxContentTableViewCell.SwitchCell,
                    "height": "auto",
                    "text": title as Any,
                    "font": UIFont(name: theme.fontRegular, size: theme.fontSizeContenTitle) as Any,
                    "on": on as Any,
                    "textFrameReduce": (theme.contentInsetFromDisplayBorder * 2) + 50
        ]

        if action != nil {
            dict["action"] = action as Any
        }
        return dict
    }
}

public class SwitchCell: DetailViewCell {
    @IBOutlet public weak var titleLabel: UILabel!
    #if os(iOS)
    @IBOutlet public weak var switchButton: UISwitch!
    #elseif os(tvOS)
    @IBOutlet public weak var button: UIButton!
    #endif

    @IBOutlet public weak var titleLabelLeft: NSLayoutConstraint!

    @IBOutlet public weak var switchButtonRight: NSLayoutConstraint!

    public override func updateConstraints() {
        let theme = ThemeManager.currentTheme()
        
        titleLabelLeft.constant = theme.contentInsetFromDisplayBorder
        switchButtonRight.constant = theme.contentInsetFromDisplayBorder

        super.updateConstraints()
    }
}
