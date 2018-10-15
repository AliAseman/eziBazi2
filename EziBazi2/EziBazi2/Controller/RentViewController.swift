//
//  SaleViewController.swift
//  EziBazi2
//
//  Created by AliArabgary on 9/26/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit

class RentViewController: UIViewController {
    var rentUrl:String = "http://192.168.10.83/izi-bazi.ud/api/game-for-rent-index/329"
    var gameArray = [Game]()
    var nextPageUrl:String!
    var isFetchingMore = false
    var activityIndicatorView:UIActivityIndicatorView!
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    @IBOutlet weak var loadingView: loadData!
    @IBOutlet weak var rentTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "اجاره ای ها"
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        rentTableView.backgroundView = activityIndicatorView
        activityIndicatorView.startAnimating()
        GetDataForRentVC.getData(rentUrl) {(games, nextPage) in
            print("Hello There")
            self.gameArray = games
            self.nextPageUrl = nextPage
            self.rentTableView.reloadData()
            OperationQueue.main.addOperation() {
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Reachability.Connection() == true {
            print( "Internet Connected")
        } else {
            showToast(message: "خطا در اتصال !")
            print("خطا در اتصال به اینترنت !")
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("Disappear")
    }
}
extension RentViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return gameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rentCell = tableView.dequeueReusableCell(withIdentifier: "rentCell", for: indexPath) as! RentTableViewCell
        makeCircular(rentCell.gameImage)
        makeCircular(rentCell.view)
        makeCircular(rentCell.price)
        let url = URL(string: gameArray[indexPath.row].photoUrl[0])
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        rentCell.gameImage.image = UIImage(data: data!)
        rentCell.gameName.text = gameArray[indexPath.row].name
        rentCell.region.text = "Region :\((gameArray[indexPath.row].region)!)"
        if gameArray[indexPath.row].count == "0"{
            rentCell.price.backgroundColor = UIColor.notAvailable
            rentCell.price.text = " ناموجود "
        }else{
            rentCell.price.backgroundColor = UIColor.Available
            rentCell.price.text = " \((gameArray[indexPath.row].price)!)  تومان  "
        }
            if gameArray[indexPath.row].console_type == "ps1" || gameArray[indexPath.row].console_type == "ps4" || gameArray[indexPath.row].console_type == "ps2"{
                rentCell.consoleType.image = UIImage(named:"ps")
            }else{
                rentCell.consoleType.image = UIImage(named:"xbox")
            }
        return rentCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "gameDetails") as? GameDetails
        destination?.game = gameArray[indexPath.row]
        destination?.isForRent = true
        navigationController?.pushViewController(destination!, animated: true)
    }
    
    //Helper Methods
    func scrollViewDidScroll(_ tableView: UIScrollView) {
        if tableView.contentSize.height != 0 {
            if tableView.contentOffset.y > (tableView.contentSize.height - tableView.frame.height * 1.5){
                if !isFetchingMore{
                    self.isFetchingMore = true
                    print("End of tableView")
                    if nextPageUrl != nil {
                    GetDataForRentVC.getData(nextPageUrl) { (games, nextPage) in
                        self.gameArray = games
                        self.nextPageUrl = nextPage
                        print(self.nextPageUrl)
//                        if self.nextPageUrl != "<null>"{
//                        }
                        self.isFetchingMore = true
                        print("this is next page ---> \((self.nextPageUrl)!)")
                        self.rentTableView.reloadData()
                        
                    }
                }
            }
        }
    }
}
    internal func makeCircular(_ view:UIView){
        // imageFram.layer.borderWidth = 1
        view.layer.masksToBounds = true
        //imageFram.layer.borderColor = UIColor(red: 255/255, green: 209/255, blue: 25/255, alpha:1).cgColor
        view.layer.cornerRadius = view.frame.height/10
        view.clipsToBounds = true
    }
    func animateTable() {
        rentTableView.reloadData()
        let cells = rentTableView.visibleCells
        let tableViewHeight = rentTableView.bounds.size.height
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}
