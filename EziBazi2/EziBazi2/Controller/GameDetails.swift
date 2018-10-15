//
//  GameDetails.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/11/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit

class GameDetails: UIViewController {

    @IBOutlet weak var gameImage: UIImageView!
    
    @IBOutlet weak var gameName: UILabel!
    
    @IBOutlet weak var gameRegion: UILabel!
    
    @IBOutlet weak var gameGenres: UILabel!
    
    @IBOutlet weak var rentPriod: UISegmentedControl!
    
    @IBOutlet weak var gamePrice: UIButton!
    
    @IBOutlet weak var gameReleaseYear: UILabel!
    
    @IBOutlet weak var gameConsole: UIImageView!
    
    @IBOutlet weak var gameAge: UILabel!
    
    @IBOutlet weak var gameComment: UIButton!
    
    @IBOutlet weak var relatedCollectionView: UICollectionView!
    
    @IBOutlet weak var relatedLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    
    @IBAction func selectedSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
             gamePrice.setTitle("\(game.price!/1500)  هزار تومان", for: .normal)
        }else if sender.selectedSegmentIndex == 1 {
             gamePrice.setTitle("\(game.price!/2000)  هزار تومان", for: .normal)
        }else if sender.selectedSegmentIndex == 2 {
             gamePrice.setTitle("\(game.price!/2500)  هزار تومان", for: .normal)
        }else if sender.selectedSegmentIndex == 3 {
             gamePrice.setTitle("\(game.price!/3000)  هزار تومان", for: .normal)
        }
        
    }
    var relatedActivityIndicator:UIActivityIndicatorView!
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    var game = Game()
    var RentRelatedUrl:String!
    var saleRelatedeUrl:String!
    var postRelatedUrl:String!
    var relatedGames = [Game]()
    var isForRent = false
    override func viewDidLoad() {
        super.viewDidLoad()
        relatedGames.removeAll()
        print("View did load in Details")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.makeCircular(gamePrice)
        appDelegate.makeCircular(gameComment)
        relatedActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        relatedActivityIndicator.startAnimating()
        if game.count == "0"{
            timeLabel.isHidden = true
            gamePrice.backgroundColor = UIColor.notAvailable
            gamePrice.setTitle(" ناموجود ", for: .normal)
            gameImage.image =  UIImage(data: try! Data(contentsOf: URL(string: game.photoUrl[0])!))
            rentPriod.isHidden = true
            gameRegion.text = "Region : \(String(describing: game.region!))"
            gameGenres.text = "Genres : \(game.genres.joined(separator: ","))"
            if game.console_type == "ps1" || game.console_type == "ps4" || game.console_type == "ps2"{
                gameConsole.image = UIImage(named:"ps")
            }else{
                gameConsole.image = UIImage(named:"xbox")
            }
            gameAge.text = game.age_class
            let date = game.production_date!
            let idx = date.index(date.startIndex, offsetBy: 3)
            gameReleaseYear.text = String(date[...idx])
            
        }else if isForRent{
            timeLabel.isHidden = false
            gamePrice.backgroundColor = UIColor.Available
            gameImage.image =  UIImage(data: try! Data(contentsOf: URL(string: game.photoUrl[0])!))
            gameName.text = game.name
            if rentPriod.selectedSegmentIndex == 0 {
                gamePrice.setTitle("\(game.price!/1500)  هزار تومان", for: .normal)
            }
            gameRegion.text = "Region : \(String(describing: game.region!))"
            gameGenres.text = "Genres : \(game.genres.joined(separator: ","))"
            if game.console_type == "ps1" || game.console_type == "ps4" || game.console_type == "ps2"{
                gameConsole.image = UIImage(named:"ps")
            }else{
                gameConsole.image = UIImage(named:"xbox")
            }
            gameAge.text = game.age_class
            let date = game.production_date!
            let idx = date.index(date.startIndex, offsetBy: 3)
            gameReleaseYear.text = String(date[...idx])
      
        }else if !isForRent{
            timeLabel.isHidden = true
            gamePrice.backgroundColor = UIColor.Available
            gamePrice.setTitle(" \(game.price!)  هزار تومان", for: .normal)
            gameImage.image =  UIImage(data: try! Data(contentsOf: URL(string: game.photoUrl[0])!))
            rentPriod.isHidden = true
            gameRegion.text = "Region : \(String(describing: game.region!))"
            gameGenres.text = "Genres : \(game.genres.joined(separator: ","))"
            if game.console_type == "ps1" || game.console_type == "ps4" || game.console_type == "ps2"{
                gameConsole.image = UIImage(named:"ps")
            }else{
                gameConsole.image = UIImage(named:"xbox")
            }
            gameAge.text = game.age_class
            let date = game.production_date!
            let idx = date.index(date.startIndex, offsetBy: 3)
            gameReleaseYear.text = String(date[...idx])
            
        }
        relatedCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        RentRelatedUrl = "http://192.168.10.83/izi-bazi.ud/api/game-for-rent-related/\(String(describing: game.id!))"
        saleRelatedeUrl = "http://192.168.10.83/izi-bazi.ud/api/game-for-shop-related/\(String(describing: game.id!))"
        postRelatedUrl = "http://192.168.10.83/izi-bazi.ud/api/game-for-post-related/\(String(describing: game.id!))"
        
        var url = ""
        if isForRent{
            url = RentRelatedUrl
            print(url)
        }else {
            url = saleRelatedeUrl
            print(url)
        }
        GetDataForRentRelated.getData(url){(Games) in
            self.relatedGames = Games
            print(self.scrollViewBottom.constant)
            if self.relatedGames.count == 0 {
                self.scrollViewBottom.constant = -(self.scrollViewBottom.constant + self.relatedCollectionView.frame.height)
                self.relatedLabel.isHidden = true
                self.relatedCollectionView.isHidden = true
            }else{
                self.view.frame.size.height = (self.view.frame.size.height) + (self.relatedCollectionView.frame.size.height)
                self.relatedLabel.isHidden = false
                self.relatedCollectionView.isHidden = false
                self.relatedCollectionView.reloadData()
                OperationQueue.main.addOperation() {
                    self.relatedActivityIndicator.stopAnimating()
                }
            }
        }
        
}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("View did diaappear")
    }
  
}
extension GameDetails:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedGames.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let detailesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "recomandCell", for: indexPath) as? GameDetailsCell
        detailesCell?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        detailesCell?.gameImage.image = UIImage(data: try! Data(contentsOf: URL(string: relatedGames[indexPath.row].photoUrl[0])!))
        detailesCell?.gameName.text = relatedGames[indexPath.row].name
        detailesCell?.gamePrice.text =  "\(String(describing: relatedGames[indexPath.row].price!)) تومان"
        return detailesCell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "gameDetails") as? GameDetails
        destination?.game = relatedGames[indexPath.row]
        navigationController?.pushViewController(destination!, animated: true)
    }
    
    
    
}


