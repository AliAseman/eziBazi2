//
//  SaleViewController.swift
//  EziBazi2
//
//  Created by AliArabgary on 9/26/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit

class SaleViewController: UIViewController {
    var saleUrl:String = "http://192.168.10.83/izi-bazi.ud/api/game-for-shop-index/329"
    var gameArray = [Game]()
    var nextPageUrl:String!
    var activityIndicatorView:UIActivityIndicatorView!
    var isFetchingMore = false
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    @IBOutlet weak var saleTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "فروشی ها"
        saleTableView.register(UINib(nibName: "spinnerCell", bundle: nil), forCellReuseIdentifier: "spinnerCell")
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        saleTableView.backgroundView = activityIndicatorView
        activityIndicatorView.startAnimating()
        GetDataForSaleVC.getData(saleUrl) {(games, nextPage) in
            self.gameArray = games
            self.nextPageUrl = nextPage
            self.saleTableView.reloadData()
            OperationQueue.main.addOperation() {
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("Disappear")
    }
    override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
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
}
extension SaleViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return gameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let saleCell = tableView.dequeueReusableCell(withIdentifier: "saleCell", for: indexPath) as! SaleTableViewCell
        makeCircular(saleCell.gameImage)
        makeCircular(saleCell.View)
        makeCircular(saleCell.gamePrice)
        saleCell.gameImage.image = UIImage(data: try! Data(contentsOf: URL(string: gameArray[indexPath.row].photoUrl[0])!))
        saleCell.gameName.text = gameArray[indexPath.row].name
        if gameArray[indexPath.row].count == "0"{
            saleCell.gamePrice.backgroundColor = UIColor.notAvailable
            saleCell.gamePrice.text = " ناموجود "
        }else{
            saleCell.gamePrice.backgroundColor = UIColor.Available
            saleCell.gamePrice.text = " \((gameArray[indexPath.row].price)!)  تومان  "
        }
            saleCell.gameRegion.text = "Region :\((gameArray[indexPath.row].region)!)"
        if gameArray[indexPath.row].console_type == "ps1" || gameArray[indexPath.row].console_type == "ps4" || gameArray[indexPath.row].console_type == "ps2"{
            saleCell.consoleImage.image = UIImage(named:"ps")
        }else{
            saleCell.consoleImage.image = UIImage(named:"xbox")
        }
        return saleCell
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "gameDetails") as? GameDetails
        destination?.game = gameArray[indexPath.row]
        destination?.isForRent = false
        navigationController?.pushViewController(destination!, animated: true)
    }
    //MARK...Helper Methods
    internal func makeCircular(_ view:UIView){
        // imageFram.layer.borderWidth = 1
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.height/5
        view.clipsToBounds = true
}
    func scrollViewDidScroll(_ tableView: UIScrollView) {
        if tableView.contentOffset.y > (tableView.contentSize.height - tableView.frame.height * 1.5) {
            if !isFetchingMore{
                self.isFetchingMore = true
                print("End of tableView")
                print(nextPageUrl)
                if nextPageUrl != nil {
                GetDataForRentVC.getData(nextPageUrl) { (games, nextPage) in
                    self.gameArray = games
                    self.nextPageUrl = nextPage
                    if self.nextPageUrl != "<null>"{
                        self.isFetchingMore = true
                    }
                    print("this is next page ---> \((self.nextPageUrl)!)")
                    self.saleTableView.reloadData()
                    
                }
            }
        }
    }
}
    func animateTable() {
        let cells = saleTableView.visibleCells
        let tableViewHeight = saleTableView.bounds.size.height
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
