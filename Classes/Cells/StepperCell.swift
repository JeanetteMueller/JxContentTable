//
//  StepperCell.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 05.12.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager
import JxSwiftHelper

public extension UITableViewController {
    func registerStepperCell() {
        self.tableView.register(StepperCell.classForCoder(), forCellReuseIdentifier: "StepperCell")
        self.tableView.register(UINib(nibName: "StepperCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: "StepperCell")
    }
}

public extension DetailViewCell {

    typealias StepperCellAction = (_ cell: StepperCell, _ indexpath: IndexPath, _ value: Double) -> Void

    struct StepperCellData: ContentTableViewCellData {
        public var height: CGFloat?
        public var title: String?
        public let key: String?
        public var font: UIFont?
        public var value: Double
        public var min: Double = 0
        public var max: Double = 1
        public var stepSize: Double = 0.1
        public var displayFormat: String = ""
        public var textFrameReduce: CGFloat?
        public var action: StepperCellAction?
    }
    
    class func StepperCell(withTitle title: String?, key: String? = nil, withValue value: Double, withMin min: Double, withMax max: Double, andStepsize step: Double, andFormat format: String, andAction action: StepperCellAction? = nil) -> JxContentTableViewCell {
        
        let theme = ThemeManager.currentTheme()
        
        let data = StepperCellData(title: title,
                                   key: key,
                                   font: theme.getFont(name: theme.fontRegular, size: theme.fontSizeContenTitle),
                                   value: value,
                                   min: min,
                                   max: max,
                                   stepSize: step,
                                   displayFormat: format,
                                   textFrameReduce: (theme.contentInsetFromDisplayBorder * 2) + (30 * 2) + 100,
                                   action: action)
        
        return JxContentTableViewCell.StepperCell(data)
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

    var longGestureInterval: TimeInterval = 0.5
    var longGestureUp: UILongPressGestureRecognizer?
    var longGestureDown: UILongPressGestureRecognizer?
    var longGestureSteps: Double = 0
    var longGestureTimer:Timer?
    
    public override func startCell() {
        super.startCell()
        
        self.longGestureUp = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        upButton.addGestureRecognizer(longGestureUp!)
        
        self.longGestureDown = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        downButton.addGestureRecognizer(longGestureDown!)
    }
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
        valueLabel.font = theme.getFont(name: theme.fontMedium, size: theme.fontSizeContentLarge)

        upButtonBackground?.layer.cornerRadius = 12
        downButtonBackground?.layer.cornerRadius = 12

        valueLabel.text = String(format: displayFormat, defaultValue)

        upButton.setTitleColor(UIColor.white, for: .normal)
        downButton.setTitleColor(UIColor.white, for: .normal)

        upButton.titleLabel?.font = theme.getFont(name: theme.fontMedium, size: 18)
        downButton.titleLabel?.font = theme.getFont(name: theme.fontMedium, size: 18)

        upButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        downButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.view == self.upButton {
            print("Long press UP")
        }else if sender.view == self.downButton {
            print("Long press DOWN")
        }
        
        if sender.state == .began {
            log("start timer")
            
            self.longGestureInterval = 0.3
            self.longGestureSteps = 0
            
            
            self.startRepeatTimer(sender)
            
            
        }
        if sender.state == .ended || sender.state == .cancelled {
            self.longGestureTimer?.invalidate()
        }
    }
    func startRepeatTimer(_ sender: UILongPressGestureRecognizer) {
        
        self.longGestureTimer?.invalidate()
        
        if sender.view == self.upButton {
            self.longGestureTimer = Timer.scheduledTimer(withTimeInterval: self.longGestureInterval, repeats: true, block: { (t) in
                self.changeValue(self.stepSize * 5)
                self.longGestureSteps += 1
                
                if self.longGestureSteps > 2.0 / self.longGestureInterval {
                    self.longGestureSteps = 0
                    if self.longGestureInterval > 0.05 {
                        self.longGestureInterval -= 0.1
                    }
                    self.startRepeatTimer(sender)
                }
            })
        }else if sender.view == self.downButton {
            self.longGestureTimer = Timer.scheduledTimer(withTimeInterval: self.longGestureInterval, repeats: true, block: { (t) in
                self.changeValue(-(self.stepSize * 5))
                self.longGestureSteps += 1
                
                if self.longGestureSteps > 2.0 / self.longGestureInterval {
                    self.longGestureSteps = 0
                    if self.longGestureInterval > 0.05 {
                        self.longGestureInterval -= 0.1
                    }
                    self.startRepeatTimer(sender)
                }
            })
        }
    }
    func changeValue(_ addition: Double) {
        log("changeValue \(addition)")
        let newValue = round(1000 * (defaultValue + addition)) / 1000
        
        if newValue <= max, newValue >= min {
            self.valueLabel.text = String(format: displayFormat, newValue)
            self.defaultValue = newValue
            
            self.delegate?.stepperCell(cell: self, changedValue: newValue)
        }
    }
    @IBAction func upAction(_ sender: UIButton?) {
        log("StepperCell up")

        self.changeValue(self.stepSize)
    }
    @IBAction func downAction(_ sender: UIButton?) {
        log("StepperCell down")

        self.changeValue(-(self.stepSize))
    }
}

public protocol StepperCellDelegate: AnyObject {
    func stepperCell(cell: StepperCell, changedValue value: Double)

}
