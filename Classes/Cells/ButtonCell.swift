//
//  ButtonCell.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 31.01.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import UIKit
import StoreKit
import JxThemeManager

public extension UITableViewController {
    func registerButtonCell() {
        self.tableView.register(ButtonCell.classForCoder(), forCellReuseIdentifier: JxContentTableViewCell.ButtonCell.rawValue)
        self.tableView.register(UINib(nibName: "ButtonCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: JxContentTableViewCell.ButtonCell.rawValue)
    }
}

public extension DetailViewCell {
    typealias ButtonCellAction = (_ cell: ButtonCell, _ indexpath: IndexPath) -> Void

    class func ButtonCell(withButtonTitle buttonTitle: String, andAction action: ButtonCellAction? = nil) -> ContentTableViewCellData {
        var dict = ["cell": JxContentTableViewCell.ButtonCell,
                    "height": 100 as Any,
                    "buttonTitle": buttonTitle as Any
        ]
        if action != nil {
            dict["action"] = action as Any
        }
        return dict
    }
}

public class ButtonCell: DetailViewCell {

    @IBOutlet public weak var button: UIButton!

    public var product: SKProduct?

    public func updateWithTitle(_ title: String?) {

        let theme = ThemeManager.currentTheme()

        button.layer.borderColor = theme.actionButtonsColor.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 30
        button.titleLabel?.font = UIFont(name: theme.fontRegular, size: 20)
        button.setTitleColor(theme.actionButtonsColor, for: .normal)

        button.setTitle(title, for: .normal)
    }
    public override func unloadCell() {

        product = nil

        super.unloadCell()
    }
}
