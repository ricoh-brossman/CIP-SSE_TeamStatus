//
//  SSE_COE_PopOverViewController.swift
//  TeamStatus
//
//  Created by craig.brossman@ricoh-usa.com on 3/16/18.
//  Copyright © 2018 craig.brossman@ricoh-usa.com. All rights reserved.
//

import UIKit

class SSE_COE_PopOverViewController: UIViewController {
    
    @IBOutlet weak var SSENameTextField: UITextField!
    @IBOutlet weak var profServTextField: UITextField!
    @IBOutlet weak var swPrimaryTextField: UITextField!
    @IBOutlet weak var swSecondaryTextField: UITextField!
    
    var sseData : SSE?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if sseData != nil {
            SSENameTextField.text = sseData?.name
            
            let sseDetails = sseData!.details
            
            if sseDetails != nil {
                if sseDetails!.profServ != nil {
                    profServTextField.text = currencyFormatter.string(from: NSNumber(value: (sseData?.details?.profServ)!))
                }
                
                if sseDetails!.sw1 != nil {
                    swPrimaryTextField.text = currencyFormatter.string(from: NSNumber(value: (sseData?.details?.sw1)!))
                }
                
                if sseDetails!.sw2 != nil {
                    swSecondaryTextField.text = currencyFormatter.string(from: NSNumber(value: (sseData?.details?.sw2)!))
                }
            }
        }
        
        // Do any additional setup after loading the view.
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
