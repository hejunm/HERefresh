//
//  HERefreshDefaultHeader.swift
//  PullToRefereach
//
//  Created by 贺俊孟 on 16/11/12.
//  Copyright © 2016年 User. All rights reserved.
//

import UIKit

class HERefreshDefaultHeader: HERefreshHeader {
    
}

extension UIScrollView{
    func addDefaultHeader(action:@escaping (()->())){
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        let defaultHeaderView = HERefreshDefaultHeaderView(frame: frame)
        let defaultHeader = HERefreshDefaultHeader(withRefreshView: defaultHeaderView)
        self.addRefreshHeader(defaultHeader, action: action)
    }
}
