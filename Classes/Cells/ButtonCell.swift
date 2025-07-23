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
        self.tableView.register(ButtonCell.classForCoder(), forCellReuseIdentifier: "ButtonCell")
        self.tableView.register(UINib(nibName: "ButtonCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: "ButtonCell")
    }
}

public extension DetailViewCell {
    struct ButtonCellData: ContentTableViewCellData {
        public var height: CGFloat?
        var title: String
        var action: Action?
    }
    
    class func ButtonCell(withButtonTitle title: String, andAction action: ContentTableViewCellData.Action? = nil) -> JxContentTableViewCell {
        
        let data = ButtonCellData(height: 100, title: title, action: action)

        return JxContentTableViewCell.ButtonCell(data)
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
