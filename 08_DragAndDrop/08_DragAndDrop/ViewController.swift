//
//  ViewController.swift
//  DragAndDrop
//
//  Created by sy on 2019/8/8.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var upperImageView: UIImageView!
    @IBOutlet weak var chartView: ChartView!
    @IBOutlet weak var lowerImageView: UIImageView!
    
    var dragView: UIView? = nil
    var dropView: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.upperImageView.layer.borderWidth = 1
        self.upperImageView.layer.borderColor = UIColor.black.cgColor
        self.upperImageView.layer.cornerRadius = 4
        self.upperImageView.layer.masksToBounds = true
        self.upperImageView.isUserInteractionEnabled = true
        
        self.lowerImageView.layer.borderWidth = 1
        self.lowerImageView.layer.borderColor = UIColor.black.cgColor
        self.lowerImageView.layer.cornerRadius = 4
        self.lowerImageView.layer.masksToBounds = true
        self.lowerImageView.isUserInteractionEnabled = true
        
        self.view.addInteraction(UIDragInteraction(delegate: self))
        self.view.addInteraction(UIDropInteraction(delegate: self))
        

    }
    
    func dragViewForSession(_ session: UIDragSession) -> UIView? {
        let dragPoint = session.location(in: self.view)
        var dragView: UIView? = nil
        if self.upperImageView.frame.contains(dragPoint) {
            dragView = self.upperImageView
        } else if self.lowerImageView.frame.contains(dragPoint) {
            dragView = self.lowerImageView
        }
        
        return dragView
    }
    
    func dropViewForSession(_ session: UIDropSession) -> UIView? {
        let dropPoint = session.location(in: self.view)
        var dropView: UIView? = nil
        if self.upperImageView.frame.contains(dropPoint) {
            dropView = self.upperImageView
        } else if self.lowerImageView.frame.contains(dropPoint) {
            dropView = self.lowerImageView
        }
        
        return dropView
    }
}



extension ViewController: UIDragInteractionDelegate {
    // restricted session can only drag in-app
    func dragInteraction(_ interaction: UIDragInteraction, sessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool {
        return true
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if let dragView = dragViewForSession(session) {
            if let imageView = dragView as? UIImageView, let image = imageView.image {
                let imageProvider = NSItemProvider(object: image)
                let dragItem = UIDragItem(itemProvider: imageProvider)
                
                // drag preview view (diffrent form lifting)
                dragItem.previewProvider = {
                    return UIDragPreview(view: imageView);
                };
                //dragItem.localObject = dragView
                self.dragView = dragView
                return [dragItem]
            }
        }
        
        return []
    }
    
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForAddingTo session: UIDragSession, withTouchAt point: CGPoint) -> [UIDragItem] {
        return []
    }
    
    
    //
    // user custom lifting animation
    //
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        if let dragView = self.dragView {
            return UITargetedDragPreview(view: dragView)
        }
        
        return nil
    }
    
    
    //
    // user additional animation along with lifting animation
    //
    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        if let dragView = self.dragView {
            animator.addAnimations {
                dragView.alpha = 0.5
            }
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, item: UIDragItem, willAnimateCancelWith animator: UIDragAnimating) {
        if let dragView = self.dragView {
            animator.addAnimations {
                dragView.alpha = 1
            }
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, didEndWith operation: UIDropOperation) {
        if let dragView = self.dragView {
                dragView.alpha = 1
        }
    }
    
}




extension ViewController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        if (session.canLoadObjects(ofClass: UIImage.self))
        {
            let dropView = dropViewForSession(session)

            if let _ = session.localDragSession , let dragView = self.dragView {
                if dropView != nil && dragView == dropView {
                    return false
                }
            }

            self.dropView = dropView
            let viewDesc = dropView != nil ? dropView!.description : "nil"
            print("dropView 111 : \(viewDesc)")

            return dropView != nil

        }
        
        return false
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropView = dropViewForSession(session)
        self.dropView = dropView
        
        let viewDesc = dropView != nil ? dropView!.description : "nil"
        print("dropView 222 : \(viewDesc)")
        
        if let _ = session.localDragSession , let dragView =  self.dragView {
            if dropView != nil && dragView == dropView {
                return UIDropProposal(operation: .forbidden)
            }
        }
        
        if dropView != nil {
            return UIDropProposal(operation: .copy)
        }
        
        return UIDropProposal(operation: .cancel)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        if let dragItem = session.items.first {
            dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let e = error {
                    print("Load drag Item data filed, error: \(e)")
                    return
                }
                
                if let data = object {
                    if let dragImageItem = data as? UIImage {
                        DispatchQueue.main.async(execute: {
                            let dropTarget = self.dropView as? UIImageView
                            dropTarget?.image = dragImageItem
                        })
                    }
                }
            }
        }
    }
    
    //
    // user custom drop animation
    //
    func dropInteraction(_ interaction: UIDropInteraction, previewForDropping item: UIDragItem, withDefault defaultPreview: UITargetedDragPreview) -> UITargetedDragPreview? {
        if let dropView = self.dropView {
            let dragPreviewTarget = UIDragPreviewTarget(container: self.view, center: dropView.center, transform: CGAffineTransform(scaleX: 0, y: 0))
            return defaultPreview.retargetedPreview(with: dragPreviewTarget)
        }
        
        return defaultPreview
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, item: UIDragItem, willAnimateDropWith animator: UIDragAnimating) {
        if let dropView = self.dropView {
            animator.addAnimations {
                dropView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, concludeDrop session: UIDropSession) {
        if let dropView = self.dropView {
            UIView.animate(withDuration: 0.25) {
                dropView.transform = CGAffineTransform.identity
            }
        }
    }
}

