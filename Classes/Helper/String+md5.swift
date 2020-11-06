//
//  String+md5.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 07.10.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import Foundation
import CommonCrypto
/*
 You have to add
 #import <CommonCrypto/CommonCrypto.h>
 to your Objective-C Bridging Header File
 */


//ab iOS 13
import CryptoKit // statt CommonCrypto


extension String {

    //ab iOS 13
    func md5() -> String {
        if #available(watchOSApplicationExtension 6.0, *), #available(iOS 13.0, *) {
            let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())

            return digest.map {
                String(format: "%02hhx", $0)
            }.joined()
        } else {
            let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5_Init(context)
            CC_MD5_Update(context, self, CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8)))
            CC_MD5_Final(&digest, context)
            context.deallocate()
            var hexString = ""
            for byte in digest {
                hexString += String(format: "%02x", byte)
            }

            return hexString
        }


    }

//    func md5() -> String {
//
//        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
//        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
//        CC_MD5_Init(context)
//        CC_MD5_Update(context, self, CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8)))
//        CC_MD5_Final(&digest, context)
//        context.deallocate()
//        var hexString = ""
//        for byte in digest {
//            hexString += String(format: "%02x", byte)
//        }
//
//        return hexString
//    }

}
//@available(watchOSApplicationExtension 5.0, *)
//extension String {
//
////    //ab iOS 13
////    func md5() -> String {
////        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
////
////        return digest.map {
////            String(format: "%02hhx", $0)
////        }.joined()
////    }
//
//        func md5() -> String {
//
//            let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
//            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
//            CC_MD5_Init(context)
//            CC_MD5_Update(context, self, CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8)))
//            CC_MD5_Final(&digest, context)
//            context.deallocate()
//            var hexString = ""
//            for byte in digest {
//                hexString += String(format: "%02x", byte)
//            }
//
//            return hexString
//        }
//
//}
extension NSURL {
    // new functionality to add to SomeType goes here

    func md5() -> String {

        let urlString = self.absoluteString! as String

        return urlString.md5()
    }

}

extension URL {
    // new functionality to add to SomeType goes here

    func md5() -> String {

        let urlString = self.absoluteString as String

        return urlString.md5()
    }

}
