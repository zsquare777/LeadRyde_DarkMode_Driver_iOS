//
//  SubscriptionDetailTVCell.swift
//  DriverApp
//

import UIKit
import SwiftExtensionData

class SubscriptionDetailTVCell: UITableViewCell {

    @IBOutlet weak var subscriptionDetailsView: UIView!
    @IBOutlet weak var sDetailBottomView: UIView!
    @IBOutlet weak var bottomMonthLbl: MyLabel!
    @IBOutlet weak var bottomStatusLbl: MyLabel!
    @IBOutlet weak var h1Lbl: MyLabel!
    @IBOutlet weak var h2Lbl: MyLabel!
    @IBOutlet weak var h3Lbl: MyLabel!
    @IBOutlet weak var h4Lbl: MyLabel!
    @IBOutlet weak var sH1Lbl: MyLabel!
    @IBOutlet weak var sH2Lbl: MyLabel!
    @IBOutlet weak var sH3Lbl: MyLabel!
    @IBOutlet weak var sH4Lbl: MyLabel!
    @IBOutlet weak var daysLeftView: UIView!
    @IBOutlet weak var daysLeftLbl: MyLabel!
    @IBOutlet weak var sDetailsStackViewTrailSpace: NSLayoutConstraint!
    
    @IBOutlet weak var subscriptionPlanView: UIView!
    @IBOutlet weak var sPlanHLbl: MyLabel!
    @IBOutlet weak var sPlanStatusLbl: MyLabel!
    @IBOutlet weak var planRenewLbl: MyLabel!
    @IBOutlet weak var sPlanSubscribeLbl: MyLabel!
    @IBOutlet weak var sPlanDescriptionLbl: MyLabel!
    @IBOutlet weak var sPlanDetailsLbl: MyLabel!
    @IBOutlet weak var sPlaNameLbl: MyLabel!
    @IBOutlet weak var sPlanStatusSwitch: CMSwitchView!
    @IBOutlet weak var sPlanStatusVLbl: MyLabel!
    @IBOutlet weak var sDateHLbl1: MyLabel!
    @IBOutlet weak var sDurHLbl: MyLabel!
    @IBOutlet weak var sDurVLbl: MyLabel!
    @IBOutlet weak var sDateHLbl2: MyLabel!
    @IBOutlet weak var sDateVLbl1: MyLabel!
    @IBOutlet weak var sDateVLbl2: MyLabel!
    @IBOutlet weak var sDateStackView: UIStackView!
    @IBOutlet weak var sDateStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var statusTopSpace: NSLayoutConstraint!
    @IBOutlet weak var statusLblHeight: NSLayoutConstraint!
    @IBOutlet weak var dummyLbl: MyLabel!
    @IBOutlet weak var dateStackViewTopSpace: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
