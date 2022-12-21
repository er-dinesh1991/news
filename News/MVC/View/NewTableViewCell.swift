//
//  NewTableViewCell.swift
//  News
//
//  Created by Dinesh Kumar on 21/12/22.
//

import Foundation
import UIKit
import SDWebImage

class NewTableViewCell: UITableViewCell{
    
    static let identifier = String(describing: NewTableViewCell.self)
    
    @IBOutlet weak var lblSourceName : UILabel!
    @IBOutlet weak var lblAuthor : UILabel!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imgNews : UIImageView!
    
    @IBOutlet weak var imageWidthConstraint : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        self.selectedBackgroundView = backgroundView
    }
    
    func updateData(artical : Article) -> Void{
        self.lblTitle.text = artical.title ?? ""
        self.lblAuthor.text = artical.author ?? ""
        self.lblSourceName.text = artical.source?.name ?? ""
        if let imageUrl = artical.urlToImage, imageUrl != "", let url = URL(string: imageUrl){
            self.imgNews.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgNews.sd_setImage(with: url)
            self.imageWidthConstraint.constant = 120
        }
        else{
            self.imageWidthConstraint.constant = 0
        }
        
    }
}
