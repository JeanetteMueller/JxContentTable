//
//  SubtitleCell.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 09.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager

public extension UITableViewController {
    func registerSubtitleCell() {
        self.tableView.register(SubtitleCell.classForCoder(), forCellReuseIdentifier: JxContentTableViewCell.SubtitleCell.rawValue)
        self.tableView.register(UINib(nibName: "SubtitleCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: JxContentTableViewCell.SubtitleCell.rawValue)
    }
}

public extension DetailViewCell {

    typealias SubtitleCellAction = (_ cell: SubtitleCell, _ indexpath: IndexPath) -> Void

    class func SubtitleCell(withTitle title: String?,
                            andTitleFont titleFont: UIFont? = nil,
                            andSubtitle sub: String?,
                            andSubtitleFont subTitleFont: UIFont? = nil,
                            andImage image: UIImage? = nil,
                            andHeight height: Any = "auto",
                            andAction action: SubtitleCellAction? = nil ) -> ContentTableViewCellData {

        let theme = ThemeManager.currentTheme()
        
        var dict = ["cell": JxContentTableViewCell.SubtitleCell,
                    "height": height,
                    "text": title as Any,
                    "font": (titleFont ?? UIFont(name: theme.fontRegular, size: theme.fontSizeContentMedium)) as Any,
                    "sub": sub as Any,
                    "subfont": (subTitleFont ?? UIFont(name: theme.fontRegular, size: theme.fontSizeContentMedium)) as Any,
                    "image": image as Any,
                    "textFrameReduce": 16.0 * 2 + (action == nil ? 0 : 30)
        ]

        if action != nil {
            dict["action"] = action as Any
        }
        return dict
    }

}

public class SubtitleCell: DetailViewCell {

}
