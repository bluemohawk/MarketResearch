//
//  ScrollViewSubClass.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 3/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "ScrollViewSubClass.h"

@interface ScrollViewSubClass ()

@property (nonatomic) NSString *instructionFromParse;

@end


@implementation ScrollViewSubClass

-(id)initWithTextInput:(NSString *)aStringParse {

    if (self = [super init])  {

        self.instructionFromParse = aStringParse;
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return (self);

}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    [self setContentForQuestionScrollView];
    
}

-(void)setContentForQuestionScrollView {
    
    NSLog(@"H: %f, W: %f", self.frame.size.height, self.frame.size.width);

    
    
    NSMutableArray *arrayOfViews = [NSMutableArray new];
    
    
    for (int i = 0; i<10; i++) {
        UIView *newView = [[UIView alloc]init];
            //        newView.backgroundColor = [UIColor blackColor];
                    newView.layer.contents = (__bridge id)([UIImage imageNamed:@"tower.png"].CGImage);
        newView.translatesAutoresizingMaskIntoConstraints = NO;
        newView.layer.borderColor = [UIColor whiteColor].CGColor;
        newView.layer.borderWidth = 1.0;
        [self addSubview:newView];
        [arrayOfViews addObject:newView];
        
        UILabel *aLabel = [[UILabel alloc]init];
//        aLabel.backgroundColor = [UIColor redColor];
        aLabel.translatesAutoresizingMaskIntoConstraints = NO;
        aLabel.textAlignment = NSTextAlignmentLeft;
        aLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:30.0];
        aLabel.numberOfLines = 10;
//        aLabel.text = arrayOfSentences [i];
        [newView addSubview:aLabel];
        
        NSDictionary *subDict = NSDictionaryOfVariableBindings(newView, aLabel);
        [newView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[aLabel]-|" options:0 metrics:0 views:subDict]];
        [newView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[aLabel]-|" options:0 metrics:0 views:subDict]];
        
        
    }
    
    
    for (UIView *newView in arrayOfViews) {
        
        NSUInteger i = [arrayOfViews indexOfObject:newView];
        NSNumber *scrollWidth = [NSNumber numberWithFloat:self.frame.size.width];
        NSNumber *scrollHeight = [NSNumber numberWithFloat:self.frame.size.height];

        NSDictionary *metrics = @{@"scrollWidth":scrollWidth, @"scrollHeight":scrollHeight};
        
        if (i == 0) {
            
            NSLog(@"first");  //first page only
            NSDictionary *subDict = NSDictionaryOfVariableBindings(newView);

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[newView(scrollHeight)]|" options:0 metrics:metrics views:subDict]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[newView(scrollWidth)]" options:NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop metrics:metrics views:subDict]];
            
        } else if ( (i >0) && (i< arrayOfViews.count -1) ) {
            
            NSLog(@"subsequent");  //all pages except first and last pages
            UIView *leftView = [arrayOfViews objectAtIndex:i-1];
            UIView *newView = [arrayOfViews objectAtIndex:i];
            NSDictionary *subDict = NSDictionaryOfVariableBindings(leftView, newView);
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftView(scrollWidth)][newView(scrollWidth)]" options:NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop metrics:metrics views:subDict]];
            
        } else  {
            NSLog(@"end"); //last page only
            UIView *leftView = [arrayOfViews objectAtIndex:i-1];
            UIView *newLastView = [arrayOfViews objectAtIndex:i];
            NSDictionary *subDict = NSDictionaryOfVariableBindings(leftView, newLastView);
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftView(scrollWidth)][newLastView(scrollWidth)]|" options:NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop metrics:metrics views:subDict]];
        }
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
