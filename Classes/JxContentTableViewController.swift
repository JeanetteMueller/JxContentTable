//
//  JxContentTableViewController.swift
//  JxContentTable
//
//  Created by Jeanette Müller on 03.11.20.
//

import UIKit
import JxThemeManager
import JxSwiftHelper

open class JxContentTableViewController: JxBasicTableViewController, CaruselDelegate {
    
    public var headlines = [String]()
    public var headlinesDetail = [String]()
    public var content = [[ContentTableViewCellData]]()
    
    open func contentTableViewCellData(for indexPath:IndexPath) -> ContentTableViewCellData? {
        if content.count > indexPath.section && content[indexPath.section].count > indexPath.row {
            
            let dict = content[indexPath.section][indexPath.row]
            
            return dict
        }
        return nil
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        
    }
    open func registerCells() {
        
        self.registerBasicCell()
        self.registerLogoCell()
        self.registerRightDetailCell()
        self.registerSubtitleCell()
        self.registerBubbleCell()
        self.registerSwitchCell()
        self.registerTitleCell()
        self.registerInputCell()
        self.registerUrlInputCell()
        self.registerStepperCell()
        self.registerButtonCell()
        self.registerGraphCell()
        self.registerCaruselCell()
        self.registerSegmentBarCell()
        
        //Header
        self.registerAllHeader()
    }
    open func registerAllHeader() {
        
    }
    open func prepareContent() {
        log("the method \"prepareContent\" you have to override")
        
        self.headlines.removeAll()
        self.headlinesDetail.removeAll()
        self.content.removeAll()
    }
    
    open func reload() {
        self.prepareContent()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
            self.updateVisibleTableHeader()
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        #if os(OSX) || os(iOS)
        self.tableView.separatorStyle = .none
        #endif
        
        self.prepareContent()
        
        self.updateAppearance()
        
        self.updateVisibleTableHeader()
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.contentInset = UIEdgeInsets(top: self.tableView.contentInset.top,
                                                   left: self.tableView.contentInset.left,
                                                   bottom: self.tableView.contentInset.bottom == 0 ? 25 : self.tableView.contentInset.bottom,
                                                   right: self.tableView.contentInset.right)
    }
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            self.tableView.reloadData()
        }) { (_) in
            //done
            
            self.tableView.reloadData()
        }
    }
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return content.count
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if content.count > section {
            return content[section].count
        }
        return 0
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let theme = ThemeManager.currentTheme()
        
        if content.count > indexPath.section && content[indexPath.section].count > indexPath.row {
            
            let dict = content[indexPath.section][indexPath.row]
            
            if let cellType = dict["cell"] as? JxContentTableViewCell {
                switch (cellType) {
                case JxContentTableViewCell.BasicCell:
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? BasicCell {
                        cell.cellImageView.alpha = theme.imageAlpha
                        
                        cell.setNeedsUpdateConstraints()
                        
                        if let font = dict["font"] as? UIFont {
                            cell.cellLabel.font = theme.getFont(name: font.familyName, size: font.pointSize)
                        }else{
                            cell.cellLabel.font = UIFont.preferredFont(forTextStyle: .headline)
                        }
                        
                        cell.cellLabel.lineBreakMode = .byWordWrapping

                        cell.cellLabel.backgroundColor = UIColor.clear
                        cell.cellLabel.adjustsFontForContentSizeCategory = true
                        cell.cellLabel.minimumScaleFactor = 0.5
                        
                        cell.cellLabel.text = dict["text"] as? String
                        cell.accessibilityLabel = dict["text"] as? String
                        
                        if let image = dict["image"] {
                            cell.cellImageView.image = image as? UIImage
                            
                            cell.cellImageView.accessibilityIgnoresInvertColors = true
                            
                        } else {
                            cell.cellImageView.image = nil
                        }
                        if let textAlignment = dict["align"] as? NSTextAlignment {
                            cell.cellLabel.textAlignment = textAlignment
                        }
                        
                        cell.accessoryType = .none
                        
                        if let isSelected = dict["selected"] as? Bool, isSelected == true {
                            
                            cell.accessoryType = .checkmark
                            
                        }else if dict["action"] != nil {
                            if let hideDisclosureIndicator = dict["hideDisclosureIndicator"] as? Bool, hideDisclosureIndicator == true {
                                cell.accessoryType = .none
                            }else{
                                cell.accessoryType = .disclosureIndicator
                                cell.accessoryView?.accessibilityLabel = dict["text"] as? String
                            }
                        } else {
                            cell.accessoryType = .none
                        }
                        
                        
                        if let textColor = dict["textColor"] as? UIColor {
                            cell.cellLabel.textColor = textColor
                        } else {
                            cell.cellLabel.textColor = theme.titleTextColor
                        }
                        
                        
                        cell.updateAppearance()
                        return cell
                    }
                case JxContentTableViewCell.RightDetailCell:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? RightDetailCell {
                        
                        cell.leftText.text = dict["text"] as? String
                        cell.accessibilityLabel = dict["text"] as? String
                        
                        cell.rightText.text = dict["right"] as? String
                        
                        if dict["action"] != nil {
                            cell.accessoryType = .disclosureIndicator
                            cell.accessoryView?.accessibilityLabel = dict["text"] as? String
                        } else {
                            cell.accessoryType = .none
                        }
                        
                        if let font = dict["leftfont"] as? UIFont {
                            cell.leftText.font = theme.getFont(name: font.familyName, size: font.pointSize)
                        }
                        
                        if let font = dict["rightfont"] as? UIFont {
                            cell.rightText.font = theme.getFont(name: font.familyName, size: font.pointSize)
                        }
                        
                        if let textColor = dict["textColor"] as? UIColor {
                            cell.leftText.textColor = textColor
                        } else {
                            cell.leftText.textColor = theme.titleTextColor
                        }
                        
                        if let textColor = dict["textColorRight"] as? UIColor {
                            cell.rightText.textColor = textColor
                        } else {
                            cell.rightText.textColor = theme.titleTextColor
                        }
                        
                        if let isSelected = dict["selected"] as? Bool {
                            cell.accessoryType = .none
                            if isSelected {
                                cell.accessoryType = .checkmark
                            }
                        }
                        
                        cell.setNeedsUpdateConstraints()
                        cell.updateAppearance()
                        return cell
                    }
                case JxContentTableViewCell.SubtitleCell:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? SubtitleCell {
                        
                        cell.textLabel?.text = dict["text"] as? String
                        cell.accessibilityLabel = dict["text"] as? String
                        cell.detailTextLabel?.text = dict["sub"] as? String
                        
                        cell.imageView?.alpha = theme.imageAlpha
                        
                        if let image = dict["image"] {
                            cell.imageView?.image = image as? UIImage
                            
                            cell.imageView?.accessibilityIgnoresInvertColors = true
                        }
                        
                        if dict["action"] != nil {
                            cell.accessoryType = .disclosureIndicator
                            cell.accessoryView?.accessibilityLabel = dict["text"] as? String
                        } else {
                            cell.accessoryType = .none
                        }
                        
                        if let font = dict["font"] as? UIFont {
                            cell.textLabel?.font = theme.getFont(name: font.familyName, size: font.pointSize)
                        }
                        
                        if let font = dict["subfont"] as? UIFont {
                            cell.detailTextLabel?.font = theme.getFont(name: font.familyName, size: font.pointSize)
                        }
                        cell.textLabel?.textColor = theme.titleTextColor
                        cell.detailTextLabel?.textColor = theme.subtitleTextColor
                        cell.setNeedsUpdateConstraints()
                        cell.updateAppearance()
                        return cell
                    }
                case JxContentTableViewCell.BubbleCell:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? BubbleCell {
                        
                        cell.titleLabel?.text = dict["text"] as? String
                        cell.accessibilityLabel = dict["text"] as? String
                        if let font = dict["font"] as? UIFont {
                            cell.titleLabel?.font = theme.getFont(name: font.familyName, size: font.pointSize)
                        }
                        
                        cell.setNeedsUpdateConstraints()
                        cell.updateAppearance()
                        
                        if let bubbleView = cell.bubbleView {
                            
                            let bubblePadding:CGFloat = 8
                            
                            if let height = dict["height"] as? Int {
                                bubbleView.layer.cornerRadius = (CGFloat(height) - bubblePadding*2)/2
                            } else if let height = dict["height"] as? CGFloat {
                                bubbleView.layer.cornerRadius = (height - bubblePadding*2)/2
                            }
                        }
                        return cell
                    }
                case JxContentTableViewCell.LogoCell:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? LogoCell {
                        cell.accessoryType = .none
                        
                        cell.logoView.alpha = theme.imageAlpha
                        
                        cell.logoView.accessibilityIgnoresInvertColors = true
                        
                        if let logoPath = dict["logo"] as? String {
                            cell.logoView.image = theme.fallbackImage
                            cell.loadLogo(logoPath: logoPath)
                        } else if let imageName = dict["imageName"] as? String {
                            cell.logoView.image = UIImage(named: imageName)
                        }
                        
                        if dict["action"] != nil {
                            cell.accessoryType = .disclosureIndicator
                            cell.accessoryView?.accessibilityLabel = "Change Logo"
                        } else {
                            cell.accessoryType = .none
                        }
                        
                        cell.setNeedsUpdateConstraints()
                        cell.updateAppearance()
                        return cell
                    }
                case JxContentTableViewCell.SwitchCell:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? SwitchCell {
                        cell.accessoryType = .none
                        cell.titleLabel.text = dict["text"] as? String
                        cell.accessibilityLabel = dict["text"] as? String
                        #if os(iOS)
                        cell.switchButton.isOn = dict["on"] as? Bool ?? false
                        #endif
                        if let font = dict["font"] as? UIFont {
                            cell.titleLabel.font = theme.getFont(name: font.familyName, size: font.pointSize)
                        }
                        cell.titleLabel.textColor = theme.titleTextColor
                        cell.setNeedsUpdateConstraints()
                        cell.updateAppearance()
                        return cell
                    }
                case JxContentTableViewCell.InputCell:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? InputCell {
                        cell.accessoryType = .none
                        cell.inputTextField.text = dict["text"] as? String
                        cell.accessibilityLabel = dict["text"] as? String
                        cell.inputTextField.keyboardType = dict["keyboard"] as? UIKeyboardType ?? UIKeyboardType.default
                        cell.inputTextField.returnKeyType = dict["returnKey"] as? UIReturnKeyType ?? UIReturnKeyType.default
                        
                        if let placeHolder = dict["placeholder"] as? String {
                            cell.inputTextField.attributedPlaceholder = NSAttributedString(string: placeHolder,
                                                                                           attributes: [NSAttributedString.Key.foregroundColor: theme.textFieldPlaceholderTextColor])
                        } else {
                            cell.inputTextField.attributedPlaceholder = NSAttributedString(string: "",
                                                                                           attributes: [NSAttributedString.Key.foregroundColor: theme.textFieldPlaceholderTextColor])
                        }
                        cell.delegate = self
                        cell.selectionStyle = .none
                        cell.setNeedsUpdateConstraints()
                        cell.updateAppearance()
                        return cell
                    }
                case JxContentTableViewCell.UrlInputCell:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? UrlInputCell {
                        cell.accessoryType = .none
                        cell.urlTextField.text = dict["text"] as? String
                        cell.accessibilityLabel = dict["text"] as? String
                        cell.urlTextField.keyboardType = UIKeyboardType.URL
                        cell.urlTextField.returnKeyType = dict["returnKey"] as? UIReturnKeyType ?? UIReturnKeyType.default
                        
                        if let placeHolder = dict["placeholder"] as? String {
                            cell.urlTextField.attributedPlaceholder = NSAttributedString(string: placeHolder,
                                                                                         attributes: [NSAttributedString.Key.foregroundColor: theme.textFieldPlaceholderTextColor])
                        } else {
                            cell.urlTextField.attributedPlaceholder = NSAttributedString(string: "",
                                                                                         attributes: [NSAttributedString.Key.foregroundColor: theme.textFieldPlaceholderTextColor])
                        }
                        
                        cell.delegate = self
                        cell.selectionStyle = .none
                        cell.setNeedsUpdateConstraints()
                        cell.updateAppearance()
                        return cell
                    }
                case JxContentTableViewCell.ProgressCell:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? ProgressCell {
                        cell.updateProgress(withPercent: dict["value"] as? Float ?? 0.0, orProgress: dict["progress"] as? Progress)
                        cell.accessoryType = .none
                        if let text = dict["text"] as? String {
                            cell.titleLabel.text = text
                            cell.textValue = text
                        }
                        if let font = dict["font"] as? UIFont {
                            cell.titleLabel.font = theme.getFont(name: font.familyName, size: font.pointSize)
                        }
                        if let download = dict["download"] as? String {
                            cell.downloadUrlString = download
                        }
                        cell.titleLabel?.textColor = theme.titleTextColor
                        cell.setNeedsUpdateConstraints()
                        cell.updateAppearance()
                        return cell
                    }
                case JxContentTableViewCell.StepperCell:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? StepperCell {
                        cell.accessoryType = .none
                        cell.titleLabel.text = dict["text"] as? String
                        cell.accessibilityLabel = dict["text"] as? String
                        if let font = dict["font"] as? UIFont {
                            cell.titleLabel?.font = theme.getFont(name: font.familyName, size: font.pointSize)
                        }
                        cell.defaultValue = dict["value"] as? Double ?? 0
                        cell.min = dict["min"] as? Double ?? 0
                        cell.max = dict["max"] as? Double ?? 1
                        cell.stepSize = dict["step"] as? Double ?? 0.1
                        cell.displayFormat = dict["displayFormat"] as? String ?? ""
                        cell.delegate = self
                        cell.selectionStyle = .none
                        
                        cell.titleLabel.textColor = theme.titleTextColor
                        cell.setNeedsUpdateConstraints()
                        cell.updateAppearance()
                        return cell
                    }
                case JxContentTableViewCell.TitleCell:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? TitleCell {
                        
                        cell.titleLabel?.text = dict["text"] as? String
                        cell.accessibilityLabel = dict["text"] as? String
                        if let font = dict["font"] as? UIFont {
                            cell.titleLabel?.font = theme.getFont(name: font.familyName, size: font.pointSize)
                        }
                        if dict["action"] != nil {
                            cell.accessoryType = .disclosureIndicator
                            cell.accessoryView?.accessibilityLabel = dict["text"] as? String
                        } else {
                            cell.accessoryType = .none
                        }
                        cell.titleLabel?.textColor = theme.titleTextColor
                        cell.setNeedsUpdateConstraints()
                        cell.updateAppearance()
                        return cell
                        
                    }
                case JxContentTableViewCell.ButtonCell:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? ButtonCell {
                        cell.accessoryType = .none
                        cell.updateWithTitle(dict["buttonTitle"] as? String)
                        cell.accessibilityLabel = dict["buttonTitle"] as? String
                        cell.setNeedsUpdateConstraints()
                        cell.updateAppearance()
                        return cell
                    }
                case JxContentTableViewCell.GraphCell:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? GraphCell {
                        cell.accessoryType = .none
                        
                        if let data = dict["data"] as? [Double], let labels = dict["labels"] as? [String], let maxRange = dict["maxRange"] as? Double, let height = dict["height"] as? CGFloat, let direction = dict["direction"] as? DetailViewCell.GraphCellDirection {
                            cell.update(withData: data, andLabels: labels, andMaxRange: maxRange, unit: dict["unit"] as? String, direction: direction, andHeight: height)
                        }
                        cell.setNeedsUpdateConstraints()
                        cell.updateAppearance()
                        return cell
                    }
                case JxContentTableViewCell.CaruselCell:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? CaruselCell {
                        cell.accessoryType = .none
                        cell.delegate = self
                        if let source = dict["source"] as? CaruselDataSource {
                            cell.configureCell(withDataSource: source)
                        }
                        cell.setNeedsUpdateConstraints()
                        cell.updateAppearance()
                        return cell
                    }
                case .EpisodeCell:
                    break
                case .EpisodeCollectionCell:
                    break
                case .GroupCell:
                    break
                case .PodcastTableViewCell:
                    break
                case .InfoCell:
                    break
                case .PodcastCell:
                    break
                case .InAppPurchaseCell:
                    break
                case .InAppPurchase3xCell:
                    break
                case .SegmentBarCell:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? SegmentBarCell {
                        cell.accessoryType = .none
                        
                        if let values = dict["values"] as? [Float] {
                            cell.values = values
                        }
                        if let titles = dict["titles"] as? [String] {
                            cell.titles = titles
                        }
                        if let colors = dict["colors"] as? [UIColor] {
                            cell.colors = colors
                        }
                        
                        cell.setNeedsUpdateConstraints()
                        cell.updateAppearance()
                        return cell
                    }
                case .BookmarkCell:
                    break
                }
            }
        }
        
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return defaultCell
    }
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let theme = ThemeManager.currentTheme()
        
        if content.count > indexPath.section && content[indexPath.section].count > indexPath.row {
            
            let dict = content[indexPath.section][indexPath.row]
            
            var minHeight: CGFloat = theme.tableViewCellDefaultHeight
            
            if let h = dict["height"] as? Int {
                minHeight = CGFloat(h)
            } else if let h = dict["height"] as? Float {
                minHeight = CGFloat(h)
            } else if let h = dict["height"] as? CGFloat {
                minHeight = h
            }
            
            
            
            var font = UIFont.preferredFont(forTextStyle: .body)
            
            var newHeight:CGFloat = 0
            
            if let text = dict["text"] as? String {
                
                if let customFont = dict["font"] as? UIFont {
                    let theme = ThemeManager.currentTheme()
                    if let f = theme.getFont(name: customFont.familyName, size: customFont.pointSize) {
                        font = f
                    }
                }
                
                let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font as Any])
                
                var width = self.view.frame.size.width - (theme.contentInsetFromDisplayBorder * 2)
                
                if let textFrameReduce = dict["textFrameReduce"] as? CGFloat {
                    width = self.view.frame.size.width - textFrameReduce
                }
                
                let rect = attributedText.boundingRect(with: CGSize(width: width,
                                                                    height: CGFloat.greatestFiniteMagnitude),
                                                       options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                       context: nil)
                
                newHeight += CGFloat(ceilf(Float(rect.size.height)) + 12.0)
                
            }
            if let text = dict["sub"] as? String {
                
                if let customFont = dict["subfont"] as? UIFont {
                    let theme = ThemeManager.currentTheme()
                    if let f = theme.getFont(name: customFont.familyName, size: customFont.pointSize) {
                        font = f
                    }
                }
                
                let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font as Any])
                
                var width = self.view.frame.size.width - (theme.contentInsetFromDisplayBorder * 2)
                
                if let textFrameReduce = dict["textFrameReduce"] as? CGFloat {
                    width = self.view.frame.size.width - textFrameReduce
                }
                
                let rect = attributedText.boundingRect(with: CGSize(width: width,
                                                                    height: CGFloat.greatestFiniteMagnitude),
                                                       options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                       context: nil)
                
                newHeight += CGFloat(ceilf(Float(rect.size.height)) + 16.0)
                
            }
            
            if newHeight < minHeight {
                newHeight = minHeight
            }
            
            
            return newHeight
        }
        return theme.tableViewCellDefaultHeight
    }
    open override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let c = cell as? DetailViewCell {
            c.startCell()
        }
    }
    open override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let c = cell as? DetailViewCell {
            c.unloadCell()
        }
    }
    open func seactionHeadlineText(forSection section: Int) -> String? {
        if headlines.count > section {
            
            let text = headlines[section]
            if !text.isEmpty {
                return text.replacingOccurrences(of: " ", with: "_")
            }
        }
        return nil
    }
    open func sectionHeadlineDetailText(forSection section: Int) -> String? {
        
        if headlinesDetail.count > section {
            
            let text = headlinesDetail[section]
            if !text.isEmpty {
                return text //.replacingOccurrences(of: " ", with: "_")
            }
        }
        return nil
    }
    
    open override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if seactionHeadlineText(forSection: section) != nil {
            let theme = ThemeManager.currentTheme()
            return theme.tableViewHeadlineHeight
        }
        return 0
    }
    
    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return nil
    }
    open func updateHeader(_ headerView: BasicHeaderView, in section: Int) {
        if self.tableView.numberOfRows(inSection: section) > 0 {
            headerView.tag = section
            self.updateVisibleTableHeader(headerView)
            return
        }
    }
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if content.count > indexPath.section && content[indexPath.section].count > indexPath.row {
            
            let dict = content[indexPath.section][indexPath.row]
            
            if dict["action"] != nil {
                if let cellType = dict["cell"] as? JxContentTableViewCell {
                    switch (cellType) {
                    case JxContentTableViewCell.EpisodeCell:
                        break
                    case JxContentTableViewCell.EpisodeCollectionCell:
                        break
                    case JxContentTableViewCell.BookmarkCell:
                        break
                    case JxContentTableViewCell.GroupCell:
                        break
                    case JxContentTableViewCell.PodcastTableViewCell:
                        break
                    case JxContentTableViewCell.InfoCell:
                        break
                    case JxContentTableViewCell.GraphCell:
                        break
                    case JxContentTableViewCell.PodcastCell:
                        break
                    case JxContentTableViewCell.BasicCell:
                        if let action = dict["action"] as? DetailViewCell.BasicCellAction {
                            if let cell = tableView.cellForRow(at: indexPath) as? BasicCell {
                                action(cell, indexPath)
                            }
                        }
                        break
                    case JxContentTableViewCell.RightDetailCell:
                        if let action = dict["action"] as? DetailViewCell.RightDetailCellAction {
                            if let cell = tableView.cellForRow(at: indexPath) as? RightDetailCell {
                                action(cell, indexPath)
                            }
                        }
                    case JxContentTableViewCell.SubtitleCell:
                        if let action = dict["action"] as? DetailViewCell.SubtitleCellAction {
                            if let cell = tableView.cellForRow(at: indexPath) as? SubtitleCell {
                                action(cell, indexPath)
                            }
                        }
                    case JxContentTableViewCell.BubbleCell:
                        if let action = dict["action"] as? DetailViewCell.BubbleCellAction {
                            if let cell = tableView.cellForRow(at: indexPath) as? BubbleCell {
                                action(cell, indexPath)
                            }
                        }
                    case JxContentTableViewCell.LogoCell:
                        if let action = dict["action"] as? DetailViewCell.LogoCellAction {
                            if let cell = tableView.cellForRow(at: indexPath) as? LogoCell {
                                action(cell, indexPath)
                            }
                        }
                    case JxContentTableViewCell.TitleCell:
                        if let action = dict["action"] as? DetailViewCell.TitleCellAction {
                            if let cell = tableView.cellForRow(at: indexPath) as? TitleCell {
                                action(cell, indexPath)
                            }
                        }
                        break
                    case JxContentTableViewCell.SwitchCell:
                        if let action = dict["action"] as? DetailViewCell.SwitchCellAction {
                            if let cell = tableView.cellForRow(at: indexPath) as? SwitchCell {
                                
                                var newValue = false
                                #if os(OSX) || os(iOS)
                                if let switchButton = cell.switchButton {
                                    newValue = !switchButton.isOn
                                    switchButton.setOn(newValue, animated: true)
                                }
                                #endif
                                action(cell, indexPath, newValue)
                            }
                        }
                        break
                    case JxContentTableViewCell.InputCell:
                        break
                    case JxContentTableViewCell.UrlInputCell:
                        break
                    case JxContentTableViewCell.StepperCell:
                        break
                    case JxContentTableViewCell.ProgressCell:
                        if let action = dict["action"] as? DetailViewCell.ProgressCellAction {
                            if let cell = tableView.cellForRow(at: indexPath) as? ProgressCell {
                                var percent: Float = 0
                                if let progressBar = cell.progressBar {
                                    percent = progressBar.progress
                                }
                                action(cell, indexPath, percent)
                            }
                        }
                        break
                    case JxContentTableViewCell.InAppPurchaseCell:
                        break
                    case JxContentTableViewCell.InAppPurchase3xCell:
                        break
                    case JxContentTableViewCell.ButtonCell:
                        if let action = dict["action"] as? DetailViewCell.ButtonCellAction {
                            if let cell = tableView.cellForRow(at: indexPath) as? ButtonCell {
                                action(cell, indexPath)
                            }
                        }
                        break
                    case JxContentTableViewCell.CaruselCell:
                        break
                    case JxContentTableViewCell.SegmentBarCell:
                        break
                    }
                }
            }
        }
    }
    
    // MARK: ScrollviewDelegate
    //nicht als extension nutzbar da sonst override nicht mehr klappt
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let theme = ThemeManager.currentTheme()
        if let contentSecondArray = self.content.first,
           let first = contentSecondArray.first,
           let cellType = first["cell"] as? JxContentTableViewCell,
           cellType == JxContentTableViewCell.LogoCell {
            
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LogoCell {
                
                cell.updateCell(withOffset: scrollView.contentOffset.y + self.tableView.layoutMargins.top)
            }
        }
        if let paths = self.tableView.indexPathsForVisibleRows {
            
            var section = -1
            for path in paths {
                autoreleasepool {
                    if path.section != section {
                        section = path.section
                        
                        if let headerView = self.tableView.headerView(forSection: section) as? BasicHeaderView {
                            
                            let cellFrame = self.tableView.rectForRow(at: IndexPath(row: 0, section: section))
                            
                            var alpha: CGFloat = ((headerView.frame.origin.y + headerView.frame.size.height ) - cellFrame.origin.y) / theme.headerBackgroundAlphaPerPixel
                            
                            if alpha > 1 {
                                alpha = 1
                            } else if alpha < 0 {
                                alpha = 0
                            }
                            headerView.updateBackground(with: alpha)
                        }
                    }
                }
            }
        }
        
        self.updateVisibleTableHeader()
        
    }
    open override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidScroll(scrollView)
        }
        
    }
    open override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidScroll(scrollView)
    }
    
    // MARK: CaruselDelegate
    //nicht als extension nutzbar da sonst override nicht mehr klappt
    open func didSelectItem(_ item: CaruselItem) {
        
    }
}

