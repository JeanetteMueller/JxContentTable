//
//  ContentTableViewCellData.swift
//  JxContentTable
//
//  Created by Jeanette Müller on 03.11.20.
//

import Foundation

public protocol ContentTableViewCellData {
    
    typealias Action = (_ vc: UIViewController?, _ cell: DetailViewCell, _ indexpath: IndexPath) async -> Void
    
    var height: CGFloat? { get }
}

public protocol ContentTableViewCustomCellData {
    
    typealias Action = (_ vc: UIViewController?, _ cell: DetailViewCell, _ indexpath: IndexPath) async -> Void
    
    var cell: String { get }
    var height: CGFloat? { get }
    
    var action: Action? { get }
}

