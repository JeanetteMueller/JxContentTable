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
        
        self.tableView.register(TitleCell.classForCoder(), forCellReuseIdentifier: "TitleCell")
        self.tableView.register(UINib(nibName: "TitleCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: "TitleCell")
    }
}

public extension DetailViewCell {

    struct TitleCellData: ContentTableViewCellData {
        public var height: CGFloat?
        var title: String
        var font: UIFont?
        var align: NSTextAlignment
        var action: Action?
    }
    class func TitleCell(withTitle title: String, font: UIFont? = nil, height: CGFloat? = nil, align: NSTextAlignment = .center, action: ContentTableViewCellData.Action? = nil) -> JxContentTableViewCell {

        let theme = ThemeManager.currentTheme()
        
        let data = TitleCellData(height: height,
                                 title: title,
                                 font: font ?? theme.getFont(name: theme.fontLight, size: theme.fontSizeLargeTitle),
                                 align: align,
                                 action: action)
        
        return JxContentTableViewCell.TitleCell(data)
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
