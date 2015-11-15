//
//  Member.h
//  MeetMeUp
//
//  Created by Paul Kitchener on 11/15/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject

@property NSString *name;
@property NSString *city;
@property NSString *state;
@property NSString *country;
@property NSURL *photoURL;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(void)getImageWithCompletion:(void (^)(NSData *data))complete;
+(void)retrieveMembersWithMemberID:(NSString *)memberID andCompletion:(void (^)(Member *member))complete;

@end