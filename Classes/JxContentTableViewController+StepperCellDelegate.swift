//
//  DetailViewController+StepperCellDelegate.swift
//  AcceptFiles
//
//  Created by Jeanette Müller on 16.12.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import Foundation

extension JxContentTableViewController: StepperCellDelegate {

    public func stepperCell(cell: StepperCell, changedValue value: Double) {
        if let indexPath = self.tableView.indexPath(for: cell) {

            if content.count > indexPath.section && content[indexPath.section].count > indexPath.row {

                let cellData = content[indexPath.section][indexPath.row]

                if let action = cellData.getAction() as? DetailViewCell.StepperCellAction {
                    action(cell, indexPath, value)
                }
            }
        }
    }

}
