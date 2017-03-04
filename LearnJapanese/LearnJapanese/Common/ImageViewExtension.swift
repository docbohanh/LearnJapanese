//
//  ImageViewExtension.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/28/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import Foundation
import UIKit
extension UIImageView {
    func loadImage(url:String) -> Void {
        let catPictureURL = URL(string: url)!
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        DispatchQueue.main.async {
                            self.image = UIImage(data: imageData)!
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
    }
}
    extension UIImage {
        func loadImage(url:String) -> Void {
            let catPictureURL = URL(string: url)!
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
                // The download has finished.
                if let e = error {
                    print("Error downloading cat picture: \(e)")
                } else {
                    // No errors found.
                    // It would be weird if we didn't have a response, so check for that too.
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded cat picture with response code \(res.statusCode)")
                        if data != nil {
                            // Finally convert that Data into an image and do what you wish with it.
                            DispatchQueue.main.async {
                            }
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            downloadPicTask.resume()
        }
    }

