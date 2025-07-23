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
        self.tableView.register(BasicCell.classForCoder(), forCellReuseIdentifier: "BasicCell")
        self.tableView.register(UINib(nibName: "BasicCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: "BasicCell")
    }
}

public extension DetailViewCell {

    struct BasicCellData: ContentTableViewCellData {
        public var height: CGFloat?
        var title: String?
        var font: UIFont?
        var image: UIImage?
        var isSelected: Bool = false
        var align: NSTextAlignment = .left
        var textColor: UIColor?
        var hideDisclosureIndicator: Bool = false
        var action: Action?
    }
    
    class func BasicCell(withTitle title: String?,
                         andHeight height: CGFloat? = nil,
                         andImage image: UIImage? = nil,
                         isSelected selected: Bool = false,
                         withTextAlign align: NSTextAlignment = .left,
                         andTextColor textColor: UIColor? = nil,
                         andHideDisclosureIndicator hideDisclosureIndicator: Bool = false,
                         andAction action: ContentTableViewCellData.Action? = nil) -> JxContentTableViewCell {

        let theme = ThemeManager.currentTheme()
        
        let data = BasicCellData(height: height,
                                 title: title,
                                 font: theme.getFont(name: theme.fontRegular, size: theme.fontSizeContenTitle),
                                 image: image,
                                 isSelected: selected,
                                 align: align,
                                 textColor: textColor,
                                 hideDisclosureIndicator: hideDisclosureIndicator, action: action)
        
        return JxContentTableViewCell.BasicCell(data)
    }

    class func BasicInfotextCell(_ title: String?) -> JxContentTableViewCell {

        let theme = ThemeManager.currentTheme()
        
        let data = BasicCellData(title: title,
                                 font: theme.getFont(name: theme.fontRegular, size: theme.fontSizeContentMedium),
                                 align: .left)
        
//        let dict = ["cell": JxContentTableViewCell.BasicCell,
//                    "text": title as Any,
//                    "font": theme.getFont(name: theme.fontRegular, size: theme.fontSizeContentMedium) as Any,
//                    "height": "auto" as Any,
//                    "align": NSTextAlignment.left as Any
//        ]
        return JxContentTableViewCell.BasicCell(data)
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
