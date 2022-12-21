//
//  UIViewController.swift
//  Customer
//
//  Created by Dinesh Saini on 11/04/21.
//

import Foundation
import UIKit

extension UIViewController{
    
    func alert(alertTitle : String, alertMessage : String) -> Void {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(actionOk)
        if let controller = UIApplication.topViewController(){
            DispatchQueue.main.async {
                controller.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
