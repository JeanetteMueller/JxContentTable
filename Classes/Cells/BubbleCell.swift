//
//  StepperCell.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 05.12.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager

public extension UITableViewController {
    func registerBubbleCell() {
        self.tableView.register(BubbleCell.classForCoder(), forCellReuseIdentifier: JxContentTableViewCell.BubbleCell.rawValue)
        self.tableView.register(UINib(nibName: "BubbleCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: JxContentTableViewCell.BubbleCell.rawValue)
    }
}
public extension DetailViewCell {

    typealias BubbleCellAction = (_ cell: BubbleCell, _ indexpath: IndexPath) -> Void

    class func BubbleCell(withTitle title: String?, andHeight height: Any = "auto", andAction action: BubbleCellAction? = nil ) -> ContentTableViewCellData {
        
        let theme = ThemeManager.currentTheme()

        var dict = ["cell": JxContentTableViewCell.BubbleCell,
                    "height": height as Any,
                    "text": title as Any,
                    "font": UIFont(name: theme.fontBold, size: 13) as Any]

        if action != nil {
            dict["action"] = action as Any
        }
        return dict
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
