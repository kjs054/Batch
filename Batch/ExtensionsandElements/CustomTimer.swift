//
//  CustomTimer.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/3/22.
//

import Foundation
import UIKit

class CustomTimer {

    var timer = Timer()
    var handler: (TimeInterval) -> ()
    var elapsedTime = TimeInterval(1.0)
    var currentBackgroundDate: Date?
    var targetController = HomeController.self
    var completionCallback: (() -> Void)!
    
    init(handler : @escaping (TimeInterval) -> ()) {
        self.handler = handler;
        NotificationCenter.default.addObserver(self, selector: #selector(pauseApp), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startApp), name: UIApplication.willEnterForegroundNotification, object: nil)
        start()
    }
    
    @objc func pauseApp() {
        self.stop() //invalidate timer
        self.currentBackgroundDate = Date()
    }
    
    @objc func startApp(){
        guard let previousDate = currentBackgroundDate else { return }
        let difference = Date().timeIntervalSince(previousDate)
        self.handler(difference)
        self.start()
    }

    func start(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.updateTime()
        }
    }
    
    func stop(){
        timer.invalidate();
    }

    @objc func updateTime() {
        self.elapsedTime = TimeInterval(1.0)
        self.handler(elapsedTime);
    }
    
    deinit{
        self.timer.invalidate();
    }
}
