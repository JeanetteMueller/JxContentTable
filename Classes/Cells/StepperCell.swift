//
//  StepperCell.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 05.12.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager

public extension UITableViewController {
    func registerStepperCell() {
        self.tableView.register(StepperCell.classForCoder(), forCellReuseIdentifier: JxContentTableViewCell.StepperCell.rawValue)
        self.tableView.register(UINib(nibName: "StepperCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: JxContentTableViewCell.StepperCell.rawValue)
    }
}

public extension DetailViewCell {

    typealias StepperCellAction = (_ cell: StepperCell, _ indexpath: IndexPath, _ value: Double) -> Void

    class func StepperCell(withTitle title: String?, withValue value: Double, withMin min: Double, withMax max: Double, andStepsize step: Double, andFormat format: String, andAction action: StepperCellAction? = nil) -> ContentTableViewCellData {
        
        let theme = ThemeManager.currentTheme()
        
        var dict = ["cell": JxContentTableViewCell.StepperCell,
                    "text": title as Any,
                    "font": UIFont(name: theme.fontRegular, size: theme.fontSizeContenTitle) as Any,
                    "height": 60 as Any,
                    "value": value as Any,
                    "step": step as Any,
                    "min": min as Any,
                    "max": max as Any,
                    "displayFormat": format
        ]

        if action != nil {
            dict["action"] = action as Any
        }
        return dict
    }
}

public class StepperCell: DetailViewCell {

    public weak var delegate: StepperCellDelegate?

    @IBOutlet public weak var titleLabel: UILabel!

    public var steps = [Double]()
     
    public var defaultValue: Double = 0
    public var stepSize: Double = 1
    public var min: Double = 0
    public var max: Double = 10
    
    public var displayFormat = "%.0f"

    @IBOutlet public weak var valueLabel: UILabel!
    
    @IBOutlet public weak var upButton: UIButton!
    @IBOutlet public weak var downButton: UIButton!
    
    @IBOutlet public weak var upButtonBackground: UIView?
    @IBOutlet public weak var downButtonBackground: UIView?
    
    @IBOutlet public weak var upButtonContainer: UIView?
    @IBOutlet public weak var downButtonContainer: UIView?
     
    @IBOutlet public weak var titleLabelLeft: NSLayoutConstraint!
    @IBOutlet public weak var upButtonRight: NSLayoutConstraint!

    public override func unloadCell() {

        delegate = nil

        super.unloadCell()
    }
    public override func updateConstraints() {
        
        let theme = ThemeManager.currentTheme()

        titleLabelLeft.constant = theme.contentInsetFromDisplayBorder
        upButtonRight.constant = theme.contentInsetFromDisplayBorder

        super.updateConstraints()
    }
    public override func updateAppearance() {
        super.updateAppearance()

        let theme = ThemeManager.currentTheme()

        valueLabel.textColor = theme.titleTextColor

        upButtonBackground?.backgroundColor = theme.color
        downButtonBackground?.backgroundColor = theme.color

        upButtonContainer?.backgroundColor = UIColor.clear
        downButtonContainer?.backgroundColor = UIColor.clear

        valueLabel.backgroundColor = UIColor.clear

        upButtonBackground?.layer.cornerRadius = 12
        downButtonBackground?.layer.cornerRadius = 12

        valueLabel.text = String(format: displayFormat, defaultValue)

        upButton.setTitleColor(UIColor.white, for: .normal)
        downButton.setTitleColor(UIColor.white, for: .normal)

        upButton.titleLabel?.font = UIFont(name: theme.fontMedium, size: 18)
        downButton.titleLabel?.font = UIFont(name: theme.fontMedium, size: 18)

        upButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        downButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
    }
    @IBAction func upAction(_ sender: UIButton?) {
        log("StepperCell up")

        let newValue = round(1000 * (defaultValue + stepSize)) / 1000

        if newValue <= max {
            self.valueLabel.text = String(format: displayFormat, newValue)
            self.defaultValue = newValue

            self.delegate?.stepperCell(cell: self, changedValue: newValue)
        }

    }
    @IBAction func downAction(_ sender: UIButton?) {
        log("StepperCell down")

        let newValue = round(1000 * (defaultValue - stepSize)) / 1000

        if newValue >= min {
            self.valueLabel.text = String(format: displayFormat, newValue)
            self.defaultValue = newValue

            self.delegate?.stepperCell(cell: self, changedValue: newValue)
        }
    }
}

public protocol StepperCellDelegate: class {
    func stepperCell(cell: StepperCell, changedValue value: Double)

}
