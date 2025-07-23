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
        self.tableView.register(SubtitleCell.classForCoder(), forCellReuseIdentifier: "SubtitleCell")
        self.tableView.register(UINib(nibName: "SubtitleCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: "SubtitleCell")
    }
}

public extension DetailViewCell {

    struct SubtitleCellData: ContentTableViewCellData {
        public var height: CGFloat?
        var title: String?
        var titleFont: UIFont?
        var titleColor: UIColor?
        var subTitle: String?
        var subTitleFont: UIFont?
        var subTitleColor: UIColor?
        var image: UIImage?
        
        var action: Action?
    }
    
    class func SubtitleCell(withTitle title: String?,
                            andTitleFont titleFont: UIFont? = nil,
                            andSubtitle sub: String?,
                            andSubtitleFont subTitleFont: UIFont? = nil,
                            andImage image: UIImage? = nil,
                            andHeight height: CGFloat? = nil,
                            andAction action: ContentTableViewCellData.Action? = nil ) -> JxContentTableViewCell {

        let theme = ThemeManager.currentTheme()
        
        let data = SubtitleCellData(height: height,
                                    title: title,
                                    titleFont: titleFont ?? theme.getFont(name: theme.fontRegular, size: theme.fontSizeContentMedium),
                                    titleColor: theme.titleTextColor,
                                    subTitle: sub,
                                    subTitleFont: subTitleFont ?? theme.getFont(name: theme.fontRegular, size: theme.fontSizeContentMedium),
                                    subTitleColor: theme.subtitleTextColor,
                                    action: action)
        
        return JxContentTableViewCell.SubtitleCell(data)
    }

}

public class SubtitleCell: DetailViewCell {

}
