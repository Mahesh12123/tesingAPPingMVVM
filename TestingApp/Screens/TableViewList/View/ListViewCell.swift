//
//  ListViewCell.swift
//  TestingApp
//
//  Created by mahesh mahara on 2/15/24.
//

import UIKit

class ListViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var deslbl: UILabel!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    
    
    var listdata:Product?
    {
        didSet {
            productDetailConfiguration()
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func productDetailConfiguration(){
        guard let listdata else { return }
        titlelbl.text = listdata.title
        deslbl.text = listdata.description
        pricelbl.text = "Price :\(listdata.price )"
        categoryLbl.text = listdata.category
        ratingLbl.text = "Rate :\(listdata.rating.rate )"
    }
    
    
    
}
