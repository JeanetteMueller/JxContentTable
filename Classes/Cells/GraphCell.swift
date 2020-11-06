//
//  GraphCell.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 24.04.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import UIKit
#if os(OSX) || os(iOS)
    import ScrollableGraphView
#endif
import JxThemeManager

public extension UITableViewController {
    func registerGraphCell() {
        self.tableView.register(GraphCell.classForCoder(), forCellReuseIdentifier: JxContentTableViewCell.GraphCell.rawValue)
        self.tableView.register(UINib(nibName: "GraphCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: JxContentTableViewCell.GraphCell.rawValue)
    }
}

public extension DetailViewCell {

    enum GraphCellDirection {
        case leftToRight, rightToLeft
    }

    class func GraphCell(withData data: [Double], andLabels labels: [String], andMaxRange maxRange: Double, unit unitString: String? = nil, direction displayDirection: GraphCellDirection = .leftToRight, andHeight height: CGFloat) -> ContentTableViewCellData {
        var dict = ["cell": JxContentTableViewCell.GraphCell,
                    "height": height,
                    "data": data as Any,
                    "labels": labels as Any,
                    "maxRange": maxRange as Any,
                    "direction": displayDirection]

        if let unit = unitString {
            dict["unit"] = unit
        }

        return dict
    }
}

public class GraphCell: DetailViewCell {

    #if os(OSX) || os(iOS)
    var graph: ScrollableGraphView?

    #endif
    var data = [Double]()
    var labels = [String]()

    var direction = GraphCellDirection.leftToRight
    var maxRange: Double = 1
    var unit: String?

    func update(withData data: [Double], andLabels labels: [String], andMaxRange maxRange: Double, unit unitString: String? = nil, direction displayDirection: GraphCellDirection = .leftToRight, andHeight height: CGFloat) {

        self.data = data
        self.labels = labels
        self.direction = displayDirection
        self.maxRange = maxRange
        self.unit = unitString

        self.viewWithTag(9989)?.removeFromSuperview()

    }
    public override func updateAppearance() {

        #if os(OSX) || os(iOS)

            graph?.backgroundFillColor = UIColor.clear

        #endif
    }
    public override func startCell() {
        #if os(OSX) || os(iOS)

        let graphView = ScrollableGraphView(frame: self.bounds)
        graphView.backgroundFillColor = UIColor.clear

        graphView.tag = 9989

            if graphView.dataSource == nil {
                graphView.dataSource = self

                let theme = ThemeManager.currentTheme()

                let animationDuration: Double = 1.0

                graphView.backgroundFillColor = UIColor.clear
                graphView.shouldAnimateOnStartup = true

                let linePlot = LinePlot(identifier: "linePlot")
                let dotPlot = DotPlot(identifier: "dotPlot")
                let referenceLine = ReferenceLines()

                linePlot.lineColor = theme.subtitleTextColor
                linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
                linePlot.lineWidth = 1.0
                linePlot.animationDuration = animationDuration
                linePlot.adaptAnimationType = .elastic
                linePlot.shouldFill = true

                linePlot.fillType = ScrollableGraphViewFillType.gradient
                linePlot.fillColor = theme.color.withAlphaComponent(0.9)
                linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
                linePlot.fillGradientStartColor = linePlot.fillColor
                linePlot.fillGradientEndColor = theme.color.withAlphaComponent(0.0)

                dotPlot.dataPointSize = 2
                dotPlot.dataPointFillColor = theme.titleTextColor
                dotPlot.animationDuration = animationDuration
                dotPlot.adaptAnimationType = .elastic

                referenceLine.shouldShowLabels = true
                referenceLine.shouldShowReferenceLineUnits = true
                referenceLine.shouldShowReferenceLines = true

                referenceLine.referenceLineLabelFont = UIFont(name: theme.fontMedium, size: 8)!
                referenceLine.referenceLineColor = theme.subtitleTextColor.withAlphaComponent(0.2)
                referenceLine.referenceLineLabelColor = theme.titleTextColor

                referenceLine.dataPointLabelColor = theme.titleTextColor

                graphView.shouldAdaptRange = true
                graphView.addReferenceLines(referenceLines: referenceLine)
                graphView.addPlot(plot: linePlot)
                graphView.addPlot(plot: dotPlot)

                graphView.rangeMax = self.maxRange

                referenceLine.referenceLineUnits = self.unit

                graphView.dataPointSpacing = (frame.size.width - (graphView.leftmostPointPadding + graphView.rightmostPointPadding)) / CGFloat(7-1)

                if direction == .rightToLeft {
                    graphView.direction = .rightToLeft
                } else {
                    graphView.direction = .leftToRight
                }
            }
        self.graph = graphView
        self.addSubview(graphView)


        graphView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        graphView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        graphView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        graphView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true


        #endif
    }
    public class func getWeekDays() -> [String] {

        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateFormat = "EEE"

        return [
            formatter.string(for: Date(timeIntervalSince1970: (60*60*24)*4))!,
            formatter.string(for: Date(timeIntervalSince1970: (60*60*24)*5))!,
            formatter.string(for: Date(timeIntervalSince1970: (60*60*24)*6))!,
            formatter.string(for: Date(timeIntervalSince1970: (60*60*24)*7))!,
            formatter.string(for: Date(timeIntervalSince1970: (60*60*24)*8))!,
            formatter.string(for: Date(timeIntervalSince1970: (60*60*24)*9))!,
            formatter.string(for: Date(timeIntervalSince1970: (60*60*24)*10))!
        ]
    }
}

extension GraphCell: ScrollableGraphViewDataSource {
    public func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.

        if data.count > pointIndex {
            switch(plot.identifier) {
            case "linePlot":
                return data[pointIndex]
            case "dotPlot":
                return data[pointIndex]
            default:
                return 0
            }
        }
        return 0
    }

    public func label(atIndex pointIndex: Int) -> String {
        return labels[pointIndex]
    }

    public func numberOfPoints() -> Int {
        return labels.count
    }
}
