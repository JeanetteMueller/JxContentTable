//
//  ProgressCell.swift
//  projectPhoenix
//
//  Created by Jeanette Müller on 08.12.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit

public extension UITableViewController {
    func registerProgressCell() {
        self.tableView.register(ProgressCell.classForCoder(), forCellReuseIdentifier: "ProgressCell")
        self.tableView.register(UINib(nibName: "ProgressCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: "ProgressCell")
    }
}
public extension DetailViewCell {

    typealias ProgressCellAction = (_ cell: ProgressCell, _ indexpath: IndexPath, _ value: Float) -> Void

    struct ProgressCellData: ContentTableViewCellData {
        public var height: CGFloat?
        var title: String?
        var font: UIFont?
        var value: Float
        var progress: Progress?
        var urlString: String?
        var action: ProgressCellAction?
    }
    
    class func ProgressCell(withTitle title: String?, withValue value: Float, andAction action: ProgressCellAction? = nil) -> JxContentTableViewCell {
        
        let data = ProgressCellData(title: title, value: value, action: action)
        
        return JxContentTableViewCell.ProgressCell(data)
    }
    class func ProgressCell(withTitle title: String?, withValue value: Float = 0, withProgress progress: Progress? = nil, withDownload urlString: String, andAction action: ProgressCellAction? = nil) -> JxContentTableViewCell {
        
        let data = ProgressCellData(title: title, value: value, progress: progress, urlString: urlString, action: action)
        
        return JxContentTableViewCell.ProgressCell(data)
    }

}

public class ProgressCell: DetailViewCell {

    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var progressBar: UIProgressView!

    public var registeredForObserver: Bool = false

    public var downloadUrlString: String? {
        didSet {
            NotificationCenter.default.addObserver(forName: Notification.Name("DownloadManagerTransferDidUpdate"), object: nil, queue: .main) { [weak self] notification in
                self?.downloadDidUpdateNotification(notification)
            }
        }
    }
    public var textValue: String?

    public func updateProgress(withPercent percent: Float, orProgress progress: Progress?) {

        if let p = progress {
            self.progressBar.observedProgress = p

            self.progressBar.addObserver(self, forKeyPath: "observedProgress.fractionCompleted", options: .new, context: nil)
            self.registeredForObserver = true
        } else {
            self.progressBar.progress = percent
        }
        self.updateText(self.progressBar, withFloatValue: percent)
    }
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        DispatchQueue.main.async {

            self.updateText(object, withFloatValue: 0)
        }
    }
    deinit {
        if self.registeredForObserver == true {
            self.progressBar.removeObserver(self, forKeyPath: "observedProgress.fractionCompleted")
            NotificationCenter.default.removeObserver(self)
            self.registeredForObserver = false
        }
    }
    public override func unloadCell() {
        if self.registeredForObserver == true {
            self.progressBar.removeObserver(self, forKeyPath: "observedProgress.fractionCompleted")
            NotificationCenter.default.removeObserver(self)
            self.registeredForObserver = false
        }
    }
    public func updateText(_ object: Any?, withFloatValue val: Float) {
        if let o = object as? UIProgressView, o == self.progressBar {
            if let p = o.observedProgress, p.fractionCompleted > 0.0 || self.textValue == nil {
                self.titleLabel.textAlignment = .center
                self.titleLabel.text = String(format: "%.2f %%", p.fractionCompleted*100)
            } else if val > 0.0 || self.textValue == nil {
                self.titleLabel.textAlignment = .center
                self.titleLabel.text = String(format: "%.2f %%", val)

            } else {
                self.titleLabel.textAlignment = .left
                self.titleLabel.text = self.textValue ?? ""
            }
        }
    }
    public func downloadDidUpdateNotification(_ notification: Notification) {
        if let task = notification.object as? URLSessionTask {
            self.updateProgress(withPercent: Float(task.progress.fractionCompleted), orProgress: task.progress)
        }
    }
}
