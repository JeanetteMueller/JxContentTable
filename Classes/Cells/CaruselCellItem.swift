//
//  CaruselCellItem.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 19.11.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager
import JxSwiftHelper

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
                
                imageView.loadImageFromHttpPath(path: imageUrlString,
                                                fallbackImage: theme.fallbackImage,
                                                contentMode: theme.artworkLargeContentMode)
            }
        } else {
            self.logoView?.image = theme.fallbackImage
        }

    }
}
