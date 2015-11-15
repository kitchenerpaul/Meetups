//
//  EventViewController.m
//  MeetMeUp
//
//  Created by Paul Kitchener on 10/12/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import "EventViewController.h"
#import "WebViewController.h"

@interface EventViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rsvpCountsLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostingGroupLabel;

@property (weak, nonatomic) IBOutlet UITextView *eventTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *commentsBarButton;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.commentsBarButton.enabled = NO;

    self.hostingGroupLabel.text = [NSString stringWithFormat:@"Hosted by: %@",[[self.eventDictionary objectForKey:@"venue"] objectForKey:@"name"]];
    self.eventTitleLabel.text = [self.eventDictionary objectForKey:@"name"];
    self.eventTextView.text = [self.eventDictionary objectForKey:@"description"];
    self.rsvpCountsLabel.text = [NSString stringWithFormat:@"Attending: %@",[[self.eventDictionary objectForKey:@"yes_rsvp_count"] stringValue]];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    WebViewController *webViewController = segue.destinationViewController;
    webViewController.webDictionary = self.eventDictionary;
}



@end
