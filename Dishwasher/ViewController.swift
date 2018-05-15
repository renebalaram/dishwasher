//
//  ViewController.swift
//  Dishwasher
//
//  Created by mac on 5/14/18.
//  Copyright © 2018 mobileappscompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dishwasherCollectionView: UICollectionView!
    
    var products: [Dishwasher] = []
    var cellPerRow: CGFloat{
        let orientation = UIApplication.shared.statusBarOrientation
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            return 3
        default:
            return 2
        }
    }
    var cellPerColumn: CGFloat{
        let orientation = UIApplication.shared.statusBarOrientation
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            return 2
        default:
            return 3
        }
    }
    
    var scrolOrientation: UICollectionViewScrollDirection{
        let orientation = UIApplication.shared.statusBarOrientation
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            return .vertical
        default:
            return .horizontal
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProductService.getProducts(){ [unowned self] dishwashers in
            self.products = dishwashers
            DispatchQueue.main.async {
                self.dishwasherCollectionView.reloadData()
            }
        }

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = dishwasherCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layout = dishwasherCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            layout.scrollDirection = scrolOrientation
        }
        return CGSize(width: (view.frame.size.width/cellPerRow), height: ((view.frame.size.height-20)/cellPerColumn))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DishwasherCollectionViewCell.identifier,
            for: indexPath)
        
        guard let dishwasherCell = cell as? DishwasherCollectionViewCell else {
            return cell
        }
        
        let dishwasher = products[indexPath.row]
        dishwasherCell.configure(with: dishwasher)
        
        return dishwasherCell
    }
}
