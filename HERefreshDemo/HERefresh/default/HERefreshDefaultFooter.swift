//
//  HERefreshDefaultFooter.swift
//  PullToRefereach
//
//  Created by 贺俊孟 on 16/11/12.
//  Copyright © 2016年 User. All rights reserved.
//

import UIKit

class HERefreshDefaultFooter: HERefreshFooter {

}

extension UIScrollView{
    func addDefaultFooter(action:@escaping (()->())){
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        let defaultFooterView = HERefreshDefaultFooterView(frame: frame)
        let defaultFooter = HERefreshDefaultFooter(withRefreshView: defaultFooterView)
        defaultFooter.isHiddenWhenNoMoreData = true
        self.addRefreshFooter(defaultFooter, action: action)
    }
}
