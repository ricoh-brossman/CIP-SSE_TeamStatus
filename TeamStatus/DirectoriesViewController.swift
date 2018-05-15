//
//  DirectoriesViewController.swift
//  TeamStatus
//
//  Created by craig.brossman@ricoh-usa.com on 2/5/18.
//  Copyright © 2018 craig.brossman@ricoh-usa.com. All rights reserved.
//

import UIKit

class DirectoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //    let dataMgr = DataManager()
    var dataMgr: DataManager? = nil
    let mainTable: UITableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
    var urlList: [URL]? = nil
    // This is temporary until we have a VM to attach to
    //    let dirURL = URL.init(string: "file:///Users/cbrossman/Desktop/CIP-SSEControlBookData")
    var dirURL: URL? = nil
    
    var selectedURL: URL?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count: Int = self.urlList != nil ? (self.urlList?.count)! : 0
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = UITableViewCell()
        tableViewCell.textLabel?.text = self.urlList != nil ? self.urlList![indexPath.row].path : nil
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected", self.urlList![indexPath.row].path)
        
        selectedURL = self.urlList![indexPath.row]
        if selectedURL != nil
        {
            //                    self.performSegue(withIdentifier: "DirListVCSegue", sender: self)
            //            let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DirectoriesViewController")
            let destVC = storyboard!.instantiateViewController(withIdentifier: "DirectoriesViewController")
            self.navigationController?.pushViewController(destVC, animated: true)
        }
        
        
        //        let destSegue = UIStoryboardSegue(identifier: "SegueToStatusViewController"?, source: self, destination: <#T##UIViewController#>)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dirListVC = segue.destination as! DirectoriesViewController
        dirListVC.dataMgr = self.dataMgr
        dirListVC.dirURL = self.selectedURL
    }
    
    // Segue to the DirectoryListViewController, not really what I want
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        print("Row selected", self.topURLList![indexPath.row].path)
    //        selectedURL = self.topURLList![indexPath.row]
    //        if selectedURL != nil
    //        {
    //            self.performSegue(withIdentifier: "DirListVCSegue", sender: self)
    //        }
    //    }
    //
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let dirListVC = segue.destination as! DirectoryListViewController
    //        dirListVC.dataMgr = self.dataMgr
    //        dirListVC.url = self.selectedURL
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        self.mainTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.mainTable)
        
        if dataMgr == nil {
            dataMgr = DataManager()
        }
        
        if dirURL == nil {
            dirURL = URL.init(string: "file:///Users/cbrossman/Desktop/CIP-SSEControlBookData")
        }
        
        self.getURLContents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getURLContents() {
        do {
            try self.urlList = dataMgr!.getDirectoryURLs(dirURL!)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}


