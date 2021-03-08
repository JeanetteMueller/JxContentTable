//
//  TitleCell.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 09.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager

public extension UITableViewController {
    func registerTitleCell() {
        
        self.tableView.register(TitleCell.classForCoder(), forCellReuseIdentifier: JxContentTableViewCell.TitleCell.rawValue)
        self.tableView.register(UINib(nibName: "TitleCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: JxContentTableViewCell.TitleCell.rawValue)
    }
}

public extension DetailViewCell {

    typealias TitleCellAction = (_ cell: TitleCell, _ indexpath: IndexPath) -> Void

    class func TitleCell(withTitle title: String?, andHeight height: Any = "auto", withTextAlign align: NSTextAlignment = .center, andAction action: TitleCellAction? = nil) -> ContentTableViewCellData {

        let theme = ThemeManager.currentTheme()
        
        var dict = ["cell": JxContentTableViewCell.TitleCell,
                    "height": height,
                    "text": title as Any,
                    "font": UIFont(name: theme.fontLight, size: theme.fontSizeLargeTitle) as Any,
                    "align": align as Any]

        if action != nil {
            dict["action"] = action as Any
        }
        return dict
    }
}

public class TitleCell: DetailViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleLeft: NSLayoutConstraint!
    @IBOutlet weak var titleRight: NSLayoutConstraint!
    
    public override func updateConstraints() {
        let theme = ThemeManager.currentTheme()
        
        titleLeft.constant = theme.contentInsetFromDisplayBorder
        titleRight.constant = theme.contentInsetFromDisplayBorder
        
        super.updateConstraints()
    }
}
