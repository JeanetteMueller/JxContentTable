//
//  DetailViewCell.swift
//  JxContentTable
//
//  Created by Jeanette Müller on 05.04.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager

extension JxContentTableViewController {
    func prepareCell(_ cell: DetailViewCell, with dict: ContentTableViewCellData) -> DetailViewCell {

        return cell
    }
}
open class DetailViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }

    open func updateAppearance() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear

        let theme = ThemeManager.currentTheme()
        self.accessoryTypeColor = theme.titleTextColor
    }
    open func startCell() {

    }
    open func unloadCell() {

    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        if self.accessoryType == .disclosureIndicator {

            if let indicatorButton = allSubviews.compactMap({ $0 as? UIButton }).last {
                let image = indicatorButton.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate)
                indicatorButton.setBackgroundImage(image, for: .normal)
                indicatorButton.tintColor = self.accessoryTypeColor
            }
        }
    }
    var accessoryTypeColor: UIColor = .darkGray
}

extension UIView {
    var allSubviews: [UIView] {
        return subviews.flatMap { [$0] + $0.allSubviews }
    }

}
