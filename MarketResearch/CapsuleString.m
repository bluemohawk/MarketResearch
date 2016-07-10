//
//  CapsuleString.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 2/24/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "CapsuleString.h"
#import "define.h"

@interface CapsuleString ()

@property (nonatomic) UILabel *label;

@end

@implementation CapsuleString

-(id)initWithTextInput:(NSString *)aString andReceivingView:(UIView *)receivingView {
    
    if (self = [super init])  {
        
            //Text and Label Formating according to device
        CGFloat fontSize;
        CGFloat Left_offSet;
        CGFloat insideMargin;
        if (SCREEN_W<1023)
        {
                //iPhone
            fontSize = 23.0f;
            Left_offSet = 30.0f;
            insideMargin = 5.0f;
        }
        else {
                //iPad
            fontSize = 28.0f;
            Left_offSet = 50.0f;
            insideMargin = 10.0f;
        };
            //-----------------------------
        
        UIFont *font = [UIFont fontWithName:@"Helvetica-Light" size:fontSize];
        CGSize constraint = CGSizeMake(receivingView.bounds.size.width-10, MAXFLOAT);
        CGRect sizeOfTextInput = [aString boundingRectWithSize:constraint
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:font}
                                                       context:nil];
        
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(insideMargin, insideMargin, sizeOfTextInput.size.width, sizeOfTextInput.size.height)];
        text.text = aString;
        text.font = font;
        text.textAlignment = NSTextAlignmentLeft;
        text.numberOfLines = 10;
        text.textColor = [self setColorAccordingToRecievingView:receivingView];
        text.backgroundColor = [UIColor clearColor];
        [text sizeToFit];
        
        self.frame = CGRectMake(0, 0, receivingView.bounds.size.width, sizeOfTextInput.size.height+2*insideMargin);
        self.layer.backgroundColor = [[UIColor clearColor]CGColor];
        self.layer.cornerRadius = 10.0;
        [self addSubview:text];
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        self.label = text;
        self.stringForSelection = text.text;
        
        self.isSelected = NO;
        self.userInteractionEnabled = YES;
    }
    return (self);
}

-(UIColor *)setColorAccordingToRecievingView:(UIView *)receivingView {
    
    UIColor *colorForText;
    if (receivingView.backgroundColor == [UIColor blackColor]) {
        NSLog(@"black");
        colorForText = [UIColor whiteColor];
    } else {
        NSLog(@"non black");

        colorForText = [UIColor blackColor];
    }
    return colorForText;
}


-(void)changeApperanceWhenSelected {
    
    if (self.isSelected == NO) {

        if (self.label.textColor == [UIColor blackColor]) {
            self.label.textColor = [UIColor whiteColor];
            self.layer.backgroundColor = [[UIColor blackColor]CGColor];

        } else {
            self.label.textColor = [UIColor blackColor];
            self.layer.backgroundColor = [[UIColor whiteColor]CGColor];
        }
        
        self.isSelected = YES;
        NSLog(@"selected");
        
    } else {
        
        if (self.label.textColor == [UIColor blackColor]) {
            self.label.textColor = [UIColor whiteColor];
            self.layer.backgroundColor = [[UIColor clearColor]CGColor];
            
        } else {
            self.label.textColor = [UIColor blackColor];
            self.layer.backgroundColor = [[UIColor whiteColor]CGColor];
        }
        
        self.isSelected = NO;
        NSLog(@"unselected");
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
