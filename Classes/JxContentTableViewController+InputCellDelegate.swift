//
//  DetailViewController+InputCellDelegate.swift
//  AcceptFiles
//
//  Created by Jeanette Müller on 16.12.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import Foundation

extension JxContentTableViewController: InputCellDelegate {

    func inputCell(cell: InputCell, sendInput input: String?) {
        if let indexPath = self.tableView.indexPath(for: cell) {

            if content.count > indexPath.section && content[indexPath.section].count > indexPath.row {

                let cellData = content[indexPath.section][indexPath.row]

                if let action = cellData.getAction() as? DetailViewCell.InputCellAction {

                    let newValue = input?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

                    action(cell, indexPath, newValue, true)
                }
            }
        }
    }
    func inputCell(cell: InputCell, changedInput input: String?) {
        if let indexPath = self.tableView.indexPath(for: cell) {

            if content.count > indexPath.section && content[indexPath.section].count > indexPath.row {

                let cellData = content[indexPath.section][indexPath.row]

                if let action = cellData.getAction() as? DetailViewCell.InputCellAction {
                    let newValue = input?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

                    action(cell, indexPath, newValue, false)
                }
            }
        }
    }

}
