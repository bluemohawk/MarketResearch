//
//  Question_Parse.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "Question_Parse.h"
#import <Parse/PFObject+Subclass.h>

@implementation Question_Parse
@dynamic StudyNumber;
@dynamic QuestionnaireNumber;

    //temp for  developement
@dynamic tempQuestionNumber;


@dynamic questionType;
@dynamic mainQuestion;
@dynamic context;
@dynamic ArrayOfImages;
@dynamic ArrayOfStrings;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"ListOfQuestions";
}
@end
