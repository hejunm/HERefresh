//
//  HERefreshDefaultHeaderView.swift
//  PullToRefereach
//
//  Created by 贺俊孟 on 16/11/12.
//  Copyright © 2016年 User. All rights reserved.
//

import UIKit

class HERefreshDefaultHeaderView: HERefreshView {
    
    lazy var stateLabel:UILabel = {
        let label =  UILabel()
        label.textColor = UIColor.lightGray
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
    
    lazy var arrowImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "downArrow"))
        self.addSubview(imageView)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        stateLabel.frame = CGRect(x: self.bounds.midX, y: 0, width: self.bounds.width/2, height: self.bounds.height)
        
        let imageViewWidth:CGFloat = 30
        let imageViewHeight = imageViewWidth
        let imageViewX = self.bounds.midX-imageViewWidth
        let imageViewY = (self.bounds.height-imageViewHeight)/2
        arrowImageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewWidth,height: imageViewHeight)

        indicator.bounds.size = arrowImageView.bounds.size
        indicator.center = arrowImageView.center
        super.layoutSubviews()
    }
    
   
    override func refresh(_ refresh:HERefresh,stateChangedTo state:HERefreshState){
        switch state {
        case .initial:
            stateLabel.text = "下拉刷新"
            arrowImageView.isHidden = false
            indicator.stopAnimating()
            UIView.animate(withDuration: 0.2, animations: { 
                self.arrowImageView.transform = .identity
            })
        case .loading:
            stateLabel.text = "正在加载"
            arrowImageView.isHidden = true
            indicator.startAnimating()
        case .pulling(let progress):
            if progress==1{
                stateLabel.text = "松手刷新"
                UIView.animate(withDuration: 0.2, animations: {
                    self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                })
            }else{
                stateLabel.text = "下拉刷新"
                UIView.animate(withDuration: 0.2, animations: {
                    self.arrowImageView.transform = .identity
                })
            }
        case .finished:
            refresh.state = .initial
        default:
            break
      }
    }
    
}
