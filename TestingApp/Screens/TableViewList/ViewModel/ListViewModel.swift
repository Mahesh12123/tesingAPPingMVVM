//
//  ListViewModel.swift
//  TestingApp
//
//  Created by mahesh mahara on 2/15/24.
//

import Foundation

final class ListViewModel {
    
    var listArry : [Product] = []
    var eventHandler : ((_ event: Event) -> Void)?
    
    func fetchLists(pageNumber:Int?) {
        self.eventHandler?(.loading)
        APImanager.shared.FetchProduct(completion: { responces in
            self.eventHandler?(.loading)
            switch responces {
            case .success( let products) :
                self.listArry = products
                self.eventHandler?(.dataLoaded)
                print(products)
            case .failure(let error) :
                print(error)
                self.eventHandler?(.error(error))
                
            }
        }, pageNumber: pageNumber ?? 1)
    }
    
    
}

extension ListViewModel {
    
    enum Event {
        case loading
        case stoploading
        case dataLoaded
        case error(_ error :Error?)
        
    }
    
}
