//
//  DetailViewController+UrlInputCellDelegate.swift
//  AcceptFiles
//
//  Created by Jeanette Müller on 16.12.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import Foundation
import JxThemeManager

extension JxContentTableViewController: UrlInputCellDelegate {

    public func urlInputCell(cell: UrlInputCell, sendInput input: String) {

        var mutableInput = input
        if !mutableInput.isEqual("") {
            if !mutableInput.hasPrefix("http") {
                mutableInput = String(format: "http://%@", mutableInput)
            }

            let newValue = mutableInput.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

            if let url = URL(string: newValue) {
                if !url.absoluteString.isEqual("") {
                    if let indexPath = self.tableView.indexPath(for: cell) {

                        if content.count > indexPath.section && content[indexPath.section].count > indexPath.row {

                            let dict = content[indexPath.section][indexPath.row]

                            if let action = dict["action"] as? DetailViewCell.UrlInputCellAction {

                                action(cell, indexPath, url, true)
                            }
                        }
                    }

                    return
                }
            }
        }

        self.gotMessageFromCell(with: "No valid URL".localized,
                                and: "You have entered an invalid url. Please check that the address starts with http.".localized)
        
    }
    public func urlInputCell(cell: UrlInputCell, changeInput input: String) {

        var mutableInput = input
        if !mutableInput.isEqual("") {
            if !mutableInput.hasPrefix("http") {
                mutableInput = String(format: "http://%@", mutableInput)
            }

            let newValue = mutableInput.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

            if let url = URL(string: newValue) {
                if !url.absoluteString.isEqual("") {
                    if let indexPath = self.tableView.indexPath(for: cell) {

                        if content.count > indexPath.section && content[indexPath.section].count > indexPath.row {

                            let dict = content[indexPath.section][indexPath.row]

                            if let action = dict["action"] as? DetailViewCell.UrlInputCellAction {
                                action(cell, indexPath, url, false)
                            }
                        }
                    }

                    return
                }
            }
        }
    }
}
