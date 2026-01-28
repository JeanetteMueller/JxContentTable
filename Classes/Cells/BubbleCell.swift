//
//  StepperCell.swift
//  JxContentTable
//
//  Created by Jeanette Müller on 05.12.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager

public extension UITableViewController {
    func registerBubbleCell() {
        self.tableView.register(BubbleCell.classForCoder(), forCellReuseIdentifier: "BubbleCell")
        self.tableView.register(UINib(nibName: "BubbleCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: "BubbleCell")
    }
}
public extension DetailViewCell {

    struct BubbleCellData: ContentTableViewCellData {
        public var height: CGFloat?
        var title: String?
        var font: UIFont?
        var action: Action?
    }
    
    class func BubbleCell(withTitle title: String?, andHeight height: CGFloat?, andAction action: ContentTableViewCellData.Action? = nil ) -> JxContentTableViewCell {
        
        let theme = ThemeManager.currentTheme()
        
        let data = BubbleCellData(height: height, title: title, font: theme.getFont(name: theme.fontBold, size: 13), action: action)

        return JxContentTableViewCell.BubbleCell(data)
    }
}

public class BubbleCell: DetailViewCell {

    @IBOutlet public weak var titleLabel: UILabel?
    @IBOutlet public weak var bubbleView: UIView?

    public override func unloadCell() {

        super.unloadCell()
    }
    public override func updateAppearance() {
        super.updateAppearance()

        let theme = ThemeManager.currentTheme()

        titleLabel?.textColor = theme.titleTextColor

        if let bubbleView = bubbleView {
            bubbleView.backgroundColor = theme.color
        }
    }
}
