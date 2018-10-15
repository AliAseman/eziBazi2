//
//  Search.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/6/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//
import UIKit
class Search{
    static var gameArray = [Game]()
    static var message :String = ""
    static func serachMethod(_ textSearched:String,urlType:String,completion:@escaping (Array<Game>, String)-> Void){
        var url:URL!
        gameArray.removeAll()
        if urlType == "shop" || urlType == "rent"{
            url = URL(string: "http://192.168.10.83/izi-bazi.ud/api/game-for-\(urlType)-search")
        }else{
             url = URL(string: "http://192.168.10.83/izi-bazi.ud/api/\(urlType)-search")
        }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let postString = "city_id=329&text=\(textSearched)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(String(describing: responseString))")
            do{
                let dictionary = try  JSONSerialization.jsonObject(with: data) as! [String:Any]
                for (key,value) in dictionary {
                    if (key == "data"){
                        if let info:[[ String : Any ]] = value as? [[ String : Any ]]{
                            for data in info {
                                gameArray.append(Game.gameObjectParser(data))
                            }
                        }
                    }else if key == "message"{
                        
                        message = value as! String
                        
                    }
                }
                DispatchQueue.main.async {
                    completion(gameArray,message)
                }
            }catch{
                
            }
        }
        task.resume()
    }
}
