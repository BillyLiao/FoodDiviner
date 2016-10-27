//
//  StickerImageView.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/10/27.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit

class StickerImageView: UIImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    init(state: String){
        super.init(frame: CGRectMake(0, 0, 250, 0))
        self.contentMode = .ScaleAspectFill
        self.alpha = 0
        
        switch state {
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        UIView.animateWithDuration(0.15, animations: { 
            self.alpha = 1
            }) { (success) in
                self.removeFromSuperview()
        }
    }
}
