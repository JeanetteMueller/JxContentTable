//
//  UrlInputCell.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 26.10.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import JxThemeManager



public extension UITableViewController {
    func registerInputCell() {
        self.tableView.register(InputCell.classForCoder(), forCellReuseIdentifier: "InputCell")
        self.tableView.register(UINib(nibName: "InputCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: "InputCell")
    }
}

public extension DetailViewCell {

    typealias InputCellAction = (_ cell: InputCell, _ indexpath: IndexPath, _ value: String?, _ submit: Bool) -> Void
    
    struct InputCellData: ContentTableViewCellData {
        public var height: CGFloat?
        
        let text: String?
        let font: UIFont?
        let placeholder: String?
        let keyboardType: UIKeyboardType
        let returnKeyType: UIReturnKeyType
        
        var action: InputCellAction?
    }

    class func InputCell(withValue value: String?,
                         andFont font: UIFont? = nil,
                         andPlaceholder placeholder: String?,
                         andKeyboardType keyboard: UIKeyboardType,
                         andReturnKey returnKey: UIReturnKeyType,
                         andAction action: InputCellAction? = nil) -> JxContentTableViewCell {

        let data = InputCellData(height: 60, text: value, font: font, placeholder: placeholder, keyboardType: keyboard, returnKeyType: returnKey, action: action)
        
        return JxContentTableViewCell.InputCell(data)
    }
}

public class InputCell: DetailViewCell, UITextFieldDelegate {

    @IBOutlet public weak var inputTextField: UITextField!

    weak var delegate: InputCellDelegate?

    public override func unloadCell() {

        delegate = nil

        super.unloadCell()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.delegate?.inputCell(cell: self, sendInput: textField.text)

        textField.resignFirstResponder()

        return true
    }
    public func textFieldDidBeginEditing(_ textField: UITextField) {

        self.delegate?.inputCell(cell: self, changedInput: textField.text)
        textField.clearButtonMode = .whileEditing

        if let button = textField.value(forKey: "clearButton") as? UIButton {

            button.setImage(UIImage(named: "cross"), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit

            let theme = ThemeManager.currentTheme()
            button.tintColor = theme.titleTextColor
        }
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let nsString = textField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string)

        self.delegate?.inputCell(cell: self, changedInput: newString)
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.inputCell(cell: self, changedInput: textField.text)
    }
}

protocol InputCellDelegate: AnyObject {
    func inputCell(cell: InputCell, sendInput input: String?)
    func inputCell(cell: InputCell, changedInput input: String?)
}
