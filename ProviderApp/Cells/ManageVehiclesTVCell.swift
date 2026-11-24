//
//  ManageVehiclesTVCell.swift
//  DriverApp
//

import UIKit

class ManageVehiclesTVCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var vehicleNameLbl: MyLabel!
    @IBOutlet weak var vOtherInfoLbl: MyLabel!
    @IBOutlet weak var statusLbl: MyLabel!
    @IBOutlet weak var deleteVehicleImgView: UIImageView!
    @IBOutlet weak var editVehicleImgView: UIImageView!
    @IBOutlet weak var uploadVehicleDocumentsImgView: UIImageView!
    @IBOutlet weak var uploadDocView: UIView!
    @IBOutlet weak var editVehicleView: UIView!
    @IBOutlet weak var removeVehicleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
