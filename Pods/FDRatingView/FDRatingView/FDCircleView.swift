//
//  FDCircleView.swift
//  FDRatingView
//
//  Created by Felix Deil on 21.05.16.
//  Copyright © 2016 Felix Deil. All rights reserved.
//

import UIKit

/**
 This `UIView` displays a circle, that can be fully or partially filled.
 
 - author: Felix Deil
 */
public class FDCircleView: FDRatingElementView {
    
    // - MARK: Private properties
    
    /**
     The percentage of the circle to be filled. Only use values between 0 and 1!
     */
    private var fillValue:Float = 1
    
    /**
     The layer that draws a fully filled circle
     */
    private var fullCircle:CAShapeLayer!
    
    /**
     The layer that draws the border of a circle
     */
    private var borderCircle:CAShapeLayer!
    
    /**
     An rectangular layer that is used as `mask` for `fullCircle`.
     
     - NOTE: The height should always be the same as the views frame height. Only modify the width!
     */
    private var fillMask:CAShapeLayer!
    
    override public var tintColor:UIColor! {
        get {
            return UIColor.blackColor()
        }
        set (color) {
            fullCircle.fillColor = color.CGColor
            borderCircle.strokeColor = color.CGColor
        }
    }
    
    // - MARK: Initialize the View
    
    /**
     Initializes the `FDCircleView`
     
     - parameter frame: The frame for the view
     
     - parameter fillValue: `Float` bewteen 0 and 1
     
     - parameter color: The color of the circle. Not the background of the view. Acts like `tintColor`
     
     - paramter lineWidth: The with of the border-line (default is 1, but for really small circles, lower values are recommended)
     
     - author: Felix Deil
     */
    public init(frame:CGRect, fillValue fill:Float, color fillColor:UIColor, lineWidth:CGFloat) {
        super.init(frame: frame)
        
        //layer for complete filled star
        fullCircle = CAShapeLayer()
        fullCircle.path = UIBezierPath(ovalInRect: CGRectMake(0, 0, frame.size.height, frame.size.height)).CGPath
        fullCircle.fillColor = fillColor.CGColor
        self.layer.addSublayer(fullCircle)
        
        //layer for border
        borderCircle = CAShapeLayer()
        borderCircle.path = fullCircle.path
        borderCircle.fillColor = UIColor.clearColor().CGColor
        borderCircle.lineWidth = lineWidth
        borderCircle.strokeColor = fillColor.CGColor
        self.layer.addSublayer(borderCircle)
        
        
        //create fill-mask
        let fillWidth = frame.size.width * CGFloat(fill)
        let fillPath = UIBezierPath(ovalInRect: CGRectMake(0, 0, fillWidth, frame.size.height))
        fillMask = CAShapeLayer()
        fillMask.path = fillPath.CGPath
        
        fullCircle.mask = fillMask
    }
    
    /**
     Initializes the `FDCircleView`
     
     - parameter frame: The frame for the view
     
     - parameter fillValue: `Float` bewteen 0 and 1
     
     - parameter color: The color of the circle. Not the background of the view. Acts like `tintColor`
     
     - author: Felix Deil
     */
    public convenience init(frame:CGRect, fillValue fill:Float, color fillColor:UIColor) {
        self.init(frame:frame, fillValue: fill, color: fillColor, lineWidth: 1)
    }
    
    /**
     Initializes the view with a frame
     */
    override private init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        tintColor = UIView().tintColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // - MARK: Modifying the circle
    
    /**
     Changes how much of the circle is filled.
     
     - WARNING: animation does NOT work yet!
     
     - parameter value: The new value
     
     - parameter animated: animations on or off (true/false)
     
     - author: Felix Deil
     */
    public func changeFillValue(value:Float, animated:Bool) {
        let fillWidth = frame.size.width * CGFloat(value)
        let fillPath = UIBezierPath(roundedRect: CGRectMake(0, 0, fillWidth, frame.size.height), cornerRadius: 0)
        fillMask.path = fillPath.CGPath
    }
    
}
