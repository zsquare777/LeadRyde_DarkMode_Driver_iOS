//
//  ViewDeliveryDetailCell.swift
//  DriverApp
//

import UIKit

class ViewDeliveryDetailCell: UITableViewCell {

   
    @IBOutlet weak var fareDetailImgView: UIImageView!
    @IBOutlet weak var deliveryCountLbl: UILabel!
    @IBOutlet weak var checkImgView: UIImageView!
    @IBOutlet weak var tripLineView: UIView!
    @IBOutlet weak var locImgView: UIImageView!
    @IBOutlet weak var totalFareVLbl: UILabel!
    @IBOutlet weak var payByVLbl: UILabel!
    @IBOutlet weak var payTypeVLbl: UILabel!
    @IBOutlet weak var totalFareHLbl: UILabel!
    @IBOutlet weak var payByHLbl: UILabel!
    @IBOutlet weak var payTypeHLbl: UILabel!
    @IBOutlet weak var viewSignatureLabel: MyLabel!
    
    @IBOutlet weak var finishedStatusLbl: MyLabel!
    @IBOutlet weak var ic_messageImgView: UIImageView!
    @IBOutlet weak var respForPayReci: UILabel!
//    @IBOutlet weak var additionalNoteValLbl: UILabel!
//    @IBOutlet weak var additionalNoteHLbl: UILabel!
//    @IBOutlet weak var deliveryInsValLbl: UILabel!
//    @IBOutlet weak var deliveryInsHLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var callLbl: UILabel!
    @IBOutlet weak var callView: UIView!
   
    @IBOutlet weak var recMsgImgView: UIImageView!
    @IBOutlet weak var recCallImgView: UIImageView!
    
    @IBOutlet weak var vAddressLbl: UILabel!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    
    @IBOutlet weak var senderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var receiverDetailView: UIView!
    @IBOutlet weak var senderHeaderView: UIView!
    @IBOutlet weak var receiverHeaderView: UIView!
    
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var viewUpDownImgView: UIImageView!
    @IBOutlet weak var receiverMobLbl: UILabel!
    @IBOutlet weak var receiverNameLbl: UILabel!
    @IBOutlet weak var receiverHeaderLbl: UILabel!
    @IBOutlet weak var callMessageStackView: UIStackView!
    
    @IBOutlet weak var mainCallMessView: UIView!
    
    
    @IBOutlet weak var receiverHeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainCallMessgeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var trailingSpace: NSLayoutConstraint!
    @IBOutlet weak var leadingSpace: NSLayoutConstraint!
    @IBOutlet weak var deliveryCodeTxtFiled: MyTextField!
    @IBOutlet weak var deliveryCodehLbl: UILabel!
    @IBOutlet weak var subSigLbl: UILabel!
    @IBOutlet weak var clearSigLbl: UILabel!
    @IBOutlet weak var sigSubBtnView: UIView!
    @IBOutlet weak var sigClearBtnView: UIView!
    @IBOutlet weak var ypSignatureImgView: YPDrawSignatureView!
    @IBOutlet weak var sigatureBGView: UIView!
    @IBOutlet weak var signatureViewHLbl: UILabel!
    @IBOutlet weak var signatureView: UIView!
    
    @IBOutlet weak var recDetailviewHeight: NSLayoutConstraint!
    @IBOutlet weak var eachRecFareLbl: UILabel!
    @IBOutlet weak var eachRecFareVLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
