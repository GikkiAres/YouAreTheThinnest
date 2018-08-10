//
//  MainViewController.m
//  谁是最瘦的
//
//  Created by GikkiAres on 2018/6/10.
//  Copyright © 2018 GikkiAres. All rights reserved.
//

#import "MainViewController.h"
#import "GaDisplayManager.h"

@interface MainViewController ()<
UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UITextView *tv;
@property (weak, nonatomic) IBOutlet UIView *vRotator;
@property (weak, nonatomic) IBOutlet UIButton *vIndicator;
@property (weak, nonatomic) IBOutlet UIButton *btnView;
@property (weak, nonatomic) IBOutlet UIView *vView;
@property (weak, nonatomic) IBOutlet UIView *vAnswer;

@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (strong, nonatomic) IBOutlet UIView *vAsk;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbAnswerName;


@end

@implementation MainViewController

#define Name @"Name"

#pragma mark 1 LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CGAffineTransform trasform = CGAffineTransformMakeRotation(30*M_PI/180);
//    _vRotator.transform = trasform;
    
    CGRect frame = _vIndicator.frame;
    NSLog(@"%@",NSStringFromCGRect(frame));
    _vIndicator.layer.anchorPoint= CGPointMake(0, 0.5);
    NSLog(@"%@",NSStringFromCGRect(_vIndicator.frame));
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        _vIndicator.frame = frame;
//    });
    _vIndicator.frame = frame;
    NSLog(@"%@",NSStringFromCGRect(_vIndicator.frame));
    //这里之后又有一个步骤让这个frame变成改变anchor之后的frame,不知道怎么回事.
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.vIndicator.frame = frame;
        NSLog(@"%@",NSStringFromCGRect(self.vIndicator.frame));
    });
    
    _tfName.delegate = self;
    
   

         _vAnswer.hidden = YES;
        _vView.hidden = NO;
    
    
}

- (void)viewDidLayoutSubviews {
    
    //假设一个view的layer.anchor是0.5,0.5 在父视图的位置是x0,y0
    //那么当调整一个view.layer.anchor之后,会调整view的frame,让新anchor点在父视图的位置不变.也就是调整view.center的值.所以自己应该如果要还原之前的frame只要还原frame就好了.
    
//    CGRect frame = _vIndicator.frame;
//    NSLog(@"%@",NSStringFromCGRect(frame));
//    _vIndicator.layer.anchorPoint= CGPointMake(0, 0.5);
//    NSLog(@"%@",NSStringFromCGRect(_vIndicator.frame));
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        _vIndicator.frame = frame;
//    });
//    _vIndicator.frame = frame;
//    NSLog(@"%@",NSStringFromCGRect(_vIndicator.frame));
    
}

#pragma mark 2 Accessor
#pragma mark 2.1 Setter
#pragma mark 2.2 Getter

#pragma mark 3 Interface

#pragma mark 4 Function
#pragma mark 4.1 NetworkFunction

#pragma mark 5 Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(_tfName.hasText) {
        _btnConfirm.enabled = YES;
    }
    [_tfName resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(toBeString.length) {
        _btnConfirm.enabled = YES;
    }
    else {
        _btnConfirm.enabled = NO;
    }
    return YES;
}


#pragma mark 6 Event
#pragma mark 6.1 ButtonEvent

- (IBAction)clickViewBtn:(id)sender {
//    UIView *askView = [[[NSBundle mainBundle]loadNibNamed:@"MainViewController" owner:nil options:nil]lastObject];
    _btnConfirm.enabled = NO;
//    [GaDisplayManager displayView:_vAsk inSuperview:self.view withMaskView:YES corerRadius:20 autoUndisplayDelay:0 backgroundColorAlpha:1];
//    return;
    
    _vView.hidden = YES;
    __block int count = 0;
    __block CGFloat speed = 0;
    __block CGFloat angle = 0;
    //1s钟40下, 6秒动画,2秒加速,2秒匀速,2秒减速.
    CGFloat speedUpTime = 2;
    CGFloat speedStaticTime = 2.1;
    CGFloat speedDownTime = 2;
    CGFloat framePerSec = 40;
    [NSTimer scheduledTimerWithTimeInterval:1/framePerSec repeats:YES block:^(NSTimer * _Nonnull timer) {
        count++;
        if(count<speedUpTime*framePerSec) {
            speed +=0.01;
            angle += speed;
            
        }
        else if(count <speedUpTime*framePerSec+speedStaticTime*framePerSec) {
            angle += speed;
        }
        else if(count < speedUpTime*framePerSec+speedStaticTime*framePerSec +speedDownTime*framePerSec) {
            speed -= 0.01;
            angle += speed;
        }
        else {
            [timer invalidate];
            timer = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [GaDisplayManager displayView:self.vAsk inSuperview:self.view withMaskView:YES corerRadius:20 autoUndisplayDelay:0 backgroundColorAlpha:1];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.tfName becomeFirstResponder];
                });
                
            });
            
        }
        NSLog(@"count is :%d,speed is %.2f,angle is %.2f",count,speed,angle);
        CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
        self.vIndicator.transform = transform;
    }];
    

    
    
}

//如何实现旋转动画,最靠谱的方式还是用定时器,然后用触发次数驱动
//分为加速,匀速,减速3个阶段.
- (IBAction)textFieldEndEditing:(id)sender {
    
    
}

- (IBAction)clickConfirmBtn:(id)sender {
    [GaDisplayManager undisplayView:_vAsk animateWithType:1];
    _lbName.text = _tfName.text;
    _lbAnswerName.text = _tfName.text;
    NSString *name = _tfName.text;
    _vAnswer.hidden = NO;
}


#pragma mark 6.2 NotificationEvent

#pragma mark 6.3 KVOEvent

@end
