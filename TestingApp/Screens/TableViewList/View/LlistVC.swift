//
//  LlistVC.swift
//  TestingApp
//
//  Created by mahesh mahara on 2/15/24.
//

import UIKit

class LlistVC: UIViewController ,UISearchBarDelegate , UISearchControllerDelegate {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var searchAndFilterView: UIView!
    
    
    private var viewmodel = ListViewModel()
    var produtList : [Product] = []
    var page = 0
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
         configuration()
        listTableView.dataSource = self
        listTableView.delegate = self
        searchBarSetup()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sortingBtn(_ sender: UIButton) {
        presentAlertWithTitle(title: "Sorting Price", message: "Price low to hight", options: "cancel", "ok") { (option) in
            switch(option) {
                case 0:
                    print("cancel")
                    break
                case 1:
                self.produtList.sort(by: {$0.price < $1.price })
                self.listTableView.reloadData()
                default:
                    break
            }
        }
    }
    
    
    private func searchBarSetup(){
        searchController.searchBar.sizeToFit()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchAndFilterView.addSubview(searchController.searchBar)
        
    }
}

extension LlistVC {
    
    func configuration(){
        listTableView.register(UINib(nibName: "ListViewCell", bundle: nil ), forCellReuseIdentifier: "listCellID")
        initViewmodel()
        observeEvent()
        
    }
    
    func initViewmodel(){
        viewmodel.fetchLists(pageNumber: 10)
    }
    
    func observeEvent(){
        
        
        viewmodel.eventHandler = { [weak self] event in
            guard self != nil else {return}
            switch event {
            case .loading:
                print("List loding ...")
            case .stoploading:
                print("Stop loding ...")
            case .dataLoaded:
                print("Data loded ...")
                DispatchQueue.main.async {
                    self?.produtList.append(contentsOf: (self?.viewmodel.listArry)!)
                    self?.listTableView.reloadData()
                }
                print(self?.viewmodel.listArry as Any)
            case .error(let error):
                print(error as Any)
            }
            
            
        }
    }
    
    
}

extension LlistVC :UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        produtList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCellID") as? ListViewCell else
        {
            return UITableViewCell()
        }
        let list = produtList[indexPath.row]
        cell.listdata = list
        return cell
        
    }
    
  
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
               let lastIndex = self.produtList.count - 1
                if indexPath.row == lastIndex {
                    if self.produtList[lastIndex].id == self.produtList.count {
                           print("lastIndex = \(lastIndex)")
                           viewmodel.fetchLists(pageNumber: lastIndex)
                    }else{
                        presentAlertWithTitle(title: "NO More Product", message: "", options:  "ok") { (option) in
                            switch(option) {
                                case 0:
                                   print("ok")
                                default:
                                    break
                            }
                        }
                    }
                   
                }
    }

    
}

extension LlistVC : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else {return}
        if searchText == "" {
            configuration()
        }else{
            produtList = produtList.filter{
                $0.title.contains(searchText)
            }
        }
        
        listTableView.reloadData()
        
    }
    
    
    
}
