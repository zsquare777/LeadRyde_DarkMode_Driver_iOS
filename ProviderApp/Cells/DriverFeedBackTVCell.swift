//
//  DriverFeedBackTVCell.swift
//  DriverApp
//

import UIKit

class DriverFeedBackTVCell: UITableViewCell {

    @IBOutlet weak var userPicImgView: UIImageView!
    @IBOutlet weak var nameLbl: MyLabel!
    @IBOutlet weak var commentLbl: MyLabel!
    @IBOutlet weak var ratingBar: RatingView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLbl: MyLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
