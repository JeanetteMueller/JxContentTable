//
//  JxContentTableViewDefinitions.swift
//  JxContentTable
//
//  Created by Jeanette Müller on 03.11.20.
//

import Foundation

public enum JxContentTableViewCell {
    
    case BasicCell(_ config: DetailViewCell.BasicCellData)
    case RightDetailCell(_ config: DetailViewCell.RightDetailCellData)
    case SubtitleCell(_ config: DetailViewCell.SubtitleCellData)
    case BubbleCell(_ config: DetailViewCell.BubbleCellData)
    case LogoCell(_ config: DetailViewCell.LogoCellData)
    case TitleCell(_ config: DetailViewCell.TitleCellData)
    case SwitchCell(_ config: DetailViewCell.SwitchCellData)
    case InputCell(_ config: DetailViewCell.InputCellData)
    case UrlInputCell(_ config: DetailViewCell.UrlInputCellData)
    case StepperCell(_ config: DetailViewCell.StepperCellData)
    case ProgressCell(_ config: DetailViewCell.ProgressCellData)
    case ButtonCell(_ config: DetailViewCell.ButtonCellData)
    case GraphCell(_ config: DetailViewCell.GraphCellData)
    case CaruselCell(_ config: DetailViewCell.CaruselCellData)
    case SegmentBarCell(_ config: DetailViewCell.SegmentBarCellData)
    
    case CustomCell(_ config: any ContentTableViewCustomCellData)
    
    case BookmarkCell
    
    public var reusableCellIdentifier: String {
        return switch self {
        case .BasicCell : "BasicCell"
        case .RightDetailCell: "RightDetailCell"
        case .SubtitleCell: "SubtitleCell"
        case .BubbleCell : "BubbleCell"
        case .LogoCell : "LogoCell"
        case .TitleCell : "TitleCell"
        case .SwitchCell : "SwitchCell"
        case .InputCell : "InputCell"
        case .UrlInputCell : "UrlInputCell"
        case .StepperCell : "StepperCell"
        case .ProgressCell : "ProgressCell"
        case .ButtonCell : "ButtonCell"
        case .GraphCell : "GraphCell"
        case .CaruselCell : "CaruselCell"
        case .SegmentBarCell : "SegmentBarCell"
        case let .CustomCell(config): config.cell
        case .BookmarkCell : "BookmarkCell"
        }
    }
    
    func getAction() -> Any? {
        return switch self {
            
        case let .BasicCell(config):
            config.action as Any
        case let .RightDetailCell(config):
            config.action as Any
        case let .SubtitleCell(config):
            config.action as Any
        case let .BubbleCell(config):
            config.action as Any
        case let .LogoCell(config):
            config.action as Any
        case let .TitleCell(config):
            config.action as Any
        case let .SwitchCell(config):
            config.action as Any
        case let .InputCell(config):
            config.action as Any
        case let .UrlInputCell(config):
            config.action as Any
        case let .StepperCell(config):
            config.action as Any
        case let .ProgressCell(config):
            config.action as Any
        case let .ButtonCell(config):
            config.action as Any
        case let .CustomCell(config):
            config.action
        default:
            nil
        }
    }
}

public enum JxContentTableViewHeader: String {
    case EpisodesHeaderView = "EpisodesHeaderView"
    case SubscriptionsChangeSwitch = "SubscriptionsChangeSwitch"
    case SubscriptionsChangeStepper = "SubscriptionsChangeStepper"
    case SubscriptionsChangeOption = "SubscriptionsChangeOption"
    case PausedHeader = "PausedHeader"
    case EpisodesCollectionHeaderView = "EpisodesCollectionHeaderView"
    case GroupsCollectionHeaderView = "GroupsCollectionHeaderView"
}
