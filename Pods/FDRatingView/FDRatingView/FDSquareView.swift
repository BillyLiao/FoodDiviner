//
//  FDSquareView.swift
//  FDRatingView
//
//  Created by Felix Deil on 15.05.16.
//  Copyright © 2016 Felix Deil. All rights reserved.
//

import UIKit

/**
 This `UIView` displays a square, that can be fully or partially filled.
 
 - author: Felix Deil
 */
public class FDSquareView: FDRatingElementView {
    
    // - MARK: Private properties
    
    /**
     The percentage of the square to be filled. Only use values between 0 and 1!
     */
    private var fillValue:Float = 1
    
    /**
     The layer that draws a fully filled square
     */
    private var fullSquare:CAShapeLayer!
    
    /**
     The layer that draws the border of a star
     */
    private var borderSquare:CAShapeLayer!
    
    /**
     An rectangular layer that is used as `mask` for `fullStar`.
     
     - NOTE: The height should always be the same as the views frame height. Only modify the width!
     */
    private var fillMask:CAShapeLayer!
    
    override public var tintColor:UIColor! {
        get {
            return UIColor.blackColor()
        }
        set (color) {
            fullSquare.fillColor = color.CGColor
            borderSquare.strokeColor = color.CGColor
        }
    }
    
    // - MARK: Initialize the View
    
    /**
     Initializes the `FDSquareView`
     
     - parameter frame: The frame for the view
     
     - parameter fillValue: `Float` bewteen 0 and 1
     
     - parameter color: The color of the square. Not the background of the view. Acts like `tintColor`
     
     - paramter lineWidth: The with of the border-line (default is 1, but for really small squares, lower values are recommended)
     
     - author: Felix Deil
     */
    public init(frame:CGRect, fillValue fill:Float, color fillColor:UIColor, lineWidth:CGFloat) {
        super.init(frame: frame)
        
        //layer for complete filled star
        fullSquare = CAShapeLayer()
        fullSquare.path = UIBezierPath(rect: CGRectMake(0, 0, frame.size.height, frame.size.height)).CGPath
        fullSquare.fillColor = fillColor.CGColor
        self.layer.addSublayer(fullSquare)
        
        //layer for border
        borderSquare = CAShapeLayer()
        borderSquare.path = fullSquare.path
        borderSquare.fillColor = UIColor.clearColor().CGColor
        borderSquare.lineWidth = lineWidth
        borderSquare.strokeColor = fillColor.CGColor
        self.layer.addSublayer(borderSquare)
        
        
        //create fill-mask
        let fillWidth = frame.size.width * CGFloat(fill)
        let fillPath = UIBezierPath(roundedRect: CGRectMake(0, 0, fillWidth, frame.size.height), cornerRadius: 0)
        fillMask = CAShapeLayer()
        fillMask.path = fillPath.CGPath
        
        fullSquare.mask = fillMask
    }
    
    /**
     Initializes the `FDSquareView`
     
     - parameter frame: The frame for the view
     
     - parameter fillValue: `Float` bewteen 0 and 1
     
     - parameter color: The color of the square. Not the background of the view. Acts like `tintColor`
     
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
    
    
    // - MARK: Modifying the Square
    
    /**
     Changes how much of the square is filled.
     
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
