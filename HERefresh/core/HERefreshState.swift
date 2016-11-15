//
//  HERefreshState.swift
//
//  Created by Nigel.He on 16/11/9.
//  Copyright © 2016年 User. All rights reserved.
//

import Foundation

public enum HERefreshState: Equatable, CustomStringConvertible {
    
    case initial
    case pulling(progress: Float)
    case loading
    case finished
    case noMoreData
    
    public var description: String {
        switch self {
        case .initial: return "Inital"
        case .pulling(let progress): return "pulling:\(progress)"
        case .loading: return "Loading"
        case .finished: return "Finished"
        case .noMoreData: return "noMoreData"
        }
    }
    
    
}

public func ==(a: HERefreshState, b: HERefreshState) -> Bool {
    switch (a, b) {
    case (.initial, .initial): return true
    case (.loading, .loading): return true
    case (.finished, .finished): return true
    case (.pulling, .pulling): return true
    case (.noMoreData, .noMoreData): return true
    default: return false
    }
}
