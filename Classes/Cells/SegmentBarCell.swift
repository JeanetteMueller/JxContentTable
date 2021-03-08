//
//  SegmentBarCell.swift
//  JxContentTable
//
//  Created by Jeanette Müller on 08.01.21.
//

import UIKit
import JxThemeManager

public extension UITableViewController {
    func registerSegmentBarCell() {
        self.tableView.register(SegmentBarCell.classForCoder(), forCellReuseIdentifier: JxContentTableViewCell.SegmentBarCell.rawValue)
        self.tableView.register(UINib(nibName: "SegmentBarCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: JxContentTableViewCell.SegmentBarCell.rawValue)
    }
}

public extension DetailViewCell {
    
    class func SegmentBarCell(withPercentageValues values: [Float],
                              andTitles titles: [String],
                              andColors colors: [UIColor]) -> ContentTableViewCellData {
        
        let dict = ["cell": JxContentTableViewCell.SegmentBarCell,
                    "values": values as Any,
                    "titles": titles as Any,
                    "colors": colors as Any,
                    "height": 10 + 14 + 5 + 20 + 10
                    
        ]
        
        return dict
    }
    

}

public class SegmentBarCell: DetailViewCell {
    
    @IBOutlet public weak var content: UIView!
    @IBOutlet public weak var bar: UIView!
    @IBOutlet public weak var legend: UILabel!
    
    var values = [Float]()
    var titles = [String]()
    var colors = [UIColor]()
    
    @IBOutlet weak var left: NSLayoutConstraint!
    @IBOutlet weak var right: NSLayoutConstraint!
    
    public override func updateAppearance() {
        let theme = ThemeManager.currentTheme()
        
        self.bar.backgroundColor = .black
        self.bar.layer.cornerRadius = 7
        
        self.backgroundColor = theme.backgroundColor
        
        
        super.updateAppearance()
    }
    public override func startCell() {
        super.startCell()
        
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let theme = ThemeManager.currentTheme()

        let legendText = NSMutableAttributedString()
        
//        var lastYpos: CGFloat = 0
        
        var index = 0
        var lastXpos: CGFloat = 0
        
        for t in self.titles {
            if index != 0 {
                legendText.append(NSAttributedString(string: ", ",
                                                     attributes: [
                                                        NSAttributedString.Key.foregroundColor: theme.titleTextColor,
                                                        NSAttributedString.Key.font: UIFont(name: theme.fontRegular, size: theme.fontSizeContentMedium) as Any
                                                     ]))
            }
            
            legendText.append(NSAttributedString(string: t,
                                                 attributes: [
                                                    NSAttributedString.Key.foregroundColor: self.colors[index],
                                                    NSAttributedString.Key.font: UIFont(name: theme.fontRegular, size: theme.fontSizeContentMedium) as Any
                                                 ]))
            
            
            
            let v = self.values[index]
            
            let segment = UIView(frame: CGRect(x: lastXpos,
                                               y: 0,
                                               width: self.bar.frame.size.width / 100 * CGFloat(v),
                                               height: self.bar.frame.size.height))
            segment.backgroundColor = self.colors[index]
            
            self.bar.addSubview(segment)
            
            lastXpos = lastXpos + segment.frame.width
            index += 1
        }
        self.legend.attributedText = legendText
        
    }

    public override func updateConstraints() {
        
        let theme = ThemeManager.currentTheme()
        
        left.constant = theme.contentInsetFromDisplayBorder
        right.constant = theme.contentInsetFromDisplayBorder
        
        super.updateConstraints()
    }
}
