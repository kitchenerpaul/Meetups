//
//  ViewController.m
//  MeetMeUp
//
//  Created by Paul Kitchener on 10/12/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import "ViewController.h"
#import "EventViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *meetUpTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property NSMutableArray *meetUps;
@property NSDictionary *meetUpDictionary;

@property NSMutableArray *searches;
@property NSString *searchText;

@property BOOL isBeingEdited;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isBeingEdited = NO;
    self.searchBar.delegate = self;

    NSURL *url = [NSURL URLWithString:@"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=477d1928246a4e162252547b766d3c6d"];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        self.meetUpDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

        dispatch_async(dispatch_get_main_queue(), ^{

            self.meetUps = [self.meetUpDictionary objectForKey:@"results"];
            [self.meetUpTableView reloadData];

        });
    }];

    [task resume];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.isBeingEdited) {
        return self.searches.count;
    } else {
        return self.meetUps.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetUpID"];

    NSDictionary *event;
    if (self.isBeingEdited) {
        event = [self.searches objectAtIndex:indexPath.row];
    } else {
        event = [self.meetUps objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = [event objectForKey:@"name"];
    NSString *address = [[event objectForKey:@"venue"] objectForKey:@"address_1"];
    NSString *city = [[event objectForKey:@"venue"] objectForKey:@"city"];
    NSString *state = [[event objectForKey:@"venue"] objectForKey:@"state"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %@", address, city, state];

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if (self.isBeingEdited) {
        NSIndexPath *indexPath = [self.meetUpTableView indexPathForCell:sender];
        NSDictionary *newDictionary = [self.searches objectAtIndex:indexPath.row];
        EventViewController *eventViewController = segue.destinationViewController;
        eventViewController.eventDictionary = newDictionary;
    } else {
        NSIndexPath *indexPath = [self.meetUpTableView indexPathForCell:sender];
        NSDictionary *newDictionary = [self.meetUps objectAtIndex:indexPath.row];
        EventViewController *eventViewController = segue.destinationViewController;
        eventViewController.eventDictionary = newDictionary;
    }

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    if (searchText.length > 0) {

        self.isBeingEdited = YES;
        self.searches = [NSMutableArray new];

        for (NSDictionary *dictionary in self.meetUps) {

            NSRange eventRange = [[dictionary valueForKey:@"name"]rangeOfString:searchText options:NSCaseInsensitiveSearch];

            if (eventRange.location != NSNotFound) {
                [self.searches addObject:dictionary];
            }
        }

    } else {
        self.isBeingEdited = NO;
    }
    
    [self.meetUpTableView reloadData];
}

@end
