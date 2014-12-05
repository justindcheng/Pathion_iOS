//
//  ChatCell.h
//  Pathion
//
//  Created by justin cheng on 1/10/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell
{
    IBOutlet UILabel *userLabel;
    IBOutlet UITextView *textString;
    IBOutlet UILabel *timeLabel;
}
@property (nonatomic,retain) IBOutlet UILabel *userLabel;
@property (nonatomic,retain) IBOutlet UITextView *textString;
@property (nonatomic,retain) IBOutlet UILabel *timeLabel;
@end
