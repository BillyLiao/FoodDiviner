//
//  FDRatingElementView.swift
//  FDRatingView
//
//  Created by Felix Deil on 15.05.16.
//  Copyright © 2016 Felix Deil. All rights reserved.
//

import UIKit

/**
 - note: This class is just a superclass for the elements to use in `FDRatingView`. It makes it easier to store them in an array.
 
 - author: Felix Deil
 */
public class FDRatingElementView: UIView {
    
    override public var tintColor: UIColor! {
        get {
            return self.tintColor
        }
        set (color) {
            //just to exist ;-)
        }
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
