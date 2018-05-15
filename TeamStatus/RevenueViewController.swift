//
//  RevenueViewController.swift
//  TeamStatus
//
//  Created by craig.brossman@ricoh-usa.com on 2/14/18.
//  Copyright © 2018 craig.brossman@ricoh-usa.com. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI

let MonthlyPropertyLabels = [
    ["Core Services", "Misc Services", "Total"],
    ["Plan", "Margin", "Attainment"],
    ["YTD Actual", "Plan", "Margin", "Attainment"]]

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

class RevenueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var revenueJSON: Revenue?
    var revMonthIndex = 0
    
    @IBOutlet weak var revTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if !AWSSignInManager.sharedInstance().isLoggedIn {
////            let config = AWSAuthUIConfiguration()
//            AWSAuthUIViewController.presentViewController(with: self.navigationController!, configuration: nil, completionHandler: { (provider: AWSSignInProvider, error: Error?) in
//                if error != nil {
//                    print("Error occured: \(String(describing: error))")
//                }
//                else {
//
//                }
//            })
//        }
        
        self.navigationItem.title = self.revenueJSON?.month[revMonthIndex].date

        revTableView.delegate = self
        revTableView.dataSource = self

        if (revMonthIndex + 1) >= (self.revenueJSON?.month.count)! {
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @IBAction func nextMonthRev(_ sender: UIBarButtonItem) {
        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
        let nextRevVC = storyboard.instantiateViewController(withIdentifier: "RevenueViewController") as! RevenueViewController
        
        nextRevVC.revenueJSON = self.revenueJSON
        nextRevVC.revMonthIndex = self.revMonthIndex + 1
        
        self.navigationController?.pushViewController(nextRevVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 3
        case 1:
            return 3
        case 2:
            return 4
        default:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            return "Actual Monthly Revenue"
        case 1:
            return "Actual vs Plan Revenue"
        case 2:
            return "YTD vs Plan Revenue"
        default:
            return "something went wrong"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = revTableView.dequeueReusableCell(withIdentifier: "RevenueTableViewCell", for: indexPath) as! RevenueTableViewCell
        let month = self.revenueJSON?.month[revMonthIndex]
        
        cell.propertyLabel.text = MonthlyPropertyLabels[indexPath.section][indexPath.row]
        var val: Int?
        var isPercentage = false
        
        switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
            case 0:
                val = month?.actuals.coreServices
            case 1:
                val = month?.actuals.miscServices
            default:
                val = month?.actuals.total
            }
        case 1:
            switch (indexPath.row) {
            case 0:
                val = month?.monthVsPlan.plan
            case 1:
                val = month?.monthVsPlan.MvsP
            default:
                val = month?.monthVsPlan.attainment
                isPercentage = true
            }
        default:
            switch (indexPath.row) {
            case 0:
                val = month?.ytdVsPlan.actual
            case 1:
                val = month?.ytdVsPlan.plan
            case 2:
                val = month?.ytdVsPlan.YTDvsP
            default:
                val = month?.ytdVsPlan.attainment
                isPercentage = true
            }
        }
        
        if isPercentage {
            cell.valueText.text = String(val!) + "%"
        }
        else {
            cell.valueText.text = currencyFormatter.string(from: NSNumber(value: val!))
        }
        
        if val! < 0 || (isPercentage && val! < 100){
            cell.valueText.textColor = UIColor.red
        }
        else {
            cell.valueText.textColor = UIColor(hexString: "57984F")
            // (displayP3Red: 0x57, green: 0x98, blue: 0x4f, alpha: 0xff)
        }
        
      
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    let ytdLauncher = YTDLauncher()
    
    @IBAction func YTDPressed(_ sender: UIButton) {
        ytdLauncher.ytdJSON = revenueJSON?.ytdTotals
        ytdLauncher.showYTD()
    }
//    @IBAction func YTDButton(_ sender: UIButton) {
//        ytdLauncher.ytdJSON = revenueJSON?.ytdTotals
//        ytdLauncher.showYTD()
//    }
    
    
//    
//    let blackView = UIView()
//    
//    func handleYTDTotal() {
//        if let window = UIApplication.shared.keyWindow {
//            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
//            
//            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RevenueViewController.handleDismiss(_ :))))
//            //            #selector(handleDismiss(_:))))
//            
//            view.addSubview(blackView)
//            blackView.alpha = 0.0
//            blackView.frame = window.frame
//            
//            UIView.animate(withDuration: 0.5, animations: {
//                self.blackView.alpha = 1.0
//            })
//        }
//    }
//    
//    //    @objc func handleDismiss(_ sender: UIGestureRecognizer) {
//    @objc func handleDismiss(_ sender: UITapGestureRecognizer) {
//        UIView.animate(withDuration: 0.5) {
//            self.blackView.alpha = 0.0
//        }
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
