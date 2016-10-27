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
    private let like = "like"
    private let nope = "nope"
    private let take = "take"
    
    @IBInspectable var reuseIdentifier: String?
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    var cellMovement: SPTinderViewCellMovement = .None
    
    typealias cellMovementChange = (SPTinderViewCellMovement) -> ()
    var onCellDidMove: cellMovementChange?
    
    var likeSticker: UIImageView!
    var nopeSticker: UIImageView!
    var takeSticker: UIImageView!
    
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
        
        likeSticker = UIImageView.init(state: like)
        likeSticker.center.x = self.frame.width/3
        likeSticker.center.y = 100
        
        nopeSticker = UIImageView.init(state: nope)
        nopeSticker.center.x = self.frame.width*2/3
        nopeSticker.center.y = 100

        takeSticker = UIImageView.init(state: take)
        takeSticker.center.x = self.frame.width/2
        takeSticker.center.y = UIScreen.mainScreen().bounds.height/2
        
        self.addSubview(likeSticker)
        self.addSubview(nopeSticker)
        self.addSubview(takeSticker)
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
        likeSticker.alpha = likeAlpha
        nopeSticker.alpha = dislikeAlpha
        takeSticker.alpha = superlikeAlpha
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

extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(M_PI))
        }
        
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees))
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center
        CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2)
        
        // Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees))
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        }else {
            yFlip = CGFloat(1.0)
        }
        
        CGContextScaleCTM(bitmap, yFlip, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
    
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIImageView {
    public convenience init(state: String){
        self.init(frame: CGRectMake(0, 0, 250, 0))
        
        self.alpha = 0
        self.contentMode = .ScaleAspectFill
        
        switch  state {
        case "like":
            self.image = UIImage(named: "likeSticker")?.imageRotatedByDegrees(-20, flip: false)
        case "nope":
            self.image = UIImage(named: "nopeSticker")?.imageRotatedByDegrees(20, flip: false)
        case "take":
            self.image = UIImage(named: "takeSticker")?.imageRotatedByDegrees(-20, flip: false)
        default:
            break
        }
    }
    
    public func startAppearing(completion: () -> Void) {
        UIView.animateWithDuration(0.15, animations: { 
            self.alpha = 1
            }) { (success) in
                completion()
                self.appearingDidEnd()
        }
    }
    
    private func appearingDidEnd() {
        self.removeFromSuperview()
    }
}

public enum SPTinderViewCellMovement: Int {
    case None
    case Top
    case Left
    case Bottom
    case Right
}

