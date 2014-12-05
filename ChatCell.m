//
//  ChatCell.m
//  Pathion
//
//  Created by justin cheng on 1/10/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell
@synthesize userLabel, timeLabel, textString;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
