//
//  AWSLoginViewController.swift
//  TeamStatus
//
//  Created by craig.brossman@ricoh-usa.com on 5/9/18.
//  Copyright © 2018 craig.brossman@ricoh-usa.com. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI

class AWSLoginViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let authConfig = AWSAuthUIConfiguration()
        authConfig.enableUserPoolsUI = true
        authConfig.logoImage = #imageLiteral(resourceName: "RICOH")
        authConfig.backgroundColor = UIColor.white
        
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            AWSAuthUIViewController
                .presentViewController(with: self.navigationController!,
                                       configuration: authConfig,
                                       completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                                        if error != nil {
                                            print("Error occurred: \(String(describing: error))")
                                        } else {
                                            print("Signed in!")
                                        }
                })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
