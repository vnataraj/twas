//
//  MentionsViewController.m
//  twas
//
//  Created by Vipul Nataraj on 4/20/13.
//  Copyright (c) 2013 Nakama. All rights reserved.
//

#import "MentionsViewController.h"
#import "twasAppDelegate.h"
#import <Twitter/Twitter.h>
#import "tweetCell.h"

@interface MentionsViewController ()
@property (strong, nonatomic) NSArray *tweetArray;
-(void) getFeed;
-(void) updateFeed: (id) feedData;
@end

@implementation MentionsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    twasAppDelegate *delegater= [[UIApplication sharedApplication] delegate];
    if(delegater.userAccount)
    {
        [self getFeed];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFeed) name:@"TwitterAccountAcquiredNotification" object:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tweetArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    return cell;
}


- (BOOL) canBecomeFirstResponder{
    return YES;
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    [super viewDidDisappear:animated];
}
- (void) viewDidDisappear:(BOOL)animated{
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}
- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    [self getFeed];
}

-(void) getFeed{
    NSURL *feedURL = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"15", @"count", nil];
    SLRequest *twitterfeed = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:feedURL parameters:parameters];
    twasAppDelegate *delegater = [[UIApplication sharedApplication] delegate];
    twitterfeed.account=delegater.userAccount;
    UIApplication *sharedApp = [UIApplication sharedApplication];
    sharedApp.networkActivityIndicatorVisible = YES;
    [twitterfeed performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if(!error){
            NSError *jsonError=nil;
            id feedStuffs = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            if(!jsonError){
                [self updateFeed:feedStuffs];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }
        }
        else{
            UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
        sharedApp.networkActivityIndicatorVisible=NO;
    }];
    
}

-(void) updateFeed: (id)feedData{
    //donothing();
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
