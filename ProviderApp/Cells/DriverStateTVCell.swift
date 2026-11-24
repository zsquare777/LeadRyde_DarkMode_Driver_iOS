//
//  DriverStateTVCell.swift
//  DriverApp
//
//  Created by ADMIN on 19/06/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class DriverStateTVCell: UITableViewCell {

    @IBOutlet weak var stateFinishedImgView: UIImageView!
    @IBOutlet weak var stateNumLbl: MyLabel!
    @IBOutlet weak var stateTitleLbl: MyLabel!
    @IBOutlet weak var stateNoteLbl: MyLabel!
    @IBOutlet weak var actionBtn: MyButton!
    @IBOutlet weak var stateSeperatorView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topSeperatorView: UIView!
    @IBOutlet weak var actionLbl: MyLabel!
    @IBOutlet weak var actionLblWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
