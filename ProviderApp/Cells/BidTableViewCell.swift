//
//  BidTableViewCell.swift
//  ProviderApp
//
//  Created by pro on 03/02/2025.
//

import UIKit

class BidTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var zoneLbl: UILabel!
    
    @IBOutlet weak var vehicleTypeBid: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        applyTheme()
        
        // Register for theme change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reapply theme when cell is reused
        applyTheme()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func themeDidChange() {
        // Use main thread to avoid race conditions
        DispatchQueue.main.async { [weak self] in
            self?.applyTheme()
        }
    }
    
    func applyTheme() {
        // Guard against nil outlets (cell might be deallocated)
        guard let timeLbl = self.timeLbl,
              let zoneLbl = self.zoneLbl,
              let vehicleTypeBid = self.vehicleTypeBid else {
            return
        }
        
        let themeManager = ThemeManager.shared
        
        // Update colors based on theme
        self.backgroundColor = themeManager.backgroundColor()
        self.contentView.backgroundColor = themeManager.backgroundColor()
        
        // Update labels
        timeLbl.textColor = themeManager.textColor()
        zoneLbl.textColor = themeManager.textColor()
        vehicleTypeBid.textColor = themeManager.secondaryTextColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
