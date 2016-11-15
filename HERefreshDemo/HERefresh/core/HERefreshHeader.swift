//
//  HERefreshHeader.swift
//  PullToRefereach
//
//  Created by 贺俊孟 on 16/11/12.
//  Copyright © 2016年 User. All rights reserved.
//

import UIKit

class HERefreshHeader: HERefresh {
    
    init(withRefreshView refreshView: HERefreshView) {
        super.init(withRefreshView: refreshView, position: .top)
    }
    
    override func contentOffsetChanged() {
        let offsetY = -(scrollView.contentOffset.y + scrollViewDefauleInset.top) //offset<0, 这是上拉的情况
        if offsetY<0 {return}
        var progress = Float(offsetY) / Float(refreshView.bounds.height)*0.85
        guard scrollView.refreshFooter == nil || scrollView.refreshFooter!.state == .initial || scrollView.refreshFooter!.state == .noMoreData else { //当下拉刷新时，如果上拉的不是initial状态，就不去执行下拉刷新了。反之亦然
            return
        }
        switch offsetY {
        case 0: state = .initial
        case 1..<refreshView.bounds.height:
            if(scrollView.isDragging){
                state = .pulling(progress: progress)
            }else{
                state = .initial
            }
        case let (tempOffsetY) where tempOffsetY >= refreshView.bounds.height:
            if(scrollView.isDragging){
                progress = progress>=1 ? 1:progress
                state = .pulling(progress: progress)
            }else{
                state = .loading
            }
        default: break
        }
    }
    
    override func setStateInitial(){
        setRefreshViewFrame()
        hideRefreshView(animated: true)
    }
    
    override func setStateLoading(){
        showRefreshView(animated: true)
        action()
    }
}


