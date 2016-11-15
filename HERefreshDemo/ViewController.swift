//
//  ViewController.swift
//  HERefreshDemo
//
//  Created by Nigel.He on 16/11/15.
//  Copyright © 2016年 User. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var data:Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource  = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        
        let pullToMakeSoupView = Bundle(for: type(of: self)).loadNibNamed("PullToMakeSoupHeaderView", owner: nil, options: nil)?.first  as! PullToMakeSoupHeaderView
        pullToMakeSoupView.bounds.size = CGSize(width: UIScreen.main.bounds.width, height: pullToMakeSoupView.bounds.height)
        
        let pullToMakeSoupHeader = HERefreshHeader(withRefreshView: pullToMakeSoupView)
        
        self.tableView.addRefreshHeader(pullToMakeSoupHeader) {
            let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.data = 5
                self.tableView.reloadData()
                self.tableView.endRefreshHeader()
                self.tableView.canLoadMoreData(true)
            }
        }
        
        //
        //        self.tableView.addDefaultHeader {
        //            let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        //            DispatchQueue.main.asyncAfter(deadline: delayTime) {
        //                self.data = 5
        //                self.tableView.reloadData()
        //                self.tableView.endRefreshHeader()
        //                self.tableView.canLoadMoreData(true)
        //            }
        //        }
        
        self.tableView.addDefaultFooter {
            let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.data+=5
                self.tableView.reloadData()
                self.tableView.endRefreshFooter()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as! FoodCell
        cell.foodName.text = indexPath.row%2==0 ? "pizza" : "gamburger"
        cell.foodIcon.image = indexPath.row%2==0 ? UIImage(named:"pizza") : UIImage(named:"gamburger")
        return cell
    }
    
}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}

