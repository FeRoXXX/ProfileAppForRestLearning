//
//  NewDataTableViewCell.swift
//  ProfileApp
//
//  Created by Александр Федоткин on 28.11.2023.
//

import UIKit

class NewDataTableViewCell: UITableViewCell {
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2
        logoImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
