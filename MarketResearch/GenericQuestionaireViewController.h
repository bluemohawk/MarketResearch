//
//  GenericQuestionaireViewController.h
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/19/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question_Parse.h"
#import "Study_Parse.h"

@protocol RecordButton_Delegate <NSObject>

@required
    //adopted by ColoringViewController
-(void)nextPage;
-(IBAction)recordAnswer:(id)sender ForQuestionID:(NSString *)parseQuestionID ForStudyID:(NSString *)parseStudyID;
-(IBAction)recordMultiSelection:(NSArray *)arrayOfSelectedItems forQuestionID:(NSString *)parseQuestionID forStudyID:(NSString *)parseStudyID;

@end

@interface GenericQuestionaireViewController : UIViewController

{
    id<RecordButton_Delegate> _delegate;
}

@property (nonatomic) id delegate;
@property (nonatomic) Study_Parse *aStudy_Parse;
@property (nonatomic) Question_Parse *resourcesForQuestion_Parse;



@end
