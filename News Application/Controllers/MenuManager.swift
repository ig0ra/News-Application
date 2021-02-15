//
//  MenuManager.swift
//  News Application
//
//  Created by Admin on 13.02.2021.
//

import UIKit

class MenuManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    let menuTableView = UITableView()
    let blackView = UIView()
    let arrayOfCategories = ["Technology", "Sports", "Science", "Health", "Entertainment", "Business"]
    var mainVC: ViewController? 

    
    public func openMenu(){
        if let window = UIApplication.shared.keyWindow{
            blackView.frame = window.frame
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dissmissMenu )))
            
            let height: CGFloat = 300
            let yPosition = window.frame.height - height
            menuTableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            window.addSubview(blackView)
            window.addSubview(menuTableView)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.blackView.alpha = 1
                self.menuTableView.frame.origin.y = yPosition
            })
        }
    }
    
    @objc public func dissmissMenu(){
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                self.menuTableView.frame.origin.y = window.frame.height
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as UITableViewCell
        cell.textLabel?.text = arrayOfCategories[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let vc = mainVC as ViewController?{
            vc.category = arrayOfCategories[indexPath.item].lowercased()
            vc.fetchArticles()
            dissmissMenu()
        }
    }
    
    override init() {
        super.init()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        menuTableView.isScrollEnabled = false
        
        menuTableView.register(MenuViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
    }
}


