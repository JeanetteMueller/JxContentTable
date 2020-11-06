//
//  CaruselCellItem.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 19.11.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager

class CaruselCellItem: UICollectionViewCell {

    var item: CaruselItem?

    @IBOutlet var logoView: UIImageView!

    func configureCell(withItem caruselItem: CaruselItem) {
        self.item = caruselItem

        updateAppearance()
    }
    func startCell() {

        if let logo = self.item?.image {

            loadLogo(logoPath: logo)
        }
    }
    func updateAppearance() {
        let theme = ThemeManager.currentTheme()
        self.logoView.alpha = theme.imageAlpha
    }

    // MARK: Logo

    func loadLogo(logoPath: String?) {

        self.logoView.accessibilityIgnoresInvertColors = true

        let theme = ThemeManager.currentTheme()
        if let imageUrlString = logoPath {

            if let imageView = logoView {
                let size = CGSize(width: 100, height: 100)

                let quadratSize = CGSize(width: max(size.width, size.height), height: max(size.width, size.height))

                if let imageFromFile = UIImage.getImage(withImageString: imageUrlString, andSize: quadratSize, withMode: theme.artworkContentMode) {
                    imageView.image = imageFromFile
                } else if let photoDetails = PhotoRecord(string: imageUrlString) {
                    photoDetails.image = theme.fallbackImage
                    startDownloadForRecord(photoDetails: photoDetails)
                } else {
                    self.logoView?.image = theme.fallbackImage
                }
            }
        } else {
            self.logoView?.image = theme.fallbackImage
        }

    }
    func startDownloadForRecord(photoDetails: PhotoRecord) {

        self.logoView?.image = photoDetails.image

        let imageLoader = ImageDownloader(photoRecord: photoDetails)

        imageLoader.completionBlock = {
            DispatchQueue.main.async {

                if let imageView = self.logoView {
                    if let e = self.item {
                        let size = CGSize(width: 100, height: 100)
                        let quadratSize = CGSize(width: max(size.width, size.height), height: max(size.width, size.height))

                        if let imageString = e.image {
                            let theme = ThemeManager.currentTheme()
                            if let imageFromFile = UIImage.getImage(withImageString: imageString, andSize: quadratSize, withMode: theme.artworkContentMode) {
                                imageView.image = imageFromFile
                            }
                        }
                    }
                }
            }
        }

        PendingImageOperations.shared.downloadQueue.addOperation(imageLoader)
    }
}
