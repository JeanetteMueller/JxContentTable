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
    public var content = [[JxContentTableViewCell]]()
    
    open func contentTableViewCellData(for indexPath:IndexPath) -> JxContentTableViewCell? {
        if content.count > indexPath.section && content[indexPath.section].count > indexPath.row {
            
            let data = content[indexPath.section][indexPath.row]
            
            return data
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
            
            let data = content[indexPath.section][indexPath.row]
            
            switch data {
            case let JxContentTableViewCell.BasicCell(config):
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: data.reusableCellIdentifier, for: indexPath) as? BasicCell {
                    cell.cellImageView.alpha = theme.imageAlpha
                    
                    cell.setNeedsUpdateConstraints()
                    
                    if let font = config.font {
                        cell.cellLabel.font = theme.getFont(name: font.familyName, size: font.pointSize)
                    }else{
                        cell.cellLabel.font = UIFont.preferredFont(forTextStyle: .headline)
                    }
                    
                    cell.cellLabel.lineBreakMode = .byWordWrapping
                    
                    cell.cellLabel.backgroundColor = UIColor.clear
                    cell.cellLabel.adjustsFontForContentSizeCategory = true
                    cell.cellLabel.minimumScaleFactor = 0.5
                    
                    cell.cellLabel.text = config.title
                    cell.accessibilityLabel = config.title
                    
                    if let image = config.image {
                        cell.cellImageView.image = image
                        
                        cell.cellImageView.accessibilityIgnoresInvertColors = true
                        
                    } else {
                        cell.cellImageView.image = nil
                    }
                    cell.cellLabel.textAlignment = config.align
                    
                    
                    cell.accessoryType = .none
                    
                    if config.isSelected == true {
                        
                        cell.accessoryType = .checkmark
                        
                    }else if config.action != nil {
                        if config.hideDisclosureIndicator == true {
                            cell.accessoryType = .none
                        }else{
                            cell.accessoryType = .disclosureIndicator
                            cell.accessoryView?.accessibilityLabel = config.title
                        }
                    } else {
                        cell.accessoryType = .none
                    }
                    
                    
                    if let textColor = config.textColor {
                        cell.cellLabel.textColor = textColor
                    } else {
                        cell.cellLabel.textColor = theme.titleTextColor
                    }
                    
                    
                    cell.updateAppearance()
                    return cell
                }
            case let JxContentTableViewCell.RightDetailCell(config):
                if let cell = tableView.dequeueReusableCell(withIdentifier: data.reusableCellIdentifier, for: indexPath) as? RightDetailCell {
                    
                    cell.leftText.text = config.left
                    cell.accessibilityLabel = config.left
                    
                    cell.rightText.text = config.right
                    
                    if config.action != nil {
                        cell.accessoryType = .disclosureIndicator
                        cell.accessoryView?.accessibilityLabel = config.left
                    } else {
                        cell.accessoryType = .none
                    }
                    
                    if let font = config.leftFont  {
                        cell.leftText.font = theme.getFont(name: font.familyName, size: font.pointSize)
                    }
                    
                    if let font = config.rightFont  {
                        cell.rightText.font = theme.getFont(name: font.familyName, size: font.pointSize)
                    }
                    
                    if let textColor = config.leftColor {
                        cell.leftText.textColor = textColor
                    } else {
                        cell.leftText.textColor = theme.titleTextColor
                    }
                    
                    if let textColor = config.rightColor  {
                        cell.rightText.textColor = textColor
                    } else {
                        cell.rightText.textColor = theme.titleTextColor
                    }
                    
                    if config.isSelected {
                        cell.accessoryType = .checkmark
                    }else {
                        cell.accessoryType = .none
                    }
                    
                    cell.setNeedsUpdateConstraints()
                    cell.updateAppearance()
                    return cell
                }
            case let JxContentTableViewCell.SubtitleCell(config):
                if let cell = tableView.dequeueReusableCell(withIdentifier: data.reusableCellIdentifier, for: indexPath) as? SubtitleCell {
                    
                    cell.textLabel?.text = config.title
                    cell.accessibilityLabel = config.title
                    cell.detailTextLabel?.text = config.subTitle
                    
                    cell.imageView?.alpha = theme.imageAlpha
                    
                    if let image = config.image {
                        cell.imageView?.image = image
                        cell.imageView?.clipsToBounds = true
                        cell.imageView?.accessibilityIgnoresInvertColors = true
                        cell.imageView?.layer.cornerRadius = config.height ?? 50 / 100 * theme.cornerRadiusPercent
                        cell.imageView?.layer.cornerCurve = .continuous
                    }
                    
                    if config.action != nil {
                        cell.accessoryType = .disclosureIndicator
                        cell.accessoryView?.accessibilityLabel = config.title
                    } else {
                        cell.accessoryType = .none
                    }
                    
                    if let font = config.titleFont {
                        cell.textLabel?.font = font
                    }
                    if let subfont = config.subTitleFont{
                        cell.detailTextLabel?.font = subfont
                    }
                    
                    if let titleColor = config.titleColor {
                        cell.textLabel?.textColor = titleColor
                    }
                    if let subtitleTextColor = config.subTitleColor {
                        cell.detailTextLabel?.textColor = subtitleTextColor
                    }
                    
                    cell.setNeedsUpdateConstraints()
                    cell.updateAppearance()
                    return cell
                }
            case let JxContentTableViewCell.BubbleCell(config):
                if let cell = tableView.dequeueReusableCell(withIdentifier: data.reusableCellIdentifier, for: indexPath) as? BubbleCell {
                    
                    cell.titleLabel?.text = config.title
                    cell.accessibilityLabel = config.title
                    if let font = config.font {
                        cell.titleLabel?.font = theme.getFont(name: font.familyName, size: font.pointSize)
                    }
                    
                    cell.setNeedsUpdateConstraints()
                    cell.updateAppearance()
                    
                    if let bubbleView = cell.bubbleView {
                        
                        let bubblePadding:CGFloat = 8
                        
                        if let height = config.height {
                            bubbleView.layer.cornerRadius = (height - bubblePadding*2)/2
                            bubbleView.layer.cornerCurve = .continuous
                        }
                    }
                    return cell
                }
            case let JxContentTableViewCell.LogoCell(config):
                if let cell = tableView.dequeueReusableCell(withIdentifier: data.reusableCellIdentifier, for: indexPath) as? LogoCell {
                    cell.accessoryType = .none
                    
                    cell.logoView.alpha = theme.imageAlpha
                    
                    cell.logoView.accessibilityIgnoresInvertColors = true
                    
                    if let logoPath = config.logo {
                        cell.logoView.image = theme.fallbackImage
                        cell.loadLogo(logoPath: logoPath)
                    } else if let imageName = config.imageName {
                        cell.logoView.image = UIImage(named: imageName)
                    }
                    
                    if config.action != nil {
                        cell.accessoryType = .disclosureIndicator
                        cell.accessoryView?.accessibilityLabel = "Change Logo"
                    } else {
                        cell.accessoryType = .none
                    }
                    
                    cell.setNeedsUpdateConstraints()
                    cell.updateAppearance()
                    return cell
                }
            case let JxContentTableViewCell.SwitchCell(config):
                if let cell = tableView.dequeueReusableCell(withIdentifier: data.reusableCellIdentifier, for: indexPath) as? SwitchCell {
                    cell.accessoryType = .none
                    cell.titleLabel.text = config.title
                    cell.accessibilityLabel = config.title
#if os(iOS)
                    cell.switchButton.isOn = config.on
#endif
                    if let font = config.font {
                        cell.titleLabel.font = theme.getFont(name: font.familyName, size: font.pointSize)
                    }
                    cell.titleLabel.textColor = theme.titleTextColor
                    cell.setNeedsUpdateConstraints()
                    cell.updateAppearance()
                    return cell
                }
            case let JxContentTableViewCell.InputCell(config):
                if let cell = tableView.dequeueReusableCell(withIdentifier: data.reusableCellIdentifier, for: indexPath) as? InputCell {
                    cell.accessoryType = .none
                    cell.inputTextField.text = config.text
                    cell.accessibilityLabel = config.text
                    cell.inputTextField.keyboardType = config.keyboardType
                    cell.inputTextField.returnKeyType = config.returnKeyType
                    cell.inputTextField.font = theme.getFont(name: theme.fontRegular, size: 16)
                    let attributes = [
                        NSAttributedString.Key.foregroundColor: theme.textFieldPlaceholderTextColor,
                        NSAttributedString.Key.font: theme.getFont(name: theme.fontRegular, size: 16) as Any
                    ]
                    
                    cell.inputTextField.attributedPlaceholder = NSAttributedString(string: config.placeholder ?? "" , attributes: attributes)
                    
                    cell.delegate = self
                    cell.selectionStyle = .none
                    cell.setNeedsUpdateConstraints()
                    cell.updateAppearance()
                    return cell
                }
            case let JxContentTableViewCell.UrlInputCell(config):
                if let cell = tableView.dequeueReusableCell(withIdentifier: data.reusableCellIdentifier, for: indexPath) as? UrlInputCell {
                    cell.accessoryType = .none
                    cell.urlTextField.text = config.text
                    cell.accessibilityLabel = config.text
                    cell.urlTextField.keyboardType = UIKeyboardType.URL
                    cell.urlTextField.returnKeyType = config.returnKey
                    cell.urlTextField.font = theme.getFont(name: theme.fontRegular, size: 16)
                    
                    let attributes = [
                        NSAttributedString.Key.foregroundColor: theme.textFieldPlaceholderTextColor,
                        NSAttributedString.Key.font: theme.getFont(name: theme.fontRegular, size: 16) as Any
                    ]
                    cell.urlTextField.attributedPlaceholder = NSAttributedString(string: config.placeholder ?? "" , attributes: attributes)
                    
                    cell.delegate = self
                    cell.selectionStyle = .none
                    cell.setNeedsUpdateConstraints()
                    cell.updateAppearance()
                    return cell
                }
            case let JxContentTableViewCell.ProgressCell(config):
                if let cell = tableView.dequeueReusableCell(withIdentifier: data.reusableCellIdentifier, for: indexPath) as? ProgressCell {
                    cell.updateProgress(withPercent: config.value, orProgress: config.progress)
                    cell.accessoryType = .none
                    if let text = config.title {
                        cell.titleLabel.text = text
                        cell.textValue = text
                    }
                    if let font = config.font {
                        cell.titleLabel.font = font
                    }
                    if let download = config.urlString {
                        cell.downloadUrlString = download
                    }
                    cell.titleLabel?.textColor = theme.titleTextColor
                    cell.setNeedsUpdateConstraints()
                    cell.updateAppearance()
                    return cell
                }
            case let JxContentTableViewCell.StepperCell(config):
                if let cell = tableView.dequeueReusableCell(withIdentifier: data.reusableCellIdentifier, for: indexPath) as? StepperCell {
                    cell.accessoryType = .none
                    cell.titleLabel.text = config.title
                    cell.accessibilityLabel = config.title
                    if let font = config.font {
                        cell.titleLabel?.font = theme.getFont(name: font.familyName, size: font.pointSize)
                    }
                    cell.defaultValue = config.value
                    cell.min = config.min
                    cell.max = config.max
                    cell.stepSize = config.stepSize
                    cell.displayFormat = config.displayFormat
                    cell.delegate = self
                    cell.selectionStyle = .none
                    
                    cell.titleLabel.textColor = theme.titleTextColor
                    cell.setNeedsUpdateConstraints()
                    cell.updateAppearance()
                    return cell
                }
            case let JxContentTableViewCell.TitleCell(config):
                if let cell = tableView.dequeueReusableCell(withIdentifier: data.reusableCellIdentifier, for: indexPath) as? TitleCell {
                    cell.titleLabel?.text = config.title
                    cell.accessibilityLabel = config.title
                    if let font = config.font {
                        cell.titleLabel?.font = theme.getFont(name: font.familyName, size: font.pointSize)
                    }
                    if config.action != nil {
                        cell.accessoryType = .disclosureIndicator
                        cell.accessoryView?.accessibilityLabel = config.title
                    } else {
                        cell.accessoryType = .none
                    }
                    cell.titleLabel?.textColor = theme.titleTextColor
                    cell.setNeedsUpdateConstraints()
                    cell.updateAppearance()
                    return cell
                }
            case let JxContentTableViewCell.ButtonCell(config):
                if let cell = tableView.dequeueReusableCell(withIdentifier: data.reusableCellIdentifier, for: indexPath) as? ButtonCell {
                    cell.accessoryType = .none
                    cell.updateWithTitle(config.title)
                    cell.accessibilityLabel = config.title
                    cell.setNeedsUpdateConstraints()
                    cell.updateAppearance()
                    return cell
                }
            case let JxContentTableViewCell.GraphCell(config):
                if let cell = tableView.dequeueReusableCell(withIdentifier: data.reusableCellIdentifier, for: indexPath) as? GraphCell {
                    cell.accessoryType = .none
                    cell.update(withData: config.data, andLabels: config.labels, andMaxRange: config.maxRange, unit: config.unit, direction: config.direction)
                    cell.setNeedsUpdateConstraints()
                    cell.updateAppearance()
                    return cell
                }
            case let JxContentTableViewCell.CaruselCell(config):
                if let cell = tableView.dequeueReusableCell(withIdentifier: data.reusableCellIdentifier, for: indexPath) as? CaruselCell {
                    cell.accessoryType = .none
                    cell.delegate = self
                    cell.configureCell(withDataSource: config.source)
                    cell.setNeedsUpdateConstraints()
                    cell.updateAppearance()
                    return cell
                }
            case let .SegmentBarCell(config):
                if let cell = tableView.dequeueReusableCell(withIdentifier: data.reusableCellIdentifier, for: indexPath) as? SegmentBarCell {
                    cell.accessoryType = .none
                    
                    cell.values = config.values
                    cell.titles = config.titles
                    cell.colors = config.colors
                    
                    cell.setNeedsUpdateConstraints()
                    cell.updateAppearance()
                    return cell
                }
            case let .CustomCell(config):
                if let cell = tableView.dequeueReusableCell(withIdentifier: config.cell, for: indexPath) as? DetailViewCell {
                    cell.accessoryType = .none
                    
                    cell.setNeedsUpdateConstraints()
                    cell.updateAppearance()
                    return cell
                }
            }
            
        }
        
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return defaultCell
    }
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let theme = ThemeManager.currentTheme()
        
        if content.count > indexPath.section && content[indexPath.section].count > indexPath.row {
            
            let data = content[indexPath.section][indexPath.row]
            
            var newHeight: CGFloat = 0
            var minHeight: CGFloat = theme.tableViewCellDefaultHeight
            
            var font = UIFont.preferredFont(forTextStyle: .body)
            
            var text: String?
            var textFont: UIFont?
            var sub: String?
            var subFont: UIFont?
            var textFrameReduce: CGFloat?
            
            switch data {
            case let .BasicCell(config):
                text = config.title
                textFont = config.font
                if let h = config.height {
                    minHeight = h
                }
            case let .RightDetailCell(config):
                text = config.left
                textFont = config.leftFont
                textFrameReduce = config.textFrameReduce
                if let h = config.height {
                    minHeight = h
                }
            case let .SubtitleCell(config):
                text = config.title
                textFont = config.titleFont
                sub = config.subTitle
                subFont = config.subTitleFont
                if let h = config.height {
                    minHeight = h
                }
            case let .BubbleCell(config):
                text = config.title
                textFont = config.font
                if let h = config.height {
                    minHeight = h
                }
            case let .LogoCell(config):
                if let h = config.height {
                    minHeight = h
                }
            case let .TitleCell(config):
                text = config.title
                textFont = config.font
                if let h = config.height {
                    minHeight = h
                }
            case let .SwitchCell(config):
                text = config.title
                textFont = config.font
                if let h = config.height {
                    minHeight = h
                }
            case let .InputCell(config):
                if let h = config.height {
                    minHeight = h
                }
            case let .UrlInputCell(config):
                if let h = config.height {
                    minHeight = h
                }
            case let .StepperCell(config):
                if let h = config.height {
                    minHeight = h
                }
            case let .ProgressCell(config):
                if let h = config.height {
                    minHeight = h
                }
            case let .ButtonCell(config):
                if let h = config.height {
                    minHeight = h
                }
            case let .CustomCell(config):
                if let h = config.height {
                    minHeight = h
                }
            case let .GraphCell(config):
                if let h = config.height {
                    minHeight = h
                }
            case let .CaruselCell(config):
                if let h = config.height {
                    minHeight = h
                }
            case let .SegmentBarCell(config):
                if let h = config.height {
                    minHeight = h
                }
            }
            
            
            
            if let text {
                
                if let customFont = textFont {
                    let theme = ThemeManager.currentTheme()
                    if let f = theme.getFont(name: customFont.familyName, size: customFont.pointSize) {
                        font = f
                    }
                }
                
                let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font as Any])
                
                var width = self.view.frame.size.width - (theme.contentInsetFromDisplayBorder * 2)
                
                if let textFrameReduce {
                    width = self.view.frame.size.width - textFrameReduce
                }
                
                let rect = attributedText.boundingRect(with: CGSize(width: width,
                                                                    height: CGFloat.greatestFiniteMagnitude),
                                                       options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                       context: nil)
                
                newHeight += CGFloat(ceilf(Float(rect.size.height)) + 12.0)
                
            }
            if let text = sub {
                
                if let customFont = subFont {
                    let theme = ThemeManager.currentTheme()
                    if let f = theme.getFont(name: customFont.familyName, size: customFont.pointSize) {
                        font = f
                    }
                }
                
                let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font as Any])
                
                var width = self.view.frame.size.width - (theme.contentInsetFromDisplayBorder * 2)
                
                if let textFrameReduce {
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
        return 0
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
            
            let data = content[indexPath.section][indexPath.row]
            
            switch (data) {
            case .GraphCell(_):
                break
            case .BasicCell(_):
                if let action = data.getAction() as? ContentTableViewCellData.Action,
                   let cell = tableView.cellForRow(at: indexPath) as? BasicCell {
                    action(self, cell, indexPath)
                }
            case .RightDetailCell(_):
                if let action = data.getAction() as? ContentTableViewCellData.Action,
                   let cell = tableView.cellForRow(at: indexPath) as? RightDetailCell {
                    action(self, cell, indexPath)
                }
            case .SubtitleCell(_):
                if let action = data.getAction() as? ContentTableViewCellData.Action,
                   let cell = tableView.cellForRow(at: indexPath) as? SubtitleCell {
                    action(self, cell, indexPath)
                }
            case .BubbleCell(_):
                if let action = data.getAction() as? ContentTableViewCellData.Action,
                   let cell = tableView.cellForRow(at: indexPath) as? BubbleCell {
                    action(self, cell, indexPath)
                }
            case .LogoCell(_):
                if let action = data.getAction() as? ContentTableViewCellData.Action,
                   let cell = tableView.cellForRow(at: indexPath) as? LogoCell {
                    action(self, cell, indexPath)
                }
            case .TitleCell(_):
                if let action = data.getAction() as? ContentTableViewCellData.Action,
                   let cell = tableView.cellForRow(at: indexPath) as? TitleCell {
                    action(self, cell, indexPath)
                }
            case .SwitchCell(_):
                if let action = data.getAction() as? DetailViewCell.SwitchCellAction,
                   let cell = tableView.cellForRow(at: indexPath) as? SwitchCell {
                    
                    var newValue = false
                    if let switchButton = cell.switchButton {
                        newValue = !switchButton.isOn
                        switchButton.setOn(newValue, animated: true)
                    }
                    action(cell, indexPath, newValue)
                }
            case .InputCell(_):
                break
            case .UrlInputCell(_):
                break
            case .StepperCell(_):
                break
            case .ProgressCell(_):
                if let action = data.getAction() as? DetailViewCell.ProgressCellAction,
                   let cell = tableView.cellForRow(at: indexPath) as? ProgressCell {
                    var percent: Float = 0
                    if let progressBar = cell.progressBar {
                        percent = progressBar.progress
                    }
                    action(cell, indexPath, percent)
                }
            case .ButtonCell(_):
                if let action = data.getAction() as? ContentTableViewCellData.Action,
                   let cell = tableView.cellForRow(at: indexPath) as? ButtonCell {
                    action(self, cell, indexPath)
                }
            case .CaruselCell(_):
                break
            case .SegmentBarCell(_):
                break
            case .CustomCell(_):
                if let action = data.getAction() as? ContentTableViewCustomCellData.Action,
                   let cell = tableView.cellForRow(at: indexPath) as? DetailViewCell {
                    action(self, cell, indexPath)
                }
            }
        }
    }
    
    // MARK: ScrollviewDelegate
    //nicht als extension nutzbar da sonst override nicht mehr klappt
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let theme = ThemeManager.currentTheme()
        if let contentSecondArray = self.content.first,
           let cellType = contentSecondArray.first{
            
            switch cellType {
            case .LogoCell:
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LogoCell {
                    cell.updateCell(withOffset: scrollView.contentOffset.y + self.tableView.layoutMargins.top)
                }
            default:
                break
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

