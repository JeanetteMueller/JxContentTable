//
//  LogoCell.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 27.10.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager
import JxSwiftHelper
import JxSwiftHelperForUiKit
import ZoomImageView

public extension UITableViewController {
    func registerLogoCell() {
        self.tableView.register(LogoCell.classForCoder(), forCellReuseIdentifier: JxContentTableViewCell.LogoCell.rawValue)
        self.tableView.register(UINib(nibName: "LogoCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: JxContentTableViewCell.LogoCell.rawValue)
    }
}

public extension DetailViewCell {

    typealias LogoCellAction = (_ cell: LogoCell, _ indexpath: IndexPath) -> Void

    class func LogoCell(withImageString logo: String?, andHeight height: Any, andAction action: LogoCellAction? = nil) -> ContentTableViewCellData {

        var dict = ["cell": JxContentTableViewCell.LogoCell,
                    "height": height,
                    "logo": logo as Any]

        if action != nil {
            dict["action"] = action as Any
        }
        return dict
    }
    class func LogoCell(withImageName name: String?, andHeight height: Any, andAction action: LogoCellAction? = nil) -> ContentTableViewCellData {

        var dict = ["cell": JxContentTableViewCell.LogoCell,
                    "height": height,
                    "imageName": name as Any]

        if action != nil {
            dict["action"] = action as Any
        }
        return dict
    }
    //    class func LogoCell(withSvgName svg:String?, andHeight height:Any, andAction action: LogoCellAction? = nil) -> ContentTableViewCellData {
    //
    //        var dict = ["cell" : JxContentTableViewCell.LogoCell,
    //                    "height": height,
    //                    "svgname": svg as Any]
    //
    //        if action != nil{
    //            dict["action"] = action as Any
    //        }
    //        return dict
    //    }
}

public class LogoCell: DetailViewCell {
    @IBOutlet public weak var logoView: ZoomImageView!

    private var logo: String?

    public override func updateAppearance() {
        let theme = ThemeManager.currentTheme()
        self.logoView.accessibilityIgnoresInvertColors = true

        self.logoView.clipsToBounds = true
        self.logoView.layer.cornerRadius = self.logoView.frame.size.height / 100 * theme.cornerRadiusPercent

        super.updateAppearance()
    }
    public func loadLogo(logoPath: String) {

        let theme = ThemeManager.currentTheme()
        
        self.logo = logoPath

        self.logoView.loadImageFromHttpPath(path: logoPath,
                                            fallbackImage: theme.fallbackImage,
                                            contentMode: theme.artworkLargeContentMode)
    }
    
    public func updateCell(withOffset offset: CGFloat) {

        var extra: CGFloat = 0
        if offset < 0 {
            extra = offset * -1
            self.clipsToBounds = false
        }

        let padding: CGFloat = 10

        var newSize = self.frame.size.height + extra - (padding * 2)

        if newSize > self.frame.size.width - (padding * 2) {
            newSize = self.frame.size.width - (padding * 2)
        }

        self.logoView.frame = CGRect(x: (self.frame.size.width - newSize) / 2,
                                     y: -extra + padding,
                                     width: self.frame.size.height + extra - (padding * 2),
                                     height: self.frame.size.height + extra - (padding * 2))
        
    }
}
