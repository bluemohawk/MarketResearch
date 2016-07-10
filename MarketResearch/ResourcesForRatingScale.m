//
//  ResourcesForRatingScale.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 3/5/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "ResourcesForRatingScale.h"
#import <Parse/PFObject+Subclass.h>

@implementation ResourcesForRatingScale

@dynamic StudyNumber;
@dynamic QuestionnaireNumber;
@dynamic StringNumber;
@dynamic ItemToBeRated;
@dynamic RatingScale;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"ResourcesForRatingScale";
}

@end
