//
//  YTDLauncher.swift
//  TeamStatus
//
//  Created by craig.brossman@ricoh-usa.com on 3/20/18.
//  Copyright © 2018 craig.brossman@ricoh-usa.com. All rights reserved.
//

import Foundation
import UIKit

class YTD: NSObject {
    let property: String
    let value: String
    
     init(property: String, value: String) {
        
        self.property = property
        self.value = value
    }
}

class YTDLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var ytdJSON: YTDTotals?
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(YTDCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 30.0
    
    func showYTD() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(YTDLauncher.handleDismiss(_ :))))
            //            #selector(handleDismiss(_:))))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(CGFloat(Properties.count) * cellHeight)
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.alpha = 0.0
            blackView.frame = window.frame
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.blackView.alpha = 1.0
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    //    @objc func handleDismiss(_ sender: UIGestureRecognizer) {
    @objc func handleDismiss(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0.0
            //            self.collectionView.frame
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Properties.count
    }
    
     func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! YTDCell
        
        let prop = Properties[indexPath.row]
        var val: Int?
        
        switch indexPath.row {
        case 0:
            val = self.ytdJSON?.actualCoreServices
        case 1:
            val = self.ytdJSON?.actualMiscServices
        case 2:
            val = self.ytdJSON?.actualTotal
        default:
            val = self.ytdJSON?.planTotal
        }
        
        cell.ytd = YTD(property: prop, value: currencyFormatter.string(from: NSNumber(value: val!))!)
        
        return cell
    }
    
    
    let Properties = ["Actual Core Services", "Actual Misc Services", "Actual Total", "Plan Total"]
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
