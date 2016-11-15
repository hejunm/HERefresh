//
//  HERefreshFooter.swift
//  PullToRefereach
//
//  Created by 贺俊孟 on 16/11/12.
//  Copyright © 2016年 User. All rights reserved.
//

import UIKit

class HERefreshFooter: HERefresh {
    
    ///refreshView的maxY显示出来后， 继续向上提，提多少时开始松开进入loading状态. default is refreshView's height
    var afterDistance:CGFloat = 0
    
    ///自动加载更多。当scrollView快滑动到底部时就自动调用action块
    var canAutoLoadMore = true
    
    ///refreshView的maxY还没有显示出来，还差多少时就进入loading状态（提前加载）default is 0
    var befordDistance:CGFloat = 0
    
    ///没有更多数据时，是否隐藏refreshView
    var isHiddenWhenNoMoreData = false{
        didSet{
            if isHiddenWhenNoMoreData == true && state == .noMoreData{
                state = .noMoreData
            }
        }
    }
    
    init(withRefreshView refreshView: HERefreshView) {
        super.init(withRefreshView: refreshView, position: .bottom)
        afterDistance = refreshView.bounds.height
    }

    override func contentSizeChanged() {
        setRefreshViewFrame()
        if state == .noMoreData && isHiddenWhenNoMoreData == true{
            return
        }
        showRefreshView(animated: false)
    }
    
    override func contentOffsetChanged() {
        if canAutoLoadMore{
            autoLoadMore()
        }else{
            gestureLoadMore()
        }
    }
    
    fileprivate func autoLoadMore(){
        let offsetY = (scrollView.contentOffset.y+scrollView.bounds.height)-refreshView.frame.maxY
        if offsetY > -befordDistance{
            state = .loading
        }
    }
    
    //手势上拉加载更多
    fileprivate func gestureLoadMore(){
        let offsetY = (scrollView.contentOffset.y+scrollView.bounds.height)-refreshView.frame.maxY
        printLog(message: "\(offsetY)       \(scrollView.contentOffset.y)")
        if offsetY < 0 {
            return
        }
        var progress = Float(offsetY)/Float(afterDistance)*0.85
        switch offsetY {
        case 0: state = .initial
        case 1...afterDistance:
            if(scrollView.isDragging){
                state = .pulling(progress: progress)
            }else{
                state = .initial
            }
        case let (tempOffsetY) where tempOffsetY>afterDistance:
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
        showRefreshView(animated: false)
        refreshView.isHidden = false
    }
    
    override func setStateLoading(){
        action()
    }
    
    override func setStateNoMoreData(){
        if isHiddenWhenNoMoreData{
            hideRefreshView(animated: true)
            refreshView.isHidden = true
        }
    }
}
