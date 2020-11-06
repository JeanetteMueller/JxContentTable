//
//  PhotoOperations.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 06.10.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import Foundation
import UIKit

// This enum contains all the possible states a photo record can be in
public enum PhotoRecordState {
    case new, downloaded, filtered, failed
}

public class PhotoRecord {
    public let url: URL
    public var state = PhotoRecordState.new
    public var image = UIImage(named: "emerald_fallback")

    public init(url: URL) {
        self.url = url
    }

    public init?(string: String) {
        if !string.isEmpty, let newUrl = URL(string: string) {
            self.url = newUrl
        } else {
            return nil
        }
    }

    public func getFilePath() -> String {

        return UIImage.getFilePath(withUrl: self.url)
    }
}

public class PendingImageOperations {

    public static let shared: PendingImageOperations = {

        let instance = PendingImageOperations()

        // setup code

        return instance
    }()
    
    public init() {
        
    }

    public lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 3
        queue.qualityOfService = .background
        return queue
    }()

    public lazy var filtrationsInProgress = [String: Operation]()
    public lazy var filtrationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image Filtration queue"
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
}

public class ImageDownloader: Operation {
    //1
    let photoRecord: PhotoRecord

    //2
    public init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }

    //3
    public override func main() {

        if self.isCancelled {
            return
        }
        if self.photoRecord.state != .new {
            return
        }

        if self.isCancelled {
            return
        }

        let filename = self.photoRecord.getFilePath()

        if FileManager.default.fileExists(atPath: filename) {
            self.photoRecord.state = .downloaded
            self.photoRecord.image = UIImage(contentsOfFile: filename)
            return
        }

        if let imageData = NSData(contentsOf: self.photoRecord.url) {

            if self.isCancelled {
                return
            }

            if imageData.length > 0 {
                self.photoRecord.image = UIImage(data: imageData as Data)

                imageData.write(toFile: filename as String, atomically: true)
                self.photoRecord.state = .downloaded

                log("load image done")
                return
            }
        } else {
            log("load image failed")
        }

        self.photoRecord.state = .failed

    }
}

public class ImageFiltration: Operation {
    let photoRecord: PhotoRecord

    init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }

    public override func main () {

        let documentsDirectory = FileHelper.shared.getBaseDirectory()

        let imageDir = documentsDirectory.appending("/images")
        let filename = String(format: "%@/%@_filtered", imageDir, self.photoRecord.url.md5())

        if self.isCancelled {
            return
        }

        if self.photoRecord.state != .downloaded {
            return
        }

        if FileManager.default.fileExists(atPath: filename) {
            self.photoRecord.state = .filtered
            self.photoRecord.image = UIImage(contentsOfFile: filename)
            return
        }

        if self.isCancelled {
            return
        }

        if let i = self.photoRecord.image {
            if let filteredImage = self.applySepiaFilter(image: i) {
                if self.photoRecord.state != .downloaded {
                    return
                }

                if let imageData: NSData = filteredImage.pngData() as NSData? {

                    imageData.write(toFile: filename as String, atomically: true)

                    self.photoRecord.image = filteredImage
                    self.photoRecord.state = .filtered
                } else {
                    self.photoRecord.state = .failed
                }
            }
        }
    }

    public func applySepiaFilter(image: UIImage) -> UIImage? {
        if let pngData = image.pngData() {
            let inputImage = CIImage(data: pngData)

            if self.isCancelled {
                return nil
            }
            let context = CIContext(options: nil)
            let filter = CIFilter(name: "CISepiaTone")
            filter?.setValue(inputImage, forKey: kCIInputImageKey)
            filter?.setValue(0.8, forKey: "inputIntensity")
            if let outputImage = filter?.outputImage {

                if self.isCancelled {
                    return nil
                }

                if let outImage = context.createCGImage(outputImage, from: outputImage.extent) {
                    let returnImage = UIImage(cgImage: outImage)
                    return returnImage
                }
            }
        }
        return nil
    }
}
