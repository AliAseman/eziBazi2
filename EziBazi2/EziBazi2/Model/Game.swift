//
//  Game.swift
//  EziBazi2
//
//  Created by AliArabgary on 9/27/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import Foundation
class Game {
    var id:String?
    var price:Int?
    var is_pending:Int?
    var name:String?
    var console_type:String?
    var gamePostTitle:String = ""
    var age_class:String?
    var postCreation:String?
    var production_date:String?
    var region:String?
    var can_play_online:Int?
    var company_name:String?
    var description:String?
    var photoUrl:[String] = []
    var genres:[String] = []
    var console_name:String?
    var nextPageUrl:String?
    var count:String?
    var on_click:String?
    public static func gameObjectParser(_ object:[ String : Any ])->Game{
        let game = Game()
        for (key,value) in object {
            if key == "game_info"{
                for (key,value) in value as! [String:Any]{
                    if key == "name"{
//                        print("THIS IS GAME'S NAME ====>  \(value)")
                        game.name = value as? String
                    }else if key == "photos"{
                        if let info:[[ String : Any ]] = value as? [[ String : Any ]]{
                            for data in info {
                                for (key,value) in data {
                                    if key == "url"{
//                                        print("THIS IS GAME'S photo url ====>  \(value)")
                                        game.photoUrl.append(value as! String)
                                    }
                                }
                            }
                        }
                    }else if key == "genres"{
                        if let info:[[ String : Any ]] = value as? [[ String : Any ]]{
                            for data in info {
                                for (key,value) in data {
                                    if key == "name"{
                                        //                                        print("THIS IS GAME'S photo url ====>  \(value)")
                                        game.genres.append(value as! String)
                                    }
                                }
                            }
                        }
                    }else if key == "console"{
                        for (key,value) in value as! [String:Any]{
                            if key == "name"{
                                game.console_type = String(describing:value)
                            }
                            
                        }
                        
                        
                    }else if key == "production_date"{
                        game.production_date = String(describing:value)
                    }else if key == "age_class"{
                        game.age_class = String(describing:value)
                    }
                }
            }else if key == "price"{
                game.price = value as? Int
            }else if key == "count"{
                game.count = String(describing:value)
            }else if key == "id"{
                game.id = String(describing:value)
            }else if key == "region"{
                //                        print("THIS IS GAME'S REGION ====>  \(value)")
                game.region = String(describing:value)
            }else if key == "title"{
                game.gamePostTitle = (value as? String)!

            }else if key == "on_click"{
                game.on_click = String(describing:value)
                
            }else if key == "photos"{
                        if let info:[[ String : Any ]] = value as? [[ String : Any ]]{
                            for data in info {
                                for (key,value) in data {
                                    if key == "url"{
                                        game.photoUrl.append(value as! String)
                                    }
                                }
                            }
                        }

            }else if key == "created_at"{
                if let date = value as? String{
                    game.postCreation = date
                }
            }
        }
        return game
    }
    /* int id;
     int game_info_id;
     int price;
     int is_pending;
     String name;
     int console_type_id;
     int age_class;
     String production_date;
     String region;
     int can_play_online;
     String company_name;
     String description;
     ArrayList<Photo> photos;
     ArrayList<Video> videos;
     ArrayList<String> genres;
     String console_name;*/
}
