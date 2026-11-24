//
//  MSPDetailsTVCell.swift
//  DriverApp
//

import UIKit

class MSPDetailsTVCell: UITableViewCell {

    @IBOutlet weak var cellHLbl: MyLabel!
    @IBOutlet weak var countLbl: MyLabel!
    @IBOutlet weak var countCheckImgView: UIImageView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addViewhLbl: MyLabel!
    @IBOutlet weak var locImgView: UIImageView!
    @IBOutlet weak var addressLbl: MyLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
