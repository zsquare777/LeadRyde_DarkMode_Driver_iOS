//
//  YourZoneTableViewCell.swift
//  ProviderApp
//
//  Created by Suleman Hussan on 23/06/2025.
//

import UIKit

class YourZoneTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var zoneNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 8
        cardView.layer.borderWidth = 1
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cardView.layer.shadowRadius = 2
        cardView.layer.masksToBounds = false
        
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
        guard let cardView = self.cardView,
              let zoneNameLbl = self.zoneNameLbl else {
            return
        }
        
        let themeManager = ThemeManager.shared
        
        // Update colors based on theme
        cardView.backgroundColor = themeManager.cardBackgroundColor()
        cardView.layer.borderColor = themeManager.borderColor().cgColor
        cardView.layer.shadowColor = themeManager.isDarkModeActive ? UIColor.white.cgColor : UIColor.black.cgColor
        zoneNameLbl.textColor = themeManager.textColor()
        
        // Update background color
        self.backgroundColor = themeManager.backgroundColor()
        self.contentView.backgroundColor = themeManager.backgroundColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
