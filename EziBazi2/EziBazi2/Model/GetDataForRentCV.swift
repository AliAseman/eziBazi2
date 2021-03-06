//
//  SaleData.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/4/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit

class GetDataForRentCV {
    static var gameArray = [Game]()
    static  var lastPageUrl:String!
    static func getData(_ Url:String,completion:@escaping (Array<Game>,String)-> Void){
        var request = URLRequest(url: URL(string:Url )!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {               // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            do{
                
                let dictionary = try  JSONSerialization.jsonObject(with: data) as! [String:Any]
                
                for (key,value) in dictionary {
                    if (key == "data"){
                        for (key,value) in value as! [String:Any]{
                            if (key == "data"){
                                if let info:[[ String : Any ]] = value as? [[ String : Any ]]{
                                    for data in info {
                                        
                                        gameArray.append(Game.gameObjectParser(data))
                                    }
                                }
                            }else if key == "next_page_url"{
                                lastPageUrl = String(describing:value)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    let container = gameArray
                    completion(container,lastPageUrl)
                    gameArray.removeAll()
                }
                
            }
            catch{
                print(" Sale api don't work body!!!")
            }
        }
        task.resume()
    }
    
}

