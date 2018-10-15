//
//  SearchViewController.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/1/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var  searchFooter: SearchFooter!
    var message:String = ""
    var index:IndexPath!
    var searchType:String = "shop"
    var activityIndicatorView:UIActivityIndicatorView!
    var isEnoughCharacter = false
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    var serachResult = [Game]()
    var searchedText:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.tableFooterView = searchFooter
        
        
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
extension SearchViewController:UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    
    //MARK: Search bar delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if !isEnoughCharacter {
            
            let alert = UIAlertController(title: "توجه !!!", message: "برای جستوجو لطفا بیشتر از دو حرف وارد کنید", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "اوکی", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        search()
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("**** Segment Did Changed and  Index is \(selectedScope)****")
        if selectedScope == 1{
             self.searchFooter.hideFooter()
            searchType = "rent"
            search()
        }else if selectedScope == 2{
             self.searchFooter.hideFooter()
            searchType = "post"
            search()
        }else if selectedScope == 0{
             self.searchFooter.hideFooter()
            searchType = "shop"
            search()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchFooter.hideFooter()
        print("this is content of search bar --->  \(searchText)")
        self.searchedText = searchText
        if searchText == ""{
            serachResult.removeAll()
            searchTableView.reloadData()
        }
        if searchText.count <= 2 {
            isEnoughCharacter = false
        }else{
            isEnoughCharacter = true
        }
    }
    
    
    
    //MARK: tableView DataSource & Delegate
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serachResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp:UITableViewCell!
        if serachResult[indexPath.row].gamePostTitle == ""{
            let searchCell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchCell
            makeCircular((searchCell?.gameImage)!)
            makeCircular((searchCell?.view)!)
            makeCircular((searchCell?.gamePrice)!)
            searchCell?.selectionStyle = .none
            searchCell?.gamePrice.text = "  \((serachResult[indexPath.row].price)!)  تومان"
            searchCell?.gameName.text = serachResult[indexPath.row].name
            searchCell?.gameRegion.text = "Region :\((serachResult[indexPath.row].region)!)"
            if serachResult[indexPath.row].console_type == "ps1" || serachResult[indexPath.row].console_type == "ps4" || serachResult[indexPath.row].console_type == "ps2"{
                searchCell?.consoleTypeImage.image = UIImage(named:"ps")
            }else{
                searchCell?.consoleTypeImage.image = UIImage(named:"xbox")
            }
            searchCell?.gameImage.image = UIImage(data: try! Data(contentsOf: URL(string: serachResult[indexPath.row].photoUrl[0])!))
            temp = searchCell!
        }else {
            let postCell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostCell
            makeCircular((postCell?.view)!)
            makeCircular((postCell?.postImage)!)
            makeCircular((postCell?.postTitle)!)
            postCell?.postImage.image =  UIImage(data: try! Data(contentsOf: URL(string: serachResult[indexPath.row].photoUrl[0])!))
            postCell?.postTitle.text = serachResult[indexPath.row].gamePostTitle
            if serachResult[indexPath.row].postCreation != "<null>"{
            postCell?.postCreation.text = serachResult[indexPath.row].postCreation
            }
            temp = postCell!
        }
        return temp
    
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if serachResult[indexPath.row].gamePostTitle != ""{
            
            
            
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destination = storyboard.instantiateViewController(withIdentifier: "gameDetails") as? GameDetails
            destination?.game = serachResult[indexPath.row]
            if searchType == "shop"{
                destination?.isForRent = false
            }else if searchType == "rent"{
                destination?.isForRent = true
            }
            navigationController?.pushViewController(destination!, animated: true)
        }
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    //MARK: Helper Method
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func search(){
        
        self.searchFooter.hideFooter()
        if searchedText != ""{
            activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            searchTableView.backgroundView = activityIndicatorView
            self.activityIndicatorView.startAnimating()
            Search.serachMethod(searchedText,urlType:searchType,completion: { (games,message) in
                self.serachResult.removeAll()
                self.serachResult = games
                self.message = message
                self.searchTableView.reloadData()
                if (self.serachResult.count != 0 && self.message == "") {
                    self.searchFooter.filterShow(self.serachResult.count)
                    print(self.serachResult.count)
                    self.dispatchQueue.async {
                        OperationQueue.main.addOperation() {
                            self.activityIndicatorView.stopAnimating()
                        }
                    }
                }else{
                    self.searchFooter.filterShow(self.serachResult.count)
                    self.activityIndicatorView.stopAnimating()
                }
            })
        }
    }
    internal func makeCircular(_ view:UIView){
        // imageFram.layer.borderWidth = 1
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.height/5
        view.clipsToBounds = true
    }

}
