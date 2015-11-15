//
//  Member.m
//  MeetMeUp
//
//  Created by Paul Kitchener on 11/15/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import "Member.h"

@implementation Member

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self) {
        self = [super init];

        self.name = dictionary[@"name"];
        self.city = dictionary[@"city"];
        self.state = dictionary[@"state"];
        self.country = dictionary [@"country"];
        self.photoURL = [NSURL URLWithString:dictionary[@"photo"] [@"photo_link"]];
    }
    return self;
}

-(void)getImageWithCompletion:(void (^)(NSData *))complete {
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:self.photoURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        complete(data);
    }];
    [task resume];
}

+(void)retrieveMembersWithMemberID:(NSString *)memberID andCompletion:(void (^)(Member *))complete {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/member/%@?&sign=true&photo-host=public&page=20&key=45583c1752387071707423554329222a", memberID]];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        Member *member = [[Member alloc] initWithDictionary:dictionary];

        dispatch_async(dispatch_get_main_queue(), ^{
            complete(member);
        });
    }];
    
    [task resume];
}

@end