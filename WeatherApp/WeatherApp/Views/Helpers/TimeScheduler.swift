//
//  TimeScheduler.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/19/22.
//

import Foundation

class TimeScheduler<Model>: ObservableObject {
    
    @Published var now: Double
    
    @Published var data: Model? = nil
    
    @Published var shouldRefresh: Bool = true
    
    private var refresh: (Model?) -> Void
    
    var timer: Timer?
    
    var timer2: Timer?
    
    init(_ data: Model, refresh: @escaping (Model?) -> Void) {
        self.now = Date().timeIntervalSince1970
        self.refresh = refresh
        
        self.data = data
        
        refresh(self.data)
        
        // Hacky
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            if (self.shouldRefresh) {
                refresh(self.data)
                self.shouldRefresh = false
            }
            self.now = Date().timeIntervalSince1970
        })
        
        timer2 = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { _ in
            self.shouldRefresh = true
        })
    }
    deinit {
        timer?.invalidate()
        timer2?.invalidate()
    }
    
    func forceRefresh() {
        self.refresh(self.data)
    }
}
