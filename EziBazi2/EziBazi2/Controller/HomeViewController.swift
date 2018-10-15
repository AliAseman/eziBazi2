//
//  ViewController.swift
//  EziBazi2
//
//  Created by AliArabgary on 9/13/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit
import FSPagerView

class HomeViewController: UIViewController,FSPagerViewDataSource,FSPagerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate{
    @IBOutlet weak var homeContent: UIView!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var saleCollectionView: UICollectionView!
    @IBOutlet weak var rentCollectionView: UICollectionView!
    var saleActivityIndicatorView:UIActivityIndicatorView!
    var rentActivityIndicatorView:UIActivityIndicatorView!
    var newsActivityIndicatorView:UIActivityIndicatorView!
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    @IBOutlet weak var slider: FSPagerView!{
        didSet {
            self.slider.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            slider.automaticSlidingInterval = 3.0
            slider.isInfinite = true
            self.slider.itemSize = .zero
            //pageView.interitemSpacing = 10
            slider.transformer = FSPagerViewTransformer(type: .depth)
        }
    }
    @IBOutlet weak var sliderController:FSPageControl!{
        didSet {
            self.sliderController.numberOfPages = sliderArray.count
            self.sliderController.contentHorizontalAlignment = .right
            
            self.sliderController.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.sliderController.hidesForSinglePage = true
        }
    }
    var saleUrl:String = "http://192.168.10.83/izi-bazi.ud/api/game-for-shop-index/329"
    var rentUrl:String = "http://192.168.10.83/izi-bazi.ud/api/game-for-rent-index/329"
    var postUrl:String = "http://192.168.10.83/izi-bazi.ud/api/post"
    var slideUrl:String = "http://192.168.10.83/izi-bazi.ud/api/slider"
    var gameArray = [Game]()
    var nextPageUrl:String!
    var gameArray1 = [Game]()
    var postArray = [Game]()
    var sliderArray = [Game]()

    override func viewDidLoad() {
        super.viewDidLoad()
        saleActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        rentActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        newsActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        saleCollectionView.backgroundView = saleActivityIndicatorView
        rentCollectionView.backgroundView = rentActivityIndicatorView
        newsCollectionView.backgroundView = newsActivityIndicatorView
        saleActivityIndicatorView.startAnimating()
        rentActivityIndicatorView.startAnimating()
        newsActivityIndicatorView.startAnimating()
        GetDataForSlider.getData(slideUrl) {(games) in
            self.sliderArray = games
            self.slider.reloadData()
        }
        GetDataForPostCV.getData(postUrl) {(games, nextPage) in
            self.postArray = games
            self.nextPageUrl = nextPage
            self.newsCollectionView.reloadData()
            OperationQueue.main.addOperation() {
                self.newsActivityIndicatorView.stopAnimating()
            }
        }
            GetDataForSaleCV.getData(saleUrl) {(games, nextPage) in
            self.gameArray = games
            self.nextPageUrl = nextPage
            self.saleCollectionView.reloadData()
                OperationQueue.main.addOperation() {
                    self.saleActivityIndicatorView.stopAnimating()
                }
        }
        GetDataForRentCV.getData(rentUrl) {(games, nextPage) in
            self.gameArray1 = games
            self.nextPageUrl = nextPage
            self.rentCollectionView.reloadData()
            OperationQueue.main.addOperation() {
                self.rentActivityIndicatorView.stopAnimating()
            }
        }
      
        saleCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
       // saleCollectionView.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
        rentCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//        print("viewDidLoad")
        newsCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        //navigationItem.titleView = UIImageView(image: UIImage(named:"logo"))
        //navigationItem.titleView?.contentMode = .scaleAspectFit
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if Reachability.Connection() == true {
            print( "Internet Connected")
        } else {
            showToast(message: "خطا در اتصال !")
            print("خطا در اتصال به اینترنت !")
        }
    }
    // MARK:- FSPagerViewDataSource
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return sliderArray.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        print(sliderArray[index].photoUrl[0])
        makeCircular(cell.imageView!)
        cell.imageView?.image = UIImage(data: try! Data(contentsOf: URL(string: sliderArray[index].photoUrl[0])!))
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    //Page view delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        self.sliderController.currentPage = index
        //        MOVE TO ANOTHER VIEW WHEN ITEM IN SLIDER CLICKED
//        let destination = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "sliderContentDetails") as! SliderContentViewController
//        navigationController?.pushViewController(destination, animated: true)
    }
    //  CHANGE PAGE CONTROLLER CURRENT STATE
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.sliderController.currentPage != pagerView.currentIndex else {
            return
        }
        self.sliderController.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.saleCollectionView{
            return gameArray.count
        }
       else if collectionView == self.rentCollectionView{
            return gameArray1.count
        }else if collectionView == self.newsCollectionView{
            return postArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var temp:UICollectionViewCell!
        print(collectionView.tag)
        if collectionView == newsCollectionView{
            let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsCollectionViewCell
            makeCircular(newsCell.newsImage)
            newsCell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            print(postArray[indexPath.row].photoUrl[0])
            newsCell.newsImage.image = UIImage(data: try! Data(contentsOf: URL(string: postArray[indexPath.row].photoUrl[0])!))
            newsCell.newTitle.text = postArray[indexPath.row].gamePostTitle
           temp = newsCell
    }else if collectionView == rentCollectionView{
            let rentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "rentCell", for: indexPath) as! RentCollectionViewCell
            makeCircular(rentCell.gameImage)
            rentCell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            rentCell.gameImage.image = UIImage(data: try! Data(contentsOf: URL(string: gameArray1[indexPath.row].photoUrl[0])!))
            rentCell.gameTitle.text = gameArray1[indexPath.row].name
            rentCell.gameRentPrice.text = " \((gameArray1[indexPath.row].price)!) "
            temp = rentCell
    }
        else if collectionView == saleCollectionView{
            let saleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "saleCell", for: indexPath) as! SaleCollectionViewCell
            makeCircular(saleCell.gameImage)
            saleCell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            saleCell.gameImage.image = UIImage(data: try! Data(contentsOf: URL(string: gameArray[indexPath.row].photoUrl[0])!))
            saleCell.gameTitle.text = gameArray[indexPath.row].name
                print((gameArray[indexPath.row].price)!)
            saleCell.gameprice.text = " \((gameArray[indexPath.row].price)!)  تومان  "
                temp = saleCell
        }
    
        return temp
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == saleCollectionView{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destination = storyboard.instantiateViewController(withIdentifier: "gameDetails") as? GameDetails
            destination?.game = gameArray[indexPath.row]
            destination?.isForRent = false
            navigationController?.pushViewController(destination!, animated: true)
        }else if collectionView == rentCollectionView {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destination = storyboard.instantiateViewController(withIdentifier: "gameDetails") as? GameDetails
            destination?.game = gameArray1[indexPath.row]
            destination?.isForRent = true
            navigationController?.pushViewController(destination!, animated: true)
        }
    }
    
    // Helper Methods
    internal func makeCircular(_ imageFram:UIImageView){
        // imageFram.layer.borderWidth = 1
        imageFram.layer.masksToBounds = true
        //imageFram.layer.borderColor = UIColor(red: 255/255, green: 209/255, blue: 25/255, alpha:1).cgColor
        imageFram.layer.cornerRadius = imageFram.frame.height/10
        imageFram.clipsToBounds = true
    }
    internal func setFont(_ view:UIView){
        let views:[UIView] = view.subviews
        print(views)
        for view in views {
            if let label = view as? UILabel{
                print("Set label Font Here!")
                label.font = UIFont(name:"IRAN_Sans", size: label.font.pointSize)
            }
//            else if let button = view as? UIButton{
//
//                print("Set Button Font Here!")
//                button.titleLabel?.font = UIFont(name:"IRAN_Sans", size: 13)
//            }
        }
    }
    
}
extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-350, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        sleep(1)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.font = UIFont(name: "Montserrat-Light", size: toastLabel.font.pointSize + 1.0)
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }



