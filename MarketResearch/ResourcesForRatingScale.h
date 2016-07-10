//
//  ResourcesForRatingScale.h
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 3/5/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <Parse/Parse.h>

@interface ResourcesForRatingScale : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic) NSNumber *StudyNumber;
@property (nonatomic) NSNumber *QuestionnaireNumber;
@property (nonatomic) NSNumber *StringNumber;
@property (nonatomic) NSString *ItemToBeRated;
@property (nonatomic) NSArray *RatingScale;

@end
