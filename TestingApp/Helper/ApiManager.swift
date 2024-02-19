//
//  ApiManager.swift
//  TestingApp
//
//  Created by mahesh mahara on 2/15/24.
//

import Foundation
import UIKit

enum DataError :Error {
    
    case invalidResponce
    case invalidURL
    case invalidDecoding
    case massage(_ error:Error?)
    
}

typealias Handler = (Result<[Product] , DataError>) -> Void 

final class APImanager{
    
  static  let shared = APImanager()
    func FetchProduct(completion: @escaping Handler , pageNumber:Int?) {
        
        guard let url = URL(string: Constant.API.productURL + "\(pageNumber ?? 1)") else {
            return
        }
        print("url = \(url)")
        URLSession.shared.dataTask(with: url) { data, response, error in
         
            guard let data , error == nil else{
                completion(.failure(.invalidDecoding))
                return
            }
            
            guard let responce = response as? HTTPURLResponse,
                  200 ... 299 ~= responce.statusCode else {
                completion(.failure(.invalidResponce))
                return
            }
            
            do {
                let products = try JSONDecoder().decode([Product].self , from: data)
             
                 completion(.success(products))
            }catch {
                print(String(data: data, encoding: .utf8) as Any)
                completion(.failure(.massage(error)))
            }
            
            
            
        }.resume()
        
    }
    
    
}
