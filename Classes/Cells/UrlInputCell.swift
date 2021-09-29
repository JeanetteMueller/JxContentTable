//
//  UrlInputCell.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 26.10.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit

public extension UITableViewController {
    func registerUrlInputCell() {
        self.tableView.register(UrlInputCell.classForCoder(), forCellReuseIdentifier: JxContentTableViewCell.UrlInputCell.rawValue)
        self.tableView.register(UINib(nibName: "UrlInputCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: JxContentTableViewCell.UrlInputCell.rawValue)
    }
}

public extension DetailViewCell {
    typealias UrlInputCellAction = (_ cell: UrlInputCell, _ indexpath: IndexPath, _ value: URL, _ submit: Bool) -> Void

    class func UrlInputCell(withValue value: String?, andPlaceholder placeholder: String?, andReturnKey returnKey: UIReturnKeyType, andAction action: UrlInputCellAction? = nil) -> ContentTableViewCellData {

        var dict = ["cell": JxContentTableViewCell.UrlInputCell,
                    "height": 60 as Any,
                    "text": value as Any,
                    "placeholder": placeholder as Any,
                    "returnKey": returnKey as Any]

        if action != nil {
            dict["action"] = action as Any
        }
        return dict
    }
}

public class UrlInputCell: DetailViewCell, UITextFieldDelegate {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var commitButton: UIButton!

    public weak var delegate: UrlInputCellDelegate?

    public override func unloadCell() {

        delegate = nil

        super.unloadCell()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.delegate?.urlInputCell(cell: self, sendInput: urlTextField.text!)

        textField.resignFirstResponder()

        return true
    }
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.urlInputCell(cell: self, changeInput: urlTextField.text!)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.urlInputCell(cell: self, changeInput: urlTextField.text!)
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.delegate?.urlInputCell(cell: self, changeInput: urlTextField.text!)
        return true
    }

    @IBAction func openUrl(sender: UIButton) {

        self.delegate?.urlInputCell(cell: self, sendInput: urlTextField.text!)
    }
}

public protocol UrlInputCellDelegate: AnyObject {
    func urlInputCell(cell: UrlInputCell, sendInput input: String)
    func urlInputCell(cell: UrlInputCell, changeInput input: String)
}
