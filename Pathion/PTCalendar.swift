//
//  PTCalendar.swift
//  Pathion
//
//  Created by justin cheng on 20/9/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

import UIKit

class PTCalendar: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let navBarSize: CGSize = self.navigationController!.navigationBar.bounds.size
        for (var i = 1; i <= 11; i++) {
            var y: Int
            if i<=4 {
                y = 14
            } else {
                y = 15
            }
            var imageName = String(format:"%02d_%02d", y,(i+7)%12+1)
            var image = UIImage(named: imageName)
            var imageView: UIImageView = UIImageView(image: image)
    
            // setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
            var rect: CGRect = imageView.frame
            rect.size.height = screenSize.height-navBarSize.height-20.0
            rect.size.width = screenSize.width
            rect.origin.x = screenSize.width * CGFloat(i-1)
            rect.origin.y = 0
            imageView.frame = rect
            imageView.tag = i	// tag our images for later use when we place them in serial fashion
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: 11*screenSize.width, height: scrollView.frame.height-navBarSize.height-20.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
