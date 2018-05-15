//
//  URLReader.swift
//  TeamStatus
//
//  Created by craig.brossman@ricoh-usa.com on 2/6/18.
//  Copyright © 2018 craig.brossman@ricoh-usa.com. All rights reserved.
//

import Foundation

class URLReader {
    
    static func ReadFile(fileURL: URL!) throws -> [String]? {
        let lines: [String] =
            try String(contentsOf: fileURL, encoding: String.Encoding.ascii).components(separatedBy: CharacterSet.newlines)
        
        return lines
    }
    
    static func ReadDirectory(directoryURL : URL!, resKeys: [URLResourceKey], directoryOptions :FileManager.DirectoryEnumerationOptions = FileManager.DirectoryEnumerationOptions.skipsHiddenFiles) throws -> [URL]? {
        var urlList : [URL] = []
        
        let urlEnumerator = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: resKeys, options: directoryOptions)
        
        for case let fileURL: URL in urlEnumerator {
            urlList.append(fileURL)
        }
        
        return urlList
    }
    
    //    static func ReadJSON<Element: Decodable>(fileURL: URL, myStruct: Element.Type)
    //    {
    //
    //        let  task =  URLSession.shared.dataTask(with:  URLRequest(url: fileURL)) { (data, response, error) in
    //
    //            do {
    //            let json = try JSONDecoder().decode(myStruct.self, from: data!)
    //
    //                print("ReadJSON: ", json)
    //            }
    //            catch {
    //
    //            }
    //        }
    //
    //        task.resume()
    //    }
    
    static func ReadJSON<Element: Decodable>(fileURL: URL, myStruct: Element.Type, completion: ((_ result: Element?, _ error: Error?) -> Void)!)
    {
        URLSession.shared.dataTask(with:  URLRequest(url: fileURL)) { (data, response, error) in
            do {
                let json = try JSONDecoder().decode(myStruct.self, from: data!)
                completion(json as Element, error)
            }
            catch {
                print("ReadJSON, error (probably decoding)", error.localizedDescription)
                completion(nil, error)
            }
            }.resume()
    }
    
    
    
    //    static func ReadJSON<Element: Decodable>(fileURL: URL, myStruct: Element.Type) -> Element?
    //    {
    ////        var json: Element.Type =
    //
    //        URLSession.shared.dataTask(with:  URLRequest(url: fileURL)) { (data, response, error) in
    //            // Check error
    //            // Check response? 200 is OK???
    //            if error != nil {
    //                print("readJson: error=", error)
    //            }
    //            else {
    //                do {
    ////                    print("readJson: response=", response.debugDescription)
    //
    //                    // This is how I would prefer doing it
    //                    //                    let json = try JSONDecoder().decode(FinancialJSON.self, from: data!)
    //
    //                     let json = try JSONDecoder().decode(myStruct.self, from: data!)
    ////                    if json != nil {
    ////                        print(json)
    ////                    }
    ////                    return json
    //                }
    //                catch {
    //                    print (error)
    //                }
    //                //                    let parsedData = try JSONSerialization.jsonObject(with: data, options: .all)
    //                //                    for (key, value) in data {
    //                //                        print("   ")
    //                //        print ("  \(key) ---- \(value)")
    //            }
    //            }.resume()
    //
    //        return json
    //
    //    }
}

