//
//  HERefreshView.swift
//
//  Created by Nigel.He on 16/11/9.
//  Copyright © 2016年 User. All rights reserved.
//

import UIKit

class HERefreshView: UIView,HERefreshDelegate {
    
    func refresh(_ refresh: HERefresh, stateChangedTo state: HERefreshState) {
        assert(false, "You must override \(#function)")
    }
}
