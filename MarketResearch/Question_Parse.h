//
//  Question_Parse.h
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <Parse/Parse.h>

@interface Question_Parse : PFObject <PFSubclassing>
+ (NSString *)parseClassName;

@property (nonatomic) NSNumber *StudyNumber;
@property (nonatomic) NSNumber *QuestionnaireNumber;
@property (nonatomic) NSString *questionType;
@property (nonatomic) NSString *mainQuestion;
@property (nonatomic) NSString *context;
@property (nonatomic) NSArray *ArrayOfImages;
@property (nonatomic) NSArray *ArrayOfStrings;


    //temp for development
@property (nonatomic) NSNumber *tempQuestionNumber;


@end
