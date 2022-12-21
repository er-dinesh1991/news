//
//  NewsDetailController.swift
//  News
//
//  Created by Dinesh Kumar on 20/12/22.
//

import UIKit
import SafariServices
import SDWebImage


class NewsDetailController: UIViewController {

    static let identifier = String(describing: NewsDetailController.self)
    
    var theArtical : Article?
    
    @IBOutlet weak var articalImage : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblAuthor : UILabel!
    @IBOutlet weak var lblSourceName : UILabel!
    @IBOutlet weak var lblContent : UILabel!
    @IBOutlet weak var imageHeightConstraint : NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "News Detail"
        
        updateData()
    }

    static func newsDetailController(artical : Article) -> NewsDetailController {
        let vc = UIStoryboard.main.viewController(identifier: NewsDetailController.identifier) as! NewsDetailController
        vc.theArtical = artical
        return vc
    }
    
    //Display data
    func updateData() -> Void{
        guard let artical = theArtical else { return }
        lblTitle.text = artical.title ?? ""
        lblAuthor.text = "Author : \(artical.author ?? "")"
        lblSourceName.text = "Source : \(artical.source?.name ?? "")"
        lblContent.text = artical.content ?? ""
        if let imagePath = artical.urlToImage, let url = URL(string: imagePath){
            articalImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            articalImage.sd_setImage(with: url)
            imageHeightConstraint.constant = self.view.frame.height * 0.3
        }
        else{
            imageHeightConstraint.constant = 0
        }
    }
}

//MARK: IBActions
extension NewsDetailController{
    
    @IBAction func readMoreButtonAction() -> Void {
        guard let artical = theArtical, let articalWebUrl = artical.url, let url = URL(string: articalWebUrl) else { return }
        let vc = SFSafariViewController(url: url)
        self.present(vc, animated: true)
    }
}
