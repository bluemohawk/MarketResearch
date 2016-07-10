//
//  Study.h
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <Parse/Parse.h>

@interface Study_Parse : PFObject <PFSubclassing>
+ (NSString *)parseClassName;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) NSArray *ArrayOfQuestionnaires;
@property (nonatomic) NSNumber *StudyNumber;
@property (nonatomic) NSNumber *reward;
@property (nonatomic) PFFile *StudyPicture;


@end
