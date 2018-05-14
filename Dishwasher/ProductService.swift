//
//  ProductService.swift
//  Dishwasher
//
//  Created by mac on 5/14/18.
//  Copyright © 2018 mobileappscompany. All rights reserved.
//

import Foundation

typealias ProductHandler = ([Dishwasher])->Void

struct ProductAPI {
    
    private static let key = "Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb"
    private static let base = "https://api.johnlewis.com/v1/"
    
    static var products: String {
        return "\(base)products/search?q=dishwasher&key=\(key)"
    }
}

class ProductService {
    
    class func getProducts(completion: @escaping ProductHandler){
        
        guard let url = URL(string: ProductAPI.products) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url){ data, response, error in
        
            if let e = error {
                print(e.localizedDescription)
                completion([])
                return
            }
            
            guard let jsonData = data else {
                print("No data returned")
                completion([])
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ApiResponse.self, from: jsonData)
                completion(response.products)
            }catch let e as NSError{
                print(e.localizedDescription)
                completion([])
            }
        
        }.resume()
        
    }
}
