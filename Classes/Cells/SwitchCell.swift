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
        self.tableView.register(SwitchCell.classForCoder(), forCellReuseIdentifier: "SwitchCell")
        self.tableView.register(UINib(nibName: "SwitchCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: "SwitchCell")
    }
}

public extension DetailViewCell {

    typealias SwitchCellAction = (_ cell: SwitchCell, _ indexpath: IndexPath, _ on: Bool) -> Void

    struct SwitchCellData: ContentTableViewCellData {
        public var height: CGFloat?
        public let title: String?
        public let key: String?
        public let font: UIFont?
        public let on: Bool
        public let action: SwitchCellAction?
    }
    
    class func SwitchCell(withTitle title: String?, key: String? = nil, isOn on: Bool, andAction action: SwitchCellAction? = nil) -> JxContentTableViewCell {
        
        let theme = ThemeManager.currentTheme()

        let data = SwitchCellData(title: title, key: key, font: theme.getFont(name: theme.fontRegular, size: theme.fontSizeContenTitle), on: on, action: action)

        return JxContentTableViewCell.SwitchCell(data)
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
