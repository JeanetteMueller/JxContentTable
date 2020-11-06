//
//  LogoCell.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 27.10.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager

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
    @IBOutlet public weak var logoView: PinchToZoomImageView!

    private var logo: String?

    public override func updateAppearance() {
        let theme = ThemeManager.currentTheme()
        self.logoView.accessibilityIgnoresInvertColors = true

        self.logoView.clipsToBounds = true
        self.logoView.layer.cornerRadius = self.logoView.frame.size.height / 100 * theme.cornerRadiusPercent

        super.updateAppearance()
    }
    public func loadLogo(logoPath: String?) {

        self.logo = logoPath

        let theme = ThemeManager.currentTheme()

        if let imageUrlString = self.logo {

            let size = self.logoView.frame.size

            let quadratSize = CGSize(width: max(size.width, size.height), height: max(size.width, size.height))

            if let localImage = UIImage(named: imageUrlString) {
                self.logoView.image = localImage
            } else if let imageFromFile = UIImage.getImage(withImageString: imageUrlString, andSize: quadratSize, withMode: theme.artworkLargeContentMode) {
                self.logoView.image = imageFromFile
            } else if let photoDetails = PhotoRecord(string: imageUrlString) {
                photoDetails.image = theme.fallbackImage
                startDownloadForRecord(photoDetails: photoDetails)
            } else {
                self.logoView.image = theme.fallbackImage
            }

        } else {
            self.logoView.image = theme.fallbackImage
        }

    }
    public func startDownloadForRecord(photoDetails: PhotoRecord) {

        self.logoView.image = photoDetails.image

        let imageLoader = ImageDownloader(photoRecord: photoDetails)

        imageLoader.completionBlock = {
            DispatchQueue.main.async {

                let size = self.logoView.frame.size
                let quadratSize = CGSize(width: max(size.width, size.height), height: max(size.width, size.height))
                let theme = ThemeManager.currentTheme()
                if let imageFromFile = UIImage.getImage(withImageString: self.logo!, andSize: quadratSize, withMode: theme.artworkLargeContentMode) {
                    self.logoView.image = imageFromFile
                }
            }
        }

        PendingImageOperations.shared.downloadQueue.addOperation(imageLoader)
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
