//
//  ProfileTVCell.swift
//  PassengerApp
//

import UIKit

class ProfileTVCell: UITableViewCell {

    @IBOutlet weak var nextArrowContainerView: UIView!
    @IBOutlet weak var nextArrowImgView: UIImageView!
    @IBOutlet weak var titleLbl: MyLabel!
    @IBOutlet weak var iconImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Apply initial theme
        applyTheme()
        
        // Register for theme change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reapply theme when cell is reused from the pool
        applyTheme()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func themeDidChange() {
        applyTheme()
    }
    
    // Public method so ViewProfileUV can force theme application
    public func applyTheme() {
        let themeManager = ThemeManager.shared
        
        // FORCE update colors with explicit values - override any XIB settings
        if themeManager.isDarkModeActive {
            // Dark mode - explicit colors
            self.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 46/255, alpha: 1.0) // #2C2C2E
            self.contentView.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 46/255, alpha: 1.0)
            self.titleLbl?.textColor = UIColor.white
        } else {
            // Light mode - explicit colors
            self.backgroundColor = UIColor.white
            self.contentView.backgroundColor = UIColor.white
            self.titleLbl?.textColor = UIColor.black
        }
        
        self.nextArrowContainerView?.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
