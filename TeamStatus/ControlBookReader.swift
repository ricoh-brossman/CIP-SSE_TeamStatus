//
//  ControlBookReader.swift
//  TeamStatus
//
//  Created by craig.brossman@ricoh-usa.com on 3/12/18.
//  Copyright © 2018 craig.brossman@ricoh-usa.com. All rights reserved.
//

import Foundation
import AWSCore
import AWSDynamoDB

struct SSE_Details: Decodable {
    let profServ: Int?
    let sw1: Int?
    let sw2: Int?
}
struct SSE: Decodable {
    let name: String
    let revenue: Int
    let details: SSE_Details?
}

struct CircleOfExcellence: Decodable {
    let date: String
    let SSE_PM: [SSE]
    let total: Int?
}

struct Actuals: Decodable {
    let coreServices: Int
    let miscServices: Int
    let total: Int
}

struct MonthVsPlan: Decodable {
    let plan: Int
    let MvsP: Int
    let attainment: Int
}

struct YtdVsPlan: Decodable {
    let actual: Int
    let plan: Int
    let YTDvsP: Int
    let attainment: Int
}

struct Month: Decodable {
    let date: String
    let actuals: Actuals
    let monthVsPlan: MonthVsPlan
    let ytdVsPlan: YtdVsPlan
}

struct YTDTotals: Decodable {
    let actualCoreServices: Int
    let actualMiscServices: Int
    let actualTotal: Int
    let planTotal: Int
    
}

struct Revenue: Decodable {
    var month: [Month]
    let ytdTotals: YTDTotals
}

//
struct FinancialJSON: Decodable {
    let circleOfExcellence: CircleOfExcellence
    let revenue: Revenue
}

class ControlBookReader {
    //    static func ReadControlBooks(url: String, completion:
    //        ((_ reportDate: String?, _ coeJson: [CircleOfExcellence]?,_ revenue: Revenue?,_ error:  [String : Error]) -> Void)!) {
    //
    //        var urlStrings = [String]()
    //        var errors = [String : Error]()
    //
    //        if let urlStr = Bundle.main.path(forResource: "Control Book 2017-12", ofType: "json") {
    //            urlStrings.append(urlStr)
    //        }
    //        else {
    //            print("Control Book Name is not found")
    //        }
    //
    //        if let urlStr = Bundle.main.path(forResource: "Control Book 2018-01", ofType: "json") {
    //            urlStrings.append(urlStr)
    //        }
    //        else {
    //            print("Control Book Name is not found")
    //        }
    //
    //        if let urlStr = Bundle.main.path(forResource: "Control Book 2018-02", ofType: "json") {
    //            urlStrings.append(urlStr)
    //        }
    //        else {
    //            print("Control Book Name is not found")
    //        }
    //
    //        let cbNameBad = "Control Book 2099-01"
    //        if let urlStr = Bundle.main.path(forResource: cbNameBad, ofType: "json") {
    //            urlStrings.append(urlStr)
    //        }
    //        else {
    //            let errMsg = "File not found " + cbNameBad
    //            errors[cbNameBad] = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errMsg])
    //        }
    //
    //        var coeJsonArray = [CircleOfExcellence]()
    //        var revJson: Revenue?
    //        var currentReportDate: String? = nil
    //
    //        // Essentially a counting semaphore
    //        let group = DispatchGroup()
    //
    //        for urlString in urlStrings {
    //            group.enter()
    //
    //            let jsonFileURL =  URL(fileURLWithPath: urlString)
    //
    //            URLReader.ReadJSON(fileURL: jsonFileURL, myStruct: FinancialJSON.self)
    //            {
    //                (finJson, error) -> Void in
    //
    //                if error != nil {
    //                    print("ControlBookReader: urlString", urlString)
    //                    print("ControlBookReader: error", error)
    //                    errors[urlString] = error
    //                }
    //                else {
    //                    coeJsonArray.append((finJson?.circleOfExcellence)!)
    //
    //                    var tempRevenue = finJson?.revenue
    //                    var months = tempRevenue?.month
    //
    //                    // Sort the array of Revenue.Months by date
    //                    months?.sort(by: {$0.date > $1.date})
    //
    //                    tempRevenue?.month = months!
    //
    //                    if IsNewerReport((tempRevenue?.month[0].date)!, currentReportDate) {
    //                        revJson = tempRevenue!
    //                        currentReportDate = tempRevenue?.month[0].date
    //                    }
    //                }
    //                group.leave()
    //            }
    //        }
    //
    //        // This will wait for the counting semaphore to reach 0
    //        group.wait()
    //
    //        // Sort the array of COE entries by date
    //        coeJsonArray.sort(by: {$0.date > $1.date})
    //        completion(currentReportDate, coeJsonArray, revJson, errors)
    //    }
    
    static func GetAWS_CircleOfExcellence(fiscalYear: Int, completion:
        ((_ coeJson: [CircleOfExcellence], _ error:  Error?) -> Void)!) {
        
        var error: Error? = nil
        var ssePMs = [SSE]()
        var coeList = [CircleOfExcellence]()
        let awsClient = COECircleOfExcellenceClient.default();
        awsClient.apiKey = "eHGOjGsMyn1VwRL6dWIqqaO7ggBxwNOu8lJrjoVM"
        
        // Essentially a counting semaphore
        let group = DispatchGroup()
        group.enter()
        
        awsClient.fiscalyearFiscalyearGet(fiscalyear: String(fiscalYear)).continueWith(block: { (task: AWSTask?) -> AnyObject? in
            if let err = task?.error {
                error = err
                
                //                print("Error occurred: \(error)")
                //                print("Localized desc: \(error.localizedDescription)")
            }
                
            else if let result = task?.result {
                //                print("No Error: task.result = \(result)")
                
                if (result.count?.intValue)! > Int(0) {
                    for item in result.items! {
                        ssePMs.removeAll()
                        //                           print("Item \(i)")
                        print("Item date: \(String(describing: item.COE?.date))")
                        if item.COE?.date == "2017-12" {
                            print("Bad Item: \(String(describing: item))")
                        }
                        
                        for sse in (item.COE?.SSE_PM)! {
                            let details = SSE_Details(profServ: sse.details?.profServ?.intValue, sw1: sse.details?.sw1?.intValue,  sw2: sse.details?.sw12?.intValue)
                            
                            let sse =  SSE(name: sse.name!, revenue: (sse.revenue?.intValue)!, details: details)
                            
                            ssePMs.append(sse)
                            
                            print("\(String(describing: sse))")
                        }
                        
                        coeList.append(CircleOfExcellence(date: (item.COE?.date)!, SSE_PM: ssePMs, total: 0))
                    }
                }
            }
            
            group.leave()
            return nil
        })
        
        // This will wait for the counting semaphore to reach 0
        group.wait()
        
        // Sort the array of COE entries by date
        coeList.sort(by: {$0.date > $1.date})
        completion(coeList, error)
    }
    
    static func GetAWS_SSERevenue(fiscalYear: Int, completion:
        ((_ revJson: Revenue?, _ error:  Error?) -> Void)!) {
        
        var error: Error? = nil
        var rev: Revenue?
        let awsClient = REVCIPSSERevenueClient.default();
        awsClient.apiKey = "eHGOjGsMyn1VwRL6dWIqqaO7ggBxwNOu8lJrjoVM"
        
        // Essentially a counting semaphore
        let group = DispatchGroup()
        group.enter()
        
        awsClient.fiscalyearFiscalyearGet(fiscalyear: String(fiscalYear)).continueWith(block: { (task: AWSTask?) -> AnyObject? in
            if let err = task?.error {
                error = err
                //                print("Error occurred: \(error)")
                //                print("Localized desc: \(error.localizedDescription)")
            }
                
            else if let result = task?.result {
                //                print("No Error: task.result = \(result)")
                var lastFiscalMonth = 0
                
                if (result.count?.intValue)! > Int(0) {
                    for item in result.items! {
                        //                        print(item)
                        
                        if (item.fiscalMonth?.intValue)! > lastFiscalMonth {
                            lastFiscalMonth = (item.fiscalMonth?.intValue)!
                            
                            var months = [Month]()
                            
                            for m in (item.revenue?.month)! {
                                let actuals = Actuals(coreServices: (m.actuals?.coreServices?.intValue)!, miscServices: (m.actuals?.miscServices?.intValue)!, total: (m.actuals?.total?.intValue)!)
                                let mVSp = MonthVsPlan(plan: (m.monthVsPlan?.plan?.intValue)!, MvsP: (m.monthVsPlan?.mvsP?.intValue)!, attainment: (m.monthVsPlan?.attainment?.intValue)!)
                                let ytdVSp = YtdVsPlan(actual: (m.ytdVsPlan?.attainment?.intValue)!, plan: (m.ytdVsPlan?.plan?.intValue)!, YTDvsP: (m.ytdVsPlan?.yTDvsP?.intValue)!, attainment: (m.ytdVsPlan?.attainment?.intValue)!)
                                
                                let month = Month(date: m.date!, actuals: actuals, monthVsPlan: mVSp, ytdVsPlan: ytdVSp)
                                
                                months.append(month)
                            }
                            
                            // Sort the array of Revenue.Months by date
                            months.sort(by: {$0.date > $1.date})
                            
                            let ytdTotals = YTDTotals(actualCoreServices: (item.revenue?.ytdTotals?.actualCoreServices?.intValue)!, actualMiscServices: (item.revenue?.ytdTotals?.actualMiscServices?.intValue)!, actualTotal: (item.revenue?.ytdTotals?.actualTotal?.intValue)!, planTotal: (item.revenue?.ytdTotals?.planTotal?.intValue)!)
                            
                            rev = Revenue(month: months, ytdTotals: ytdTotals)
                        }
                    }
                    //                    print(rev)
                }
            }
            
            group.leave()
            return nil
        })
        
        // This will wait for the counting semaphore to reach 0
        group.wait()
        completion(rev, error)
    }
    
    //    private static func IsNewerReport(_ newReportDate: String, _ currentReportDate: String?) -> Bool {
    //        return (currentReportDate == nil || newReportDate > currentReportDate!)
    //    }
}
