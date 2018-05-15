//
//  CircleOfExcellenceViewController.swift
//  TeamStatus
//
//  Created by craig.brossman@ricoh-usa.com on 2/14/18.
//  Copyright © 2018 craig.brossman@ricoh-usa.com. All rights reserved.
//

import UIKit

class CircleOfExcellenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var coeList = [CircleOfExcellence]()
    var coeMonthIndex = 0
    //    var currencyFormatter = NumberFormatter()
    
    @IBOutlet weak var nextCOEButton: UIButton!
    
    @IBAction func showNextCOE(_ sender: Any) {
        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
        let nextCOEVC = storyboard.instantiateViewController(withIdentifier: "CircleOfExcellenceViewController") as! CircleOfExcellenceViewController
        
        nextCOEVC.coeList = self.coeList
        nextCOEVC.coeMonthIndex = self.coeMonthIndex + 1
        
        self.navigationController?.pushViewController(nextCOEVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.coeList[coeMonthIndex].date
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if (coeMonthIndex + 1) >= coeList.count {
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
        let coePopOverVC = storyboard.instantiateViewController(withIdentifier: "SSE_COE_PopOverViewController") as? SSE_COE_PopOverViewController
     
        coePopOverVC!.popoverPresentationController?.delegate = self
        
        coePopOverVC!.preferredContentSize = CGSize(width: 350, height: 175)
        coePopOverVC!.modalPresentationStyle = UIModalPresentationStyle.popover
        coePopOverVC!.popoverPresentationController?.permittedArrowDirections = .any
        coePopOverVC!.popoverPresentationController?.delegate = self
        coePopOverVC!.sseData = self.coeList[coeMonthIndex].SSE_PM[indexPath.row]
        
        let selectedCellSourceView = tableView.cellForRow(at: indexPath)
        let selectedCellSourceRect = selectedCellSourceView?.bounds
        coePopOverVC!.popoverPresentationController?.sourceView = selectedCellSourceView
        coePopOverVC!.popoverPresentationController?.sourceRect = selectedCellSourceRect!
        coePopOverVC!.popoverPresentationController?.backgroundColor = UIColor(hexString: "FF5E53")
        
        self.present(coePopOverVC!, animated: true, completion: nil)
    }
    
    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {
        let viewFrame = popoverPresentationController.sourceView?.frame
        let deltaX = (viewFrame?.height)! - rect.pointee.midX
        
        rect.pointee = CGRect(x: (viewFrame?.width)! - deltaX, y: rect.pointee.maxY, width: 0, height: 0)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(coeList[coeMonthIndex].SSE_PM.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {    
        let cell = tableView.dequeueReusableCell(withIdentifier: "COECell", for: indexPath) as! COECell
        
        let coeByMonth = coeList[coeMonthIndex]
        
        cell.SSEName.text = coeByMonth.SSE_PM[indexPath.row].name
        
        //        let amt = NSNumber(value: coeByMonth.SSE_PM[indexPath.row].revenue)
        cell.SSEAmount.text = currencyFormatter.string(from: NSNumber(value: coeByMonth.SSE_PM[indexPath.row].revenue))
        return (cell)
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
