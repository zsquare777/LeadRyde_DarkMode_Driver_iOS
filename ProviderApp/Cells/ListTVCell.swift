//
//  ListTVCell.swift

//


import UIKit

class ListTVCell: UITableViewCell {

    @IBOutlet weak var listLabelTxt: MyLabel!
    @IBOutlet weak var listImg: UIImageView!

    @IBOutlet weak var newListView: UIView!
    @IBOutlet weak var nListViewLeadingLbl: MyLabel!
    @IBOutlet weak var nListViewTitleLbl: MyLabel!
    @IBOutlet weak var nListViewCheckImg: UIImageView!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
