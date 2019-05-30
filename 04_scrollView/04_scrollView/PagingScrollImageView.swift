//
//  PagingScrollImageView.swift
//  04_scrollView
//
//  Created by sy on 2019/5/28.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

//
// MARK - public interface
//
class PagingScrollImageView: UIScrollView {
    private(set) var padding: CGFloat = 0
    private var imagePath: [String?] = []
    private var reusedablePage: Set<ScrollImageView> = []
    private var displayingPage: Set<ScrollImageView> = []
    private var viewingIndexBeforeFrameChange = -1
    private var isDeviceRotating = false
    init(frame: CGRect, padding: CGFloat) {
        super.init(frame: frame)
        self.padding = padding
        configFrame(for: frame)
        self.bounds.size = self.frame.size
        customInit()
        print("visible frame: \(frame)")
        print("actual frame and bounds: \(self.frame) \(self.bounds)")
        print("content offset: \(self.contentSize)")
    }
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame, padding: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        self.backgroundColor = UIColor.black
        self.contentInsetAdjustmentBehavior = .never
        self.delegate = self;
    }
    
    
    func showImages(from paths:[String?]) -> Void {
        if self.imagePath.count > 0 {
            cleanContents()
        }
        self.imagePath = paths
        configContentSize(to: self.imagePath.count)
        self.performPaging()
    }
    
    
    func setPadding(_ padding: CGFloat) -> Void {
        if !(self.padding == padding && self.subviews.count > 0) {
            let oldFrame = self.frame
            let oldBounds = self.bounds
            var newFrame = CGRect.zero
            var newBounds = CGRect.zero
            var newContentSize = CGSize.zero
            
            newFrame.origin.x = oldFrame.origin.x + self.padding - padding
            newFrame.origin.y = oldFrame.origin.y
            newFrame.size.width = oldFrame.size.width - 2*self.padding + 2*padding
            newFrame.size.height = oldFrame.size.height
            
            newBounds.origin = oldBounds.origin
            newBounds.size = newFrame.size
            self.frame = newFrame
            self.bounds = newBounds
            
            newContentSize.width = newFrame.size.width * CGFloat(self.subviews.count)
            newContentSize.height = newFrame.size.height
            self.contentSize = newContentSize
            
            for (index, view) in self.subviews.enumerated() {
                if let scrollImageView = view as? ScrollImageView {
                    var newFrame = scrollImageView.frame
                    newFrame.origin.x = self.bounds.width * CGFloat(index) + padding
                    scrollImageView.frame = newFrame
                }
            }
        }
        self.padding = padding
    }
 
    
    func cleanContents() -> Void {
        
    }
    
    
    func notifyViewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.isDeviceRotating = true
        
        let visibleRect = self.bounds
        self.viewingIndexBeforeFrameChange = max(0, Int( floor(visibleRect.minX / visibleRect.width)))
        
        // update paging view frame
        var newFrame = CGRect.zero
        newFrame.size = size
        configFrame(for: newFrame)
        
        // update paging view content size
        self.configContentSize(to: self.imagePath.count)
        
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.isDeviceRotating = false
            // update each displaying image view frame
            for page in self.displayingPage {
                var newFrame = CGRect.zero
                newFrame.origin.x = self.frame.size.width * CGFloat(page.index) + self.padding
                newFrame.size.width = self.frame.size.width - 2*self.padding
                newFrame.size.height = self.frame.size.height
                page.frame = newFrame
                page.notifyFrameWillTransition(to: newFrame.size, with: coordinator)
            }
            
            // update content offset
            self.contentOffset.x = self.frame.size.width * CGFloat(self.viewingIndexBeforeFrameChange)
        })
    }
}


//
// MARK - helper function
//
extension PagingScrollImageView {
    private func configFrame(for visibleRect: CGRect){
        var realFrame = CGRect.zero
        realFrame.origin.x = visibleRect.origin.x - self.padding
        realFrame.origin.y = visibleRect.origin.y
        realFrame.size.width = visibleRect.size.width + 2*self.padding
        realFrame.size.height = visibleRect.size.height
        self.frame = realFrame
    }
    
    private func configContentSize(to count: Int) -> Void {
        var size = CGSize.zero
        size.width = self.frame.size.width * CGFloat(count)
        size.height = self.frame.size.height
        
        self.contentSize = size
    }
    
    private func configScrollImage(for scrollImageView:ScrollImageView, at index: Int) {
        var frame = CGRect.zero
        frame.origin.x = self.frame.size.width * CGFloat(index) + self.padding
        frame.size.width = self.frame.size.width - 2*self.padding
        frame.size.height = self.frame.size.height
        
        scrollImageView.frame = frame
        scrollImageView.backgroundColor = UIColor.white
        
        if let path = imagePath[index] {
            scrollImageView.show(path: path, at: index)
        }
    }
    
    private func performPaging() {
        // find out which pages should be displayed
        let visibleRect = self.bounds
        var fstIndex = Int( floor(visibleRect.minX / visibleRect.width) )
        var lstIndex = Int( floor((visibleRect.maxX - 1) / visibleRect.width) )
        fstIndex = min(max(0, fstIndex), self.self.imagePath.count-1)
        lstIndex = max(0, min(self.imagePath.count-1, lstIndex))
        print("performPaging(), fstIndex: \(fstIndex)  lstIndex: \(lstIndex)")
        
        // recycle unvisible pages
        for page in displayingPage {
            if page.index < fstIndex || page.index > lstIndex {
                page.removeFromSuperview()
                reusedablePage.insert(page)
            }
        }
        self.displayingPage.subtract(self.reusedablePage)
        
        //add missing pages which should be displayed
        for index in fstIndex...lstIndex {
            if !pageIsDisplaying(for: index) {
                let scrollImageView = dequeueReusedablePage() ?? ScrollImageView(frame: CGRect.zero)
                configScrollImage(for: scrollImageView, at: index)
                self.addSubview(scrollImageView)
                self.displayingPage.insert(scrollImageView)
            }
        }
     }
    
    private func pageIsDisplaying(for index: Int) -> Bool {
        var isDisplaying = false
        for page in self.displayingPage {
            if page.index == index {
               isDisplaying = true
                break
            }
        }
        
        return isDisplaying
    }
    
    private func dequeueReusedablePage() -> ScrollImageView? {
        if self.reusedablePage.count > 0 {
            return self.reusedablePage.popFirst()
        }
        
        return nil
    }
    
    
}


extension PagingScrollImageView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isDeviceRotating {
            return
        }
        
        performPaging()
        print("scrollViewDidScroll()")
        print("view frame: \(self.frame),  bounds: \(self.bounds), content offset: \(self.contentOffset)")
        print("reuseable page: \(self.reusedablePage.count)")
        print("displaying page: \(self.displayingPage.count)")
    }
}
