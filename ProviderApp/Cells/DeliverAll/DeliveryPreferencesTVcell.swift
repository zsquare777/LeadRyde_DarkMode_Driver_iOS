//
//  DeliveryPreferencesTVcell.swift
//  PassengerApp
//
//  Created by Admin on 20/03/20.
//  Copyright © 2020 @. All rights reserved.
//

import UIKit
import SwiftExtensionData

class DeliveryPreferencesTVcell: UITableViewCell {
    
    @IBOutlet weak var deliveryPreferenceNameLbl: MyLabel!
    @IBOutlet weak var deliveryPreferenceDescriptionLbl: MyLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
