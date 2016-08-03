//
//  Star.swift
//  FDRatingView
//
//  Created by Felix Deil on 11.05.16.
//  Copyright © 2016 Felix Deil. All rights reserved.
//

import UIKit

/**
 Struct to generate paths for stars
 
 - author: Felix Deil, [Silviu Pop](https://www.weheartswift.com/bezier-paths-gesture-recognizers/)
 */
internal struct Star {
    
    internal var pointsOnStar:Int = 5
    
    /**
     Returns the path for a star
     
     - author: [Silviu Pop](https://www.weheartswift.com/bezier-paths-gesture-recognizers/)
     
     - copyright: Silviu Pop
     */
    private func starPathInRect(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        let starExtrusion:CGFloat = rect.width*0.19
        
        let center = CGPointMake(rect.width / 2.0, rect.height / 2.0)
        
        
        var angle:CGFloat = -CGFloat(M_PI / 2.0)
        let angleIncrement = CGFloat(M_PI * 2.0 / Double(pointsOnStar))
        let radius = rect.width / 2.0
        
        var firstPoint = true
        
        for _ in 1...pointsOnStar {
            
            let point = pointFrom(angle, radius: radius, offset: center)
            let nextPoint = pointFrom(angle + angleIncrement, radius: radius, offset: center)
            let midPoint = pointFrom(angle + angleIncrement / 2.0, radius: starExtrusion, offset: center)
            
            if firstPoint {
                firstPoint = false
                path.moveToPoint(point)
            }
            
            path.addLineToPoint(midPoint)
            path.addLineToPoint(nextPoint)
            
            angle += angleIncrement
        }
        
        path.closePath()
        
        return path
    }
    
    /**
     The `CGPath` of the star in `rect`
     
     - parameter rect: The square, that should contain the star
     */
    internal func CGPathInRect(rect:CGRect) -> CGPath {
        return starPathInRect(rect).CGPath
    }
    
    /**
     The `UIBezierPath` of the star in `rect`
     
     - parameter rect: The square, that should contain the star
     */
    internal func pathInRect(rect:CGRect) -> UIBezierPath {
        return starPathInRect(rect)
    }
    
    private func pointFrom(angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
        return CGPointMake(radius * cos(angle) + offset.x, radius * sin(angle) + offset.y)
    }
    
    internal init() {
        
    }
    
}
