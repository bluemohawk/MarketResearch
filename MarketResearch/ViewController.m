//
//  ViewController.m
//  MarketResearch
//
//  Created by FRANCOIS EVERHARD on 1/16/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "ViewController.h"
//#import "ItemForSelection.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;

@property NSMutableArray *arrayOfImages;
@property UIView *currentlyDisplayedImage;


@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.navigationController.navigationBarHidden = YES;
//    self.tabBarController.tabBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.arrayOfImages = [[NSMutableArray alloc]init];

    for (int i = 1; i <= 3; i++) {
        UIView *anImage = [[UIView alloc]init];
//        anImage.backgroundColor = [UIColor redColor];
//        anImage.layer.borderColor = [UIColor whiteColor].CGColor;
//        anImage.layer.borderWidth = 2.0;
        anImage.frame = CGRectZero;
        anImage.center = self.view.center;
        anImage.layer.contents = (__bridge id)([UIImage imageNamed:@"tower.png"].CGImage);
        anImage.layer.contentsGravity = kCAGravityCenter;
        anImage.layer.bounds = self.view.frame;

        anImage.layer.masksToBounds = YES;
        [self.arrayOfImages addObject:anImage];
    }


    [self setLabel:self.titleLabel];
    [self setSelectionOfImages:self.arrayOfImages];
    
    [self setQuestion:self.questionLabel];
    [self setButtonsForAnswer];
//    [self setNumberSelection:self.arrayOfImages];
    
    NSLog(@"The Array is .... %@", self.questionnaireTypes);

}


-(void)setLabel:(UILabel *)titleLabel {
    
    self.titleLabel.backgroundColor = [UIColor grayColor];
    self.titleLabel.text = @"I would like to know which of these pictures are associated to the brand. Please indicate your prefered picture.";
    self.titleLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveLabel:)];
    [self.titleLabel addGestureRecognizer:aTap];
}


-(void)moveLabel:(UITapGestureRecognizer*)sender {
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.titleLabel.center = CGPointMake(CGRectGetMidX(self.view.frame), 0);

    } completion:^(BOOL finished) {
        NSLog(@"finished");
    }];
}

#pragma mark - Questions and Buttons for Answers

-(void)setQuestion:(UILabel *)aQuestion {

    self.questionLabel.backgroundColor = [UIColor grayColor];
    self.questionLabel.textColor = [UIColor whiteColor];
    self.questionLabel.text = @"First Question?";
    
}

-(void)setButtonsForAnswer {
    
    self.yesButton.backgroundColor = [UIColor whiteColor];
    [self.yesButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.yesButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    self.yesButton.layer.cornerRadius = self.yesButton.frame.size.width/2;
    self.noButton.backgroundColor = [UIColor whiteColor];
    self.noButton.layer.cornerRadius = self.noButton.frame.size.width/2;
    
    self.yesButton.alpha = 0.0;
    self.noButton.alpha = 0.0;
    
}


-(void)updateButtonAlpha_ZPosition {
    
    if ((self.yesButton.alpha == 0.0) || (self.noButton.alpha == 0.0)) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.yesButton.alpha = 1.0;
            self.noButton.alpha = 1.0;
        }];
        
        [self.view bringSubviewToFront:self.yesButton];
        [self.view bringSubviewToFront:self.noButton];
        
    } else {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.yesButton.alpha = 0.0;
            self.noButton.alpha = 0.0;
        }];
    }
}


-(IBAction)recordAnswer:(UIButton *)sender {
    
    NSLog(@"%@", sender.titleLabel.text);
    
    [self deselectPicture:self.currentlyDisplayedImage];
    self.currentlyDisplayedImage = nil;
    
}



#pragma mark - Image Geometry and Animations


-(void)setNumberSelection:(NSArray *)arrayOfImages {
    
    NSInteger N = arrayOfImages.count;
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat y_center = CGRectGetMidY(self.view.frame);

    for (int i = 1; i <= N; i++) {
        
        UIView *aView = [[UIView alloc]init];

        aView.backgroundColor = [UIColor clearColor];
        aView.layer.borderColor = [UIColor blackColor].CGColor;
        aView.layer.borderWidth = 2.0;
    
        aView.tag = i;
        
        aView.bounds = CGRectMake(0, 0, 0, 0);
        
        UILabel *aLabel = [[UILabel alloc]init];
        aLabel.frame = aView.frame;
        aLabel.backgroundColor = [UIColor blueColor];
        aLabel.text =  @"AA";
        [aView addSubview:aLabel];
        
        CGRect targetBounds = CGRectMake(0,
                                  0,
                                  width /N -10,
                                  width /N -10);
        
        aView.center = CGPointMake(
                                   
                                   ((width /N) *i) - (width /N) /2 ,
                                   y_center
                                   
                                   );
        
//        UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPicture:)];
//        [aView addGestureRecognizer:aTap];
        
        
        [self.view addSubview:aView];
        
        [UIView animateWithDuration:0.5
                              delay:0.2 *i
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.1
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             aView.bounds = targetBounds;

                         } completion:^(BOOL finished) {
                             
                             [self animateNumberSelection:aView];
                             
                         }];
    }
}


-(void)setSelectionOfImages:(NSMutableArray *)arrayOfImages {
    
    NSInteger N = arrayOfImages.count;

    for (int i = 0; i < N; i++) {
        
        UIView *imageView = [self.arrayOfImages objectAtIndex:i];
        
        imageView.bounds = [self calculateSize:imageView];
        imageView.center = [self calculatePosition:imageView];
        
        UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPicture:)];
        [imageView addGestureRecognizer:aTap];

        [self.view addSubview:imageView];
        
    }
}


-(CGRect)calculateSize:(UIView *)anImage {
    
    NSInteger N = self.arrayOfImages.count;

    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGRect bounds;

    if ((anImage.frame.size.width == width) || (anImage.frame.size.width == 0)) {
        
            //small size
        bounds = CGRectMake(0, 0,
                          width /N -0,
                          height /2);
    } else {
        
            //full size
        bounds = CGRectMake(0, 0,
                         width,
                         height);
    }
    
    return bounds;
}


-(CGPoint)calculatePosition:(UIView *)anImage {
    
    NSInteger N = self.arrayOfImages.count;
    NSUInteger i = [self.arrayOfImages indexOfObject:anImage] +1;
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat x_center = CGRectGetMidX(self.view.frame);
    CGFloat y_center = CGRectGetMidY(self.view.frame);

    
    CGPoint centerPoint;
    
    if (anImage.center.x == x_center ) {
        
        //center point for small size image
        centerPoint = CGPointMake(
                                  ((width /N) *i) - ((width /N) /2) ,
                                  y_center );
    
    } else {
        
        //center point for full size image
        centerPoint = CGPointMake(
                                  x_center,
                                  y_center);

    }
    
    NSLog(@"x: %f, y: %f, N: %ld, i: %lu", centerPoint.x, centerPoint.y, (long)N, (unsigned long)i);
    return centerPoint;
}


-(void)updateViewAlpha:(UIView *)aView {
    
    
    for (UIView *eachView in self.arrayOfImages) {
        
        
        //view that is selected
        if ([eachView isEqual:aView]) {
            
            [UIView animateWithDuration:0.5
                             animations:^{
                                 eachView.alpha = 1.0;
                             }];
            
            
        //views that are already invisible
        } else if ((eachView.alpha == 0.0)) {
            
            [UIView animateWithDuration:0.5
                             animations:^{
                                 eachView.alpha = 1.0;
                             }];
            
            
        //views that are NOT selected and still visible
        } else {
            
            [UIView animateWithDuration:0.5
                             animations:^{
                                 eachView.alpha = 0.0;
                             }];
        }
    }
}


-(void)selectPicture:(UITapGestureRecognizer*)sender {
    
    UIView *touchedView = sender.view;
    NSLog(@"%ld", (long)sender.view.tag);
    
    [UIView animateWithDuration:0.5
                          delay:0.2
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                        [self.view bringSubviewToFront:sender.view];
                        sender.view.center = [self calculatePosition:touchedView];
                        sender.view.bounds = [self calculateSize:touchedView];
                         
                     } completion:^(BOOL finished) {}];
    
    [self updateViewAlpha:sender.view];
    [self updateButtonAlpha_ZPosition];
    self.currentlyDisplayedImage = touchedView;
    
}


-(void)deselectPicture:(UIView *)aPicture {
    
    [UIView animateWithDuration:0.5
                          delay:0.2
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         [self.view bringSubviewToFront:aPicture];
                         aPicture.center = [self calculatePosition:aPicture];
                         aPicture.bounds = [self calculateSize:aPicture];
                         
                     } completion:^(BOOL finished) {}];

    [self updateViewAlpha:aPicture];
    [self updateButtonAlpha_ZPosition];
    
}

-(void)animateNumberSelection:(UIView*)aView {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:aView.frame];
    
        //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 10;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
        //add it to our view
    [self.view.layer addSublayer:shapeLayer];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
