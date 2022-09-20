//
//  ZoomImageView+Downloader.swift
//  JxContentTable-JxContentTable
//
//  Created by Jeanette Müller on 20.09.22.
//

import UIKit
import ZoomImageView
import JxSwiftHelper
import JxSwiftHelperForUiKit

extension ZoomImageView {
    public func loadImageFromHttpPath(path: String, fallbackImage: UIImage, contentMode: UIView.ContentMode, withCustomSize customSize: CGSize? = nil) {
        
        var size = self.frame.size
        
        if let c = customSize {
            size = c
        }
        
        let quadratSize = CGSize(width: max(size.width, size.height), height: max(size.width, size.height))
        
        if let localImage = UIImage(named: path) {
            self.image = localImage
        } else if let imageFromFile = UIImage.getImage(withImageString: path, andSize: quadratSize, withMode: contentMode) {
            self.image = imageFromFile
        } else if let photoDetails = PhotoRecord(string: path) {
            photoDetails.image = fallbackImage
            photoDetails.contentMode = contentMode
            startDownloadForRecord(photoDetails: photoDetails)
        } else {
            self.image = fallbackImage
        }
    }
    func startDownloadForRecord(photoDetails: PhotoRecord) {
        
        self.image = photoDetails.image
        
        let imageLoader = ImageDownloader(photoRecord: photoDetails)
        
        imageLoader.completionBlock = {
            DispatchQueue.main.async {
                
                let size = self.frame.size
                let quadratSize = CGSize(width: max(size.width, size.height), height: max(size.width, size.height))
                
                if let imageFromFile = UIImage.getImage(withImageString: photoDetails.path,
                                                        andSize: quadratSize,
                                                        withMode: photoDetails.contentMode) {
                    self.image = imageFromFile
                }
            }
        }
        
        PendingImageOperations.shared.downloadQueue.addOperation(imageLoader)
    }
}
