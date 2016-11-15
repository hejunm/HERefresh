//
//  HERefresh.swift
//
//  Created by Nigel.He on 16/11/9.
//  Copyright © 2016年 User. All rights reserved.
//

import UIKit

enum Position{
    case top, bottom
}

protocol HERefreshDelegate:NSObjectProtocol {
    func refresh(_ refresh:HERefresh,stateChangedTo state:HERefreshState)
}

class HERefresh: NSObject {
    fileprivate(set) var position:Position = .top
    fileprivate var isObserving = false
    
    weak var delegate:HERefreshDelegate?
    var refreshView:HERefreshView
    var scrollViewDefauleInset:UIEdgeInsets = .zero
    
    var durationForHideRefreshView:TimeInterval = 0.3 //隐藏刷新组件的动画时间
    var action:(()->())!
    
    //MARK: init
    init(withRefreshView refreshView:HERefreshView ,position:Position) {
        self.refreshView = refreshView
        self.delegate = refreshView
        self.position = position
    }
    
    deinit {
        removeScrollViewObserving()
    }
    
    var state:HERefreshState = .initial{ //下拉刷新的状态信息
        didSet{
            self.delegate?.refresh(self, stateChangedTo: state)
            switch state {
            case .initial:
                setStateInitial()
            case .loading:
                setStateLoading()
            case .noMoreData:
                setStateNoMoreData()
            case .pulling(let progress):
                setStatePulling(progress: progress)
            case .finished:
                setStateFinished()
                break
            }
        }
    }
   
    weak var scrollView:UIScrollView!{
        willSet{
            removeScrollViewObserving()
        }
        didSet{
            addScrollViewObserving()
            scrollView.insertSubview(refreshView, at: 0)
        }
    }
    
    // MARK: KVO
    fileprivate var KVOContext = "HERefreshKVOContext"
    fileprivate let contentOffsetKeyPath = "contentOffset"
    fileprivate let contentInsetKeyPath = "contentInset"
    fileprivate let contentSizeKeyPath = "contentSize"
    
    fileprivate func addScrollViewObserving(){
        guard let scrollView = scrollView,!isObserving else {
            return
        }
        scrollView.addObserver(self, forKeyPath: contentOffsetKeyPath, options: .initial, context: &KVOContext)
        scrollView.addObserver(self, forKeyPath: contentSizeKeyPath, options: .initial, context: &KVOContext)
        scrollView.addObserver(self, forKeyPath: contentInsetKeyPath, options: .new, context: &KVOContext)
        isObserving = true
    }
    
    fileprivate func removeScrollViewObserving(){
        guard let scrollView = scrollView,isObserving else {
            return
        }
        scrollView.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &KVOContext)
        scrollView.removeObserver(self, forKeyPath: contentSizeKeyPath, context: &KVOContext)
        scrollView.removeObserver(self, forKeyPath: contentInsetKeyPath, context: &KVOContext)
        isObserving = false
    }
    
    fileprivate var proContentSize:CGSize? //保存上一个scrollView.contentSize
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(context == &KVOContext && keyPath == contentOffsetKeyPath && object as? UIScrollView == scrollView){
            switch state {
            case .loading:
                return
            case .finished:
                return
            case .noMoreData:
                return
            default: //initial or pulling
                if state == .initial && !scrollView.isDragging{
                    return
                }
                contentOffsetChanged()
            }
        }else if(context == &KVOContext && keyPath == contentInsetKeyPath && object as? UIScrollView == scrollView){//这种情况有待解决
            if state == .initial{
                scrollViewDefauleInset = scrollView.contentInset
            }
        }else if(context == &KVOContext && keyPath == contentSizeKeyPath && object as? UIScrollView == scrollView){
            guard proContentSize != scrollView.contentSize else { return } //当改变contentOffset或者contentInset时，也会调用这里的代码。比较郁闷，只能加这个了
            proContentSize = scrollView.contentSize
            contentSizeChanged()
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    ///拉的偏移量
    func contentOffsetChanged(){
        assert(false, "You must override \(#function)")
    }
    func contentSizeChanged(){}
    
    func setRefreshViewFrame(){
        var y:CGFloat=0.0
        switch position {
        case .top:
            y = -refreshView.bounds.height
        case .bottom:
            y = scrollView.contentSize.height
        }
        refreshView.frame.origin = CGPoint(x: 0, y: y)
    }
    
    //设置contentInset显示出RefreshView
    func showRefreshView(animated:Bool){
        func show(){
            switch self.position {
            case .top:
                let contentInsetTop = self.refreshView.bounds.height + scrollViewDefauleInset.top
                self.scrollView.contentInset.top = contentInsetTop
                self.scrollView.contentOffset = CGPoint(x: 0, y: -contentInsetTop)
            case .bottom:
                self.scrollView.contentInset.bottom = self.refreshView.bounds.height
            }
        }
        
        if animated{
            UIView.animate(withDuration: 0.1, animations: {
                show()
            })
        }else{
            show()
        }
    }
    
    //设置contentInset隐藏RefreshView
    func hideRefreshView(animated:Bool){
        func hide(){
            switch self.position {
            case .top:
                self.scrollView.contentInset.top = self.scrollViewDefauleInset.top
            case .bottom:
                self.scrollView.contentInset.bottom = 0
            }
        }

        //guard self.scrollViewDefauleInset != scrollView.contentInset else {return}
        if animated{
            UIView.animate(withDuration: durationForHideRefreshView, animations: {
                hide()
            })
        }else{
            hide()
        }
    }
    
    func setStateInitial(){}
    
    func setStateLoading(){}
    
    func setStateNoMoreData(){}
    
    func setStatePulling(progress:Float){}
    
    func setStateFinished(){}
}


