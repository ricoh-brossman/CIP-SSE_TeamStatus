//
//  FirstViewController.swift
//  TeamStatus
//
//  Created by craig.brossman@ricoh-usa.com on 2/5/18.
//  Copyright © 2018 craig.brossman@ricoh-usa.com. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI

class LogonViewController: UIViewController {
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    var loggedIn = false
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USWest2, identityPoolId: "us-west-2_EPYVySdDd")
        //        let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialProvider)
        //        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        //        if !AWSSignInManager.sharedInstance().isLoggedIn {
        //            let config = AWSAuthUIConfiguration()
        //
        //
        //            // This transitions to the
        //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //            let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        //
        ////            // Set the a Revenue JSON in the Revenue VC
        ////            let revNavCtl = tabBarController.viewControllers?[0] as! UINavigationController
        //
        //            AWSAuthUIViewController.presentViewController(with: (tabBarController.viewControllers?[0].navigationController!)!, configuration: config, completionHandler: { (provider: AWSSignInProvider, error: Error?) in
        //                if error != nil {
        //                    print("Error occured: \(String(describing: error))")
        //                }
        //                else {
        //                    LogonViewController.GetControlBookData()
        //                }
        //            })
        //        }
    }
    
    struct GlobalVariable {
        static var urlString = "file:///Users/cbrossman/Desktop/CIP-SSEControlBookData/FY2017"
        static var userID = "craig.brossman@ricoh-usa.com"
        //        static var circleOfExcellenceArray = [CircleOfExcellence]()
        //        static var revenue: Revenue? = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.userIDTextField.text = LogonViewController.GlobalVariable.userID
        self.urlTextField.text = LogonViewController.GlobalVariable.urlString
    }
    
    // Built in method for UIViewController
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var ctlBookMap = [String : FinancialJSON]()
    
    
    private func processControlBook(_ urlStr: String!, _ ctlBook: FinancialJSON?, _ error: Error?) {
        if error != nil && ctlBook != nil {
            ctlBookMap[urlStr] = ctlBook
        }
        else {
            print(error!.localizedDescription)
        }
    }
    
    
    @IBAction func LogInButtonPressed(_ sender: UIButton) {
        self.userIDTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        LogonViewController.GlobalVariable.userID =  self.userIDTextField.text!
        LogonViewController.GlobalVariable.urlString = self.urlTextField.text!
        
        let userName = self.userIDTextField.text
        let userPassword = self.passwordTextField.text
        
        if (userName?.isEmpty)! || (userPassword?.isEmpty)! {
            print("User name \(String(describing: userName)) or password \(String(describing: userPassword)) is empty")
            displayAlertMessage(userMsg: "One of the required fields is missing")
            
            return
        }
        
        // Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        // Position Activity Indicator
        myActivityIndicator.center = view.center
        // If needed, yoou can prevent Activity Indicator fromhiding when stopAnimating is called
        myActivityIndicator.hidesWhenStopped = false
        // Start the Activity Indicator
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        print("UserID", userName)
        print("Password", userPassword)
        
        
        self.loggedIn = true
        
        LogonViewController.GetControlBookData()
    }
    
    //
    func displayAlertMessage(userMsg: String) -> Void {
        let alertCtr = UIAlertController(title: "Alert", message: userMsg, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        {(action: UIAlertAction!) in
            print("Ok button tapped")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alertCtr.addAction(OKAction)
        self.present(alertCtr, animated: true, completion: nil)
    }
    
    //
    static func GetControlBookData () {
        ControlBookReader.GetAWS_SSERevenue(fiscalYear: 2017) {
            (revJson, error) -> Void in
            
            // This transitions to the
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            
            // Set the a Revenue JSON in the Revenue VC
            let revNavCtl = tabBarController.viewControllers?[0] as! UINavigationController
            let revenueVC = revNavCtl.viewControllers[0] as! RevenueViewController
            revenueVC.revenueJSON = revJson
            
            ControlBookReader.GetAWS_CircleOfExcellence(fiscalYear: 2017) {
                (coeJsonArray, error) -> Void in
                
                
                // Set the COE JSON in the COE VC
                let coenavCtl = tabBarController.viewControllers?[1] as! UINavigationController
                let coeVC = coenavCtl.viewControllers[0] as! CircleOfExcellenceViewController
                coeVC.coeList = coeJsonArray
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = tabBarController
                
            }
            
            //            ControlBookReader.GetAWS_SSERevenue(fiscalYear: 2017) {
            //                (revJson, error) -> Void in
            //
            //                print("GetAWS_SSERevenue, error= \(error)")
            //                //                let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //                let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            
            
            // Set the COE JSON in the COE VC
            //                let coenavCtl = tabBarController.viewControllers?[1] as! UINavigationController
            //                let coeVC = coenavCtl.viewControllers[0] as! CircleOfExcellenceViewController
            //                coeVC.coeList = coeJsonArray
            //
            //                let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //                appDelegate.window?.rootViewController = tabBarController
            
            //            }
            //            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //            appDelegate.window?.rootViewController = tabBarController
        }
    }
}

