//
//  DishwasherCollectionViewCell.swift
//  Dishwasher
//
//  Created by mac on 5/14/18.
//  Copyright © 2018 mobileappscompany. All rights reserved.
//

import UIKit

class DishwasherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    static let identifier = "DishwasherCell"
    var dataTask : URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
    }
    
    func configure(with dishwasher: Dishwasher){
        
        titleLabel.text = dishwasher.title
        priceLabel.text = dishwasher.price["now"]
        
    
        if let url = dishwasher.imageURL {
            downloadImage(url: url, imageViewCell: imageView)
        }
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        dataTask?.cancel()
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let e = error {
                print(e.localizedDescription)
            }
            completion(data, response, error)
            }
        dataTask?.resume()
    }
    
    func downloadImage(url: URL, imageViewCell: UIImageView) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                imageViewCell.image = UIImage(data: data)
            }
        }
    }
}

