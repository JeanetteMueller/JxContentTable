//
//  BasicCell.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 09.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager

public extension UITableViewController {
    func registerBasicCell() {
        self.tableView.register(BasicCell.classForCoder(), forCellReuseIdentifier: JxContentTableViewCell.BasicCell.rawValue)
        self.tableView.register(UINib(nibName: "BasicCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: JxContentTableViewCell.BasicCell.rawValue)
    }
}

public extension DetailViewCell {

    typealias BasicCellAction = (_ cell: BasicCell, _ indexpath: IndexPath) -> Void

    class func BasicCell(withTitle title: String?,
                         andHeight height: Any = "auto",
                         andImage image: UIImage? = nil,
                         isSelected selected: Bool = false,
                         withTextAlign align: NSTextAlignment = .left,
                         andTextColor textColor: UIColor? = nil,
                         andHideDisclosureIndicator hideDisclosureIndicator: Bool = false,
                         andAction action: BasicCellAction? = nil) -> ContentTableViewCellData {

        let theme = ThemeManager.currentTheme()
        
        var dict = ["cell": JxContentTableViewCell.BasicCell,
                    "text": title as Any,
                    "font": UIFont(name: theme.fontRegular, size: theme.fontSizeContenTitle) as Any,
                    "selected": selected as Any,
                    "height": height,
                    "align": align as Any,
                    "textColor": textColor as Any,
                    "image": image as Any,
                    "hideDisclosureIndicator": hideDisclosureIndicator as Any
        ]

        if action != nil {
            dict["action"] = action as Any
        }
        return dict
    }

    class func BasicInfotextCell(_ title: String?) -> ContentTableViewCellData {

        let theme = ThemeManager.currentTheme()
        
        let dict = ["cell": JxContentTableViewCell.BasicCell,
                    "text": title as Any,
                    "font": UIFont(name: theme.fontRegular, size: theme.fontSizeContentMedium) as Any,
                    "height": "auto" as Any,
                    "align": NSTextAlignment.left as Any
        ]
        return dict
    }
}

public class BasicCell: DetailViewCell {

    @IBOutlet public weak var cellLabel: UILabel!
    @IBOutlet public weak var cellImageView: UIImageView!
     
    @IBOutlet public weak var imageLeft: NSLayoutConstraint!
    @IBOutlet public weak var imageWidth: NSLayoutConstraint!
    
    @IBOutlet public weak var labelRight: NSLayoutConstraint!
    @IBOutlet public weak var labelLeft: NSLayoutConstraint!

    public override func updateConstraints() {
        
        let theme = ThemeManager.currentTheme()
        imageLeft.constant = theme.contentInsetFromDisplayBorder

        labelLeft.constant = theme.contentInsetFromDisplayBorder
        labelRight.constant = theme.contentInsetFromDisplayBorder

        if cellImageView.image != nil {
            imageWidth.constant = 30
            labelLeft.constant = theme.contentInsetFromDisplayBorder
        } else {
            imageWidth.constant = 0
            labelLeft.constant = 0
        }

        super.updateConstraints()
    }
}
