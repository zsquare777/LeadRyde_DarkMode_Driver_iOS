//
//  UIView+.swift
//  uipip
//
//  Created by Akihiro Urushihara on 2021/11/27.
//  @see https://iganin.hatenablog.com/entry/2020/05/11/070950
//

import UIKit

extension UIView {

    var uiImage: UIImage {
        let imageRenderer = UIGraphicsImageRenderer.init(size: bounds.size)
        return imageRenderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}


class VideoProvider: NSObject {

    private var timer: Timer!
    var bufferDisplayLayer = AVSampleBufferDisplayLayer()
   
  
    // 現在時刻を表示
    func nextBuffer() -> UIImage {
        
        return (Application.window?.rootViewController?.view ?? UIView()).uiImage
    }

    func start() {
        let timerBlock: ((Timer) -> Void) = { [weak self] timer in
            guard let self = self else { return }
            if (self.bufferDisplayLayer.status == .failed) {
                self.bufferDisplayLayer.flush()
            }

            guard let buffer = self.nextBuffer().cmSampleBuffer else { return }
            self.bufferDisplayLayer.enqueue(buffer)
        }

        timer = Timer(timeInterval: 1.0, repeats: true, block: timerBlock)
        RunLoop.main.add(timer, forMode: .default)
    }

    func stop() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }

    func isRunning() -> Bool {
        return timer != nil
    }
}

