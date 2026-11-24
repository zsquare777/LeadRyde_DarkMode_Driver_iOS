//
//  OrderHistoryTVC.swift
//  DriverApp
//
//

import UIKit

class OrderHistoryTVC: UITableViewCell {
    @IBOutlet weak var orderTypeLbl: MyLabel!
    @IBOutlet weak var nameLbl: MyLabel!
    @IBOutlet weak var orderSatusLBl: MyLabel!
    @IBOutlet weak var totlLbl: MyLabel!
    
    @IBOutlet weak var orderNoLbl: MyLabel!
    @IBOutlet weak var name2Lbl: MyLabel!
    @IBOutlet weak var addressLbl: MyLabel!
    @IBOutlet weak var dateLbl: MyLabel!
    @IBOutlet weak var timeLbl: MyLabel!
    @IBOutlet weak var fareEarnLbl: MyLabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var pendingTxtLbl: MyLabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
