//
//  CaruselCell.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 19.11.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import UIKit

public extension UITableViewController {
    func registerCaruselCell() {
        self.tableView.register(CaruselCell.classForCoder(), forCellReuseIdentifier: JxContentTableViewCell.CaruselCell.rawValue)
        self.tableView.register(UINib(nibName: "CaruselCell", bundle: JxBasicTableViewController.loadBundle), forCellReuseIdentifier: JxContentTableViewCell.CaruselCell.rawValue)
    }
}

public extension DetailViewCell {

    class func CaruselCell(withDataSource source: CaruselDataSource) -> ContentTableViewCellData {
        let dict = ["cell": JxContentTableViewCell.CaruselCell,
                    "height": 100,

                    "source": source as Any]

        return dict

    }
}

public class CaruselCell: DetailViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    public var dataSource: CaruselDataSource?

    public weak var delegate: CaruselDelegate?

    public var didSetupConstraints = false

    @IBOutlet public var collectionView: UICollectionView!

    public override func updateConstraints() {
        if self.didSetupConstraints == false {
            self.didSetupConstraints = true

        }
        super.updateConstraints()
    }
    public override func updateAppearance() {

        //let theme = ThemeManager.currentTheme()

    }

    public func configureCell(withDataSource source: CaruselDataSource) {
        self.dataSource = source

        updateAppearance()

        self.collectionView.register(CaruselCellItem.classForCoder(), forCellWithReuseIdentifier: "CaruselCellItem")
        self.collectionView.register(UINib(nibName: "CaruselCellItem", bundle: JxBasicTableViewController.loadBundle), forCellWithReuseIdentifier: "CaruselCellItem")

        setNeedsUpdateConstraints()
    }

    public override func startCell() {

        self.dataSource?.loadCaruselData(callback: { (_) in
            self.collectionView.reloadData()
        })
    }

    // MARK: UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.numberOfItems() ?? 0
    }

    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CaruselCellItem", for: indexPath) as! CaruselCellItem

        if let item = self.dataSource?.item(at: indexPath.item) {
            cell.configureCell(withItem: item)
        }

        return cell
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if let c = cell as? CaruselCellItem {
            c.startCell()
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let item = self.dataSource?.item(at: indexPath.item) {

            self.delegate?.didSelectItem(item)
        }

    }
}
public protocol CaruselDelegate: AnyObject {
    func didSelectItem(_ item: CaruselItem)
}
public protocol CaruselDataSource {

    func loadCaruselData(callback: @escaping ([CaruselItem]?) -> Void)

    func numberOfItems() -> Int

    func item(at index: Int) -> CaruselItem?

}

public protocol CaruselItem {

    var title: String? {get}
    var image: String? {get}
    var feed: String? {get}
}
