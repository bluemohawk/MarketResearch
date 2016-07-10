//
//  Study.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "Study_Parse.h"
#import <Parse/PFObject+Subclass.h>

@implementation Study_Parse
@dynamic title;
@dynamic subtitle;
@dynamic ArrayOfQuestionnaires;
@dynamic StudyNumber;
@dynamic reward;
@dynamic StudyPicture;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"ListOfStudies";
}

@end
