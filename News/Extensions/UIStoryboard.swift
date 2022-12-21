//
//  UIStoryboard.swift
//  News
//
//  Created by Dinesh Kumar on 21/12/22.
//

import Foundation
import UIKit

extension UIStoryboard{
    
    class var main : UIStoryboard {
        return UIStoryboard (name: "Main", bundle: Bundle.main)
    }
    
    static func viewController(storyboard : UIStoryboard, identifier : String) -> UIViewController{
        return  storyboard.instantiateViewController(withIdentifier:identifier)
    }
    
    func viewController(identifier : String) -> UIViewController{
        return  self.instantiateViewController(withIdentifier:identifier)
    }
}
