//
//  AnswerButtonViewController.h
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/20/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AnswerButton_Delegate <NSObject>

@required
    //adopted by ColoringViewController
-(void) nextPage;

@end

@interface AnswerButton : UIButton

{
    id<AnswerButton_Delegate> _delegate;
}

@property (nonatomic) id delegate;


@end
