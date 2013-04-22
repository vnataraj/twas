//
//  tweetCell.m
//  twas
//
//  Created by Vipul Nataraj on 4/21/13.
//  Copyright (c) 2013 Nakama. All rights reserved.
//

#import "tweetCell.h"
#import "twasAppDelegate.h"
#import "Twitter/Twitter.h"

@implementation tweetCell
@synthesize label= _label;
@synthesize pfPic= _pfPic;
@synthesize userNameCell= _userNameCell;

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ContentCell";
    tweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *currentTweet = [self.tweetArray objectAtIndex:indexPath.row];
    NSDictionary *currentUser = [currentTweet objectForKey:@"user"];
    cell.userNameCell.text = [currentUser objectForKey:@"name"];
    cell.label.text = [currentTweet objectForKey:@"text"];
    cell.pfPic.image = [UIImage imageNamed:@"SomeDefaultImage.png"];
    NSString *userName = cell.label.text;
    twasAppDelegate *delegater = [[UIApplication sharedApplication] delegate];
    if ([delegater.profileImages objectForKey:userName]){
        cell.pfPic.image = [delegater.profileImages objectForKey:userName];
    }
    else {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            NSURL *imageURL = [NSURL URLWithString: [currentUser objectForKey:@"profile_image_url"]];
            __block NSData *imageData;
            dispatch_sync(concurrentQueue, ^{
                imageData = [NSData dataWithContentsOfURL:imageURL];
                [delegater.profileImages setObject:[UIImage imageWithData:imageData] forKey:userName];
            });
            dispatch_sync(dispatch_get_main_queue(), ^{
                cell.pfPic.image = [delegater.profileImages objectForKey:userName];
            });
        });
    }
}

@end
