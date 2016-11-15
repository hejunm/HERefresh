//
//  HERefreshDefaultFooterView.swift
//  PullToRefereach
//
//  Created by 贺俊孟 on 16/11/12.
//  Copyright © 2016年 User. All rights reserved.
//

import UIKit

class HERefreshDefaultFooterView: HERefreshView {
    
    lazy var label:UILabel={
        var label =  UILabel()
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        
        self.addSubview(label)
        return label
    }()
    
    lazy var indicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor.lightGray
        indicator.hidesWhenStopped = true
        self.addSubview(indicator)
        return indicator
    }()
    
    override func layoutSubviews() {
        label.frame = self.bounds
        indicator.bounds.size = CGSize(width: 30, height: 30)
        indicator.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        super.layoutSubviews()
    }
    
    
    /// you must override it. change ui or do some animation  rely on state
    override func refresh(_ refresh:HERefresh,stateChangedTo state:HERefreshState){
        switch state {
        case .initial:
            label.text = "上拉加载更多"
            label.isHidden = false
            indicator.stopAnimating()
        case .loading:
            label.isHidden = true
            indicator.startAnimating()
        case .pulling(let progress):
            if progress==1{
                label.text = "松手加载更多"
            }else{
                label.text = "上拉加载更多"
            }
        case .finished:
            refresh.state = .initial
        case .noMoreData:
            label.text = "--End--"
            label.isHidden = false
            indicator.stopAnimating()
        }
    }
}
