//
//  ZonesTableViewCell.swift
//  ProviderApp
//
//  Created by pro on 03/02/2025.
//

import UIKit

class ZonesTableViewCell: UITableViewCell {

    @IBOutlet weak var cellStackView: UIStackView!
    @IBOutlet weak var uc30Lbl: UILabel!
    @IBOutlet weak var typeCarLbl: UILabel!
    @IBOutlet weak var paxLbl: UILabel!
    @IBOutlet weak var ucLbl: UILabel!
    @IBOutlet weak var nowLbl: UILabel!
    @IBOutlet weak var carsLbl: UILabel!
    @IBOutlet weak var zoneNameLbl: UILabel!
    var timer: Timer?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        zoneNameLbl.numberOfLines = 0
        zoneNameLbl.lineBreakMode = .byWordWrapping
        typeCarLbl.numberOfLines = 0
        typeCarLbl.lineBreakMode = .byWordWrapping
        
        applyTheme()
        
        // Register for theme change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        timer = nil
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
        guard let zoneNameLbl = self.zoneNameLbl,
              let typeCarLbl = self.typeCarLbl else {
            return
        }
        
        let themeManager = ThemeManager.shared
        
        // Update colors based on theme
        self.backgroundColor = themeManager.backgroundColor()
        self.contentView.backgroundColor = themeManager.backgroundColor()
        
        // Update labels
        zoneNameLbl.textColor = themeManager.textColor()
        typeCarLbl.textColor = themeManager.textColor()
        paxLbl?.textColor = themeManager.secondaryTextColor()
        ucLbl?.textColor = themeManager.textColor()
        uc30Lbl?.textColor = themeManager.textColor()
        nowLbl?.textColor = themeManager.secondaryTextColor()
        carsLbl?.textColor = themeManager.secondaryTextColor()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
