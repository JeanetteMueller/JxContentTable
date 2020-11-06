//
//  JxBasicTableViewController.swift
//  JxContentTable
//
//  Created by Jeanette Müller on 03.11.20.
//

import UIKit
import JxThemeManager

open class JxBasicTableViewController: UITableViewController {
    
    static var loadBundle: Bundle? {
        get {
            let podBundle = Bundle(for:JxBasicTableViewController.self)
            if let bundleURL = podBundle.url(forResource: "JxContentTable", withExtension: "bundle") {
                if let bundle = Bundle(url: bundleURL) {
                    return bundle
                } else {
                    assertionFailure("Could not load the bundle")
                }
            } else {
                assertionFailure("Could not create a path to the bundle")
            }
            return nil
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        let theme = ThemeManager.currentTheme()
        
        return theme.statusbarStyle
    }
    open func updateAppearance() {
        
        let theme = ThemeManager.currentTheme()
        
        self.view.backgroundColor = theme.backgroundColor
        self.tableView.layer.contents = theme.backgroundImage.cgImage
        self.tableView.backgroundColor = theme.backgroundColor

        
        self.tableView.reloadData()
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.title?.localized
        self.navigationItem.title = self.navigationItem.title?.localized
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    open override func didReceiveMemoryWarning() {
        cleanCaches()
        
        super.didReceiveMemoryWarning()
    }
    
    func updateVisibleTableHeader(_ headerView: BasicHeaderView? = nil) {
        let theme = ThemeManager.currentTheme()
        var headers = [BasicHeaderView]()
        
        if let h = headerView {
            headers.append(h)
        }
        
        if let paths = self.tableView.indexPathsForVisibleRows {
            
            for path in paths {
                autoreleasepool {
                    
                    if let h = self.tableView.headerView(forSection: path.section) as? BasicHeaderView {
                        h.tag = path.section
                        headers.append(h)
                    }
                    
                }
            }
        }
        
        for header in headers {
            let headerFrame = self.tableView.rectForHeader(inSection: header.tag)
            
            let distanceToTop = self.tableView.contentOffset.y - headerFrame.origin.y
            
            var alpha: CGFloat = distanceToTop / theme.headerBackgroundAlphaPerPixel
            
            if alpha > 1 {
                alpha = 1
            } else if alpha < 0 {
                alpha = 0
            }
            header.updateBackground(with: alpha)
            
        }
    }
    
    open func gotMessageFromCell(with title: String, and text: String) {
        
    }
}
