//
//  FDRatingView.swift
//  FDRatingView
//
//  Created by Felix Deil on 11.05.16.
//  Copyright © 2016 Felix Deil. All rights reserved.
//

import UIKit

/**
 Defines the different styles of `FDRatingView`
 */
public enum FDRatingViewStyle:Int {
    case Star, Square, Circle
}

/**
 This view displays multiple `FDStarView` next to each other and fills them depending on the rating.
 
 - author: Felix Deil
 */
public class FDRatingView:UIView {
    
    // - MARK: Public properties
    
    /**
     The number of elements (for example stars) to display (default is 5)
     */
    public var numberOfElements:UInt = 5
    
    override public var tintColor:UIColor! {
        get {
            return UIColor.blackColor()
        }
        set (color) {
            for element in elements {
                element.tintColor = color
            }
        }
    }
    
    
    // - MARK: Private properties
    
    /**
     Stores all displayed elements in an `[FDRatingElementView]`-array
     */
    private var elements:[FDRatingElementView]! = [FDRatingElementView]()
    
    
    // - MARK: Initializers
    
    /**
     Initializes the `FDRatingView` with all parameters.
     
     - parameter frame: The frame for the view
     
     - parameter style: The style how the rating will be displayed
     
     - parameter numberOfElements: The number of elements to be displayed (usually, that is NOT the rating)
     
     - parameter fillValue: The value, how much of the elements should be filled. (the rating) This should be a `Float` between `0` and `numberOfElements`
     
     - parameter color: The color of the elements (acts like `tintColor`)
     
     - parameter lineWidth: The with of the outer line of the elements
     
     - parameter spacing: The space between the elements
     
     - author: Felix Deil
     */
    public init(frame newFrame:CGRect, style:FDRatingViewStyle, numberOfElements:UInt, fillValue value:Float, color:UIColor, lineWidth:CGFloat, spacing:CGFloat) {
        var new = newFrame
        let elementsFloat = CGFloat(numberOfElements)
        new.size.width = (newFrame.size.height + spacing) * elementsFloat - spacing
        super.init(frame: new)
        
        tintColor = color
        
        let height = new.size.height
        var xOffset = CGFloat(0)
        
        var ratingValue = value
        
        //create elements and store them in the array
        for _ in 1...numberOfElements {
            let elementFrame = CGRectMake(xOffset, 0.0, height, height)
            
            var tmpRating:Float = 0
            
            if ratingValue > 1 {
                tmpRating = 1
                ratingValue -= 1
            } else if ratingValue > 0 {
                tmpRating = ratingValue
                ratingValue = 0
            }
            
            switch style {
            case .Square:
                elements.append(FDSquareView(frame: elementFrame, fillValue: tmpRating, color: color, lineWidth: lineWidth))
                break;
            case .Star:
                elements.append(FDStarView(frame: elementFrame, fillValue: tmpRating, color: color, lineWidth: lineWidth))
                break;
            case .Circle:
                elements.append(FDCircleView(frame: elementFrame, fillValue: tmpRating, color: color, lineWidth: lineWidth))
                break;
            }
            
            xOffset += CGFloat(height + spacing)
        }
        
        
        //add them as subview (and set fillValue)
        for element in elements {
            addSubview(element)
        }
    }
    
    /**
     Initializes the `FDRatingView`
     
     - parameter frame: The frame for the view
     
     - parameter style: The style how the rating will be displayed
     
     - parameter numberOfElements: The number of elements to be displayed (usually, that is NOT the rating)
     
     - parameter fillValue: The value, how much of the elements should be filled. (the rating) This should be a `Float` between `0` and `numberOfElements`
     
     - parameter color: The color of the elements (acts like `tintColor`)
     
     - parameter lineWidth: The with of the outer line of the elements
     
     - author: Felix Deil
     */
    public convenience init(frame newFrame:CGRect, style:FDRatingViewStyle, numberOfElements:UInt, fillValue value:Float, color:UIColor, lineWidth:CGFloat) {
        self.init(frame: newFrame, style: style, numberOfElements: numberOfElements, fillValue: value, color: color, lineWidth: lineWidth, spacing: 8.0)
    }
    
    /**
     Initializes the `FDRatingView`
     
     - parameter frame: The frame for the view
     
     - parameter style: The style how the rating will be displayed
     
     - parameter numberOfElements: The number of elements to be displayed (usually, that is NOT the rating)
     
     - parameter fillValue: The value, how much of the elements should be filled. (the rating) This should be a `Float` between `0` and `numberOfElements`
     
     - parameter color: The color of the elements (acts like `tintColor`)
     
     - author: Felix Deil
     */
    public convenience init(frame newFrame:CGRect, style:FDRatingViewStyle, numberOfElements:UInt, fillValue value:Float, color:UIColor) {
        self.init(frame: newFrame, style: style, numberOfElements: numberOfElements, fillValue: value, color: color, lineWidth: 1)
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
}
