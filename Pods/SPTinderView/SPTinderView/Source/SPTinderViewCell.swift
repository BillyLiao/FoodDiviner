//
//  SPTinderViewCell.swift
//  SPTinderView
//
//  Created by Suraj Pathak on 3/2/16.
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import UIKit

 /// The SPTinderViewCell defines the attributes and behavior of the cells that appear in SPTinderView objects. This class includes properties and methods for setting and managing cell content and background.

@IBDesignable
public class SPTinderViewCell: UIView, UIGestureRecognizerDelegate {
    @IBInspectable var reuseIdentifier: String?
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    var cellMovement: SPTinderViewCellMovement = .None
    var likeImage: UIButton!
    var dislikeImage: UIButton!
    var superlikeImage: UIButton!
    
    typealias cellMovementChange = (SPTinderViewCellMovement) -> ()
    var onCellDidMove: cellMovementChange?
    
    private var originalCenter = CGPoint(x: 0, y: 0)
    private var scaleToRemoveCell: CGFloat = 0.3
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
    }
    
    public required init(reuseIdentifier: String) {
        self.init()
        self.reuseIdentifier = reuseIdentifier
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayerAttributes()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayerAttributes()
    }
    
    private func setupLayerAttributes() {
        self.layer.shouldRasterize = true
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.clearColor().CGColor
        self.layer.shadowColor = UIColor.darkGrayColor().CGColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
    public func setupStatusImage() {
        let imageFrame = CGRectMake(0, 0, self.frame.width/2, 55)
        let likeColor = UIColor(red: 224.0/255.0, green: 68.0/255.0, blue: 98.0/255.0, alpha: 1)
        let dislikeColor = UIColor(red: 23.0/255.0, green: 231.0/255.0, blue: 164.0/255.0, alpha: 1)
        let superlikeColor = UIColor(red: 12.0/255.0, green: 156.0/255.0, blue: 1, alpha: 1)

        likeImage = UIButton(frame: imageFrame)
        dislikeImage = UIButton(frame: imageFrame)
        superlikeImage = UIButton(frame: imageFrame)
        
        likeImage.center.x = self.frame.width/3
        likeImage.center.y = 100
        likeImage.setTitle("Like", forState: .Normal)
        likeImage.layer.cornerRadius = 5
        likeImage.layer.borderWidth = 3
        likeImage.layer.borderColor = likeColor.CGColor
        likeImage.titleLabel?.font = UIFont.systemFontOfSize(20)
        likeImage.setTitleColor(likeColor, forState: .Normal)
        likeImage.alpha = 0
        
        dislikeImage.center.x = self.frame.width*2/3
        dislikeImage.center.y = 100
        dislikeImage.setTitle("Dislike", forState: .Normal)
        dislikeImage.layer.cornerRadius = 5
        dislikeImage.layer.borderWidth = 3
        dislikeImage.layer.borderColor = dislikeColor.CGColor
        dislikeImage.titleLabel?.font = UIFont.systemFontOfSize(20)
        dislikeImage.setTitleColor(dislikeColor, forState: .Normal)
        dislikeImage.alpha = 0
        
        superlikeImage.center.x = self.frame.width/2
        superlikeImage.center.y = self.frame.height*2/3
        superlikeImage.setTitle("Take", forState: .Normal)
        superlikeImage.layer.cornerRadius = 5
        superlikeImage.layer.borderWidth = 3
        superlikeImage.layer.borderColor = superlikeColor.CGColor
        superlikeImage.titleLabel?.font = UIFont.systemFontOfSize(20)
        superlikeImage.setTitleColor(superlikeColor, forState: .Normal)
        superlikeImage.alpha = 0
        
        self.addSubview(likeImage)
        self.addSubview(dislikeImage)
        self.addSubview(superlikeImage)
        
        UIView.animateWithDuration(0) { 
            self.dislikeImage.transform = CGAffineTransformMakeRotation(0.25)
            self.likeImage.transform = CGAffineTransformMakeRotation(-0.25)
            self.superlikeImage.transform = CGAffineTransformMakeRotation(0.1)
        }
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let _ = touches.first else { return }
        originalCenter = self.center
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let prevLoc = touch.previousLocationInView(self)
            let thisLoc = touch.locationInView(self)
            
            let deltaX = thisLoc.x - prevLoc.x
            let deltaY = thisLoc.y - prevLoc.y
            // There's also a little bit of transformation. When the cell is being dragged, it should feel the angle of drag as well
            let xDrift = self.center.x + deltaX - originalCenter.x
            let yDrift = self.center.y + deltaY - originalCenter.y
            
            let likeAlpha = xDrift / (self.frame.width * scaleToRemoveCell)
            let dislikeAlpha = -xDrift / (self.frame.width * scaleToRemoveCell)
            let superlikeAlpha = -yDrift / (self.frame.height * scaleToRemoveCell)
            
            let rotationAngle = xDrift * -0.05 * CGFloat(M_PI / 90)
            // Note: Must set the animation option to `AllowUserInteraction` to prevent the main thread being blocked while animation is ongoin
            let rotatedTransfer = CGAffineTransformMakeRotation(rotationAngle)
            UIView.animateWithDuration(0.0, delay: 0.0, options: [.AllowUserInteraction], animations: {
                
                if likeAlpha > dislikeAlpha && likeAlpha > superlikeAlpha {
                    self.setImaegAlpha(likeAlpha: likeAlpha, dislikeAlpha: 0, superlikeAlpha: 0)
                }else if dislikeAlpha > likeAlpha && dislikeAlpha > superlikeAlpha {
                    self.setImaegAlpha(likeAlpha: 0, dislikeAlpha: dislikeAlpha, superlikeAlpha: 0)
                }else {
                    self.setImaegAlpha(likeAlpha: 0, dislikeAlpha: 0, superlikeAlpha: superlikeAlpha)
                }
                
                self.transform = rotatedTransfer
                self.center.x += deltaX
                self.center.y += deltaY
                }, completion: { finished in
            })
        }
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let xDrift = self.center.x - originalCenter.x
        let yDrift = self.center.y - originalCenter.y
        self.setImaegAlpha(likeAlpha: 0, dislikeAlpha: 0, superlikeAlpha: 0)
        self.setCellMovementDirectionFromDrift(xDrift, yDrift: yDrift)
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        UIView.animateWithDuration(0.2, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [.AllowUserInteraction], animations: {
            self.center = self.originalCenter
            self.transform = CGAffineTransformIdentity
            }, completion: { finished in
        })
    }
    
    public override func touchesEstimatedPropertiesUpdated(touches: Set<NSObject>) {
       //
    }
    
    public func setCellMovementDirection(movement: SPTinderViewCellMovement){
        if movement != .None {
            self.cellMovement = movement
            if let cellMoveBlock = onCellDidMove {
                cellMoveBlock(movement)
            }
        } else {
            UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.AllowUserInteraction], animations: {
                self.center = self.originalCenter
                self.transform = CGAffineTransformIdentity
                }, completion: nil)
        }
    }

    
    public func setCellMovementDirectionFromDrift(xDrift: CGFloat, yDrift: CGFloat){
        var movement: SPTinderViewCellMovement = .None
        if(xDrift > self.frame.width * scaleToRemoveCell) { movement = .Right }
        else if(-xDrift > self.frame.width * scaleToRemoveCell) { movement = .Left }
        else if(-yDrift > self.frame.height * scaleToRemoveCell) { movement = .Top }
        else if(yDrift > self.frame.height * scaleToRemoveCell) { movement = .None }
        else { movement = .None }
        if movement != .None  {
            self.cellMovement = movement
            if let cellMoveBlock = onCellDidMove {
                cellMoveBlock(movement)
            }
        } else {
            UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.AllowUserInteraction], animations: {
                self.center = self.originalCenter
                self.transform = CGAffineTransformIdentity
                }, completion: nil)
        }
    }
    
    private func setImaegAlpha(likeAlpha likeAlpha: CGFloat, dislikeAlpha: CGFloat, superlikeAlpha: CGFloat){
        likeImage.alpha = likeAlpha
        dislikeImage.alpha = dislikeAlpha
        superlikeImage.alpha = superlikeAlpha
    }
}

/**
 `SPTinderViewCellMovement` defines the four types of movement when the cell is dragged around.
 - None:   When the cell has not moved or not been moved enough to be considered one of the other 4 movements
 - Top:    When the cell has moved towards top
 - Left:   When the cell has moved towards left
 - Bottom: When the cell has moved towards bottom
 - Right:  When the cell has moved towards right
 */

public enum SPTinderViewCellMovement: Int {
    case None
    case Top
    case Left
    case Bottom
    case Right
}

