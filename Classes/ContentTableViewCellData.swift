//
//  ContentTableViewCellData.swift
//  JxContentTable
//
//  Created by Jeanette Müller on 03.11.20.
//

import Foundation

public protocol ContentTableViewCellData {
    
    typealias Action = (_ vc: UIViewController?, _ cell: DetailViewCell, _ indexpath: IndexPath) -> Void
    
    var height: CGFloat? { get }
}

public protocol ContentTableViewCustomCellData {
    
    var cell: String { get }
    var height: CGFloat? { get }
    
    var action: Any? { get }
}
