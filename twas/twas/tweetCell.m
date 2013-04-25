//
//  tweetCell.m
//  twas
//
//  Created by Vipul Nataraj on 4/21/13.
//  Copyright (c) 2013 Nakama. All rights reserved.
//

#import "tweetCell.h"
#import "twasAppDelegate.h"
#import <Twitter/Twitter.h>

@implementation tweetCell
@synthesize label;
@synthesize pfPic;
@synthesize userNameCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
