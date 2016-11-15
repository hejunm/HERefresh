//
//  UIScrollView+HERefresh.swift
//
//  Created by Nigel.He on 16/11/9.
//  Copyright © 2016年 User. All rights reserved.
//

import UIKit

private var refreshHeaderKey: UInt8 = 0
private var refreshFooterKey: UInt8 = 0


extension UIScrollView{
    var refreshHeader:HERefreshHeader?{
        get{
            return objc_getAssociatedObject(self, &refreshHeaderKey) as? HERefreshHeader
        }
        set{
            objc_setAssociatedObject(self, &refreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var refreshFooter:HERefreshFooter?{
        get{
            return objc_getAssociatedObject(self, &refreshFooterKey) as? HERefreshFooter
        }
        set{
            objc_setAssociatedObject(self, &refreshFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addRefreshHeader(_ header:HERefreshHeader,action:@escaping (()->())){
        removeRefreshHeader()
        refreshHeader = header
        header.scrollViewDefauleInset = self.contentInset
        header.scrollView = self
        header.state = .initial
        header.action = action
    }
    
    func addRefreshFooter(_ footer:HERefreshFooter,action:@escaping (()->())){
        removeRefreshFooter()
        refreshFooter = footer
        footer.scrollViewDefauleInset = self.contentInset
       
        footer.scrollView = self
        footer.state = .noMoreData
        footer.action = action
    }
    
    
    func startRefreshHeader(){
        refreshHeader?.state = .loading
    }
    func startRefreshFooter(){
        refreshFooter?.state = .loading
    }
    
    func endRefreshHeader(){
        refreshHeader?.state = .finished
    }
    func endRefreshFooter(){
        refreshFooter?.state = .finished
    }
    
    func removeRefreshHeader(){
        refreshHeader?.refreshView.removeFromSuperview()
        refreshHeader = nil
    }
    func removeRefreshFooter(){
        refreshFooter?.refreshView.removeFromSuperview()
        refreshFooter = nil
    }
    
    ///可以/不可以 加载更多的数据, 只对refreshFooter有效
    func canLoadMoreData(_ flag:Bool){
        if flag{
           refreshFooter?.state = .initial
        }else{
            refreshFooter?.state = .noMoreData
        }
    }
}
