//
//  Config.swift
//  PullToRefereach
//
//  Created by Nigel.He on 16/11/11.
//  Copyright © 2016年 User. All rights reserved.
//

import Foundation
func printLog<T>(message: T,file: String = #file,method: String = #function,line: Int = #line){
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
