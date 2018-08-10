//
//  GaDisplayManager.m
//  GaAlarm
//
//  Created by GikkiAres on 2018/5/11.
//  Copyright © 2018 GikkiAres. All rights reserved.
//

#import "GaDisplayManager.h"


//用于给ActivityView的superview关联的key.每个ActivityView需要关联.
static int ActivityViewKey;
static int DisplayNumberKey;

//MaskView给每个有maskView的MessageView或者ActivityView关联maskView.
static int MaskViewKey;


//控制MessageView和ActivityView的背景颜色的透明度
#define DisplayedViewBackgroudAlpha 0.5
#define MaskViewBackgroudAlpha 0.1

@interface GaDisplayManager()

@property (nonatomic,strong) UIView *displayedView;
@property (nonatomic,strong) UIButton *maskView;

@property (nonatomic,assign) CGFloat wScreen;
@property (nonatomic,assign) CGFloat hScreen;


@end



@implementation GaDisplayManager

+ (GaDisplayManager *)sharedManager {
    static GaDisplayManager * sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[GaDisplayManager alloc]init];
        [sharedManager commonInit];
    });
    return sharedManager;
}


- (void)commonInit {
    _maskView = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _wScreen = [UIScreen mainScreen].bounds.size.width;
    _hScreen = [UIScreen mainScreen].bounds.size.height;
}


#pragma mark Interface
#pragma mark Inner Interface
+ (void)makeConerRaius:(CGFloat)cornerRadius withView:(UIView *)view {
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
}
#pragma mark Outer Interface

//MessageView,是一个view可以显示多个
//ActivityView,是一个view只显示一次.
#pragma mark 显示MessageView
+(void)displayMessage:(NSString *)message inSuperview:(UIView *)superview{
    //view只显示内容.展示相关的全部由展示系统控制.
    
    //创建view,仅仅考虑view的内容.不需要考虑显示样式.
    GaMessageView *messageView = [GaMessageView messageViewWithMessage:message andFontSize:20];
    
    //显示view,并控制显示样式.
    [self displayView:messageView inSuperview:superview withMaskView:NO corerRadius:10 autoUndisplayDelay:2 backgroundColorAlpha:DisplayedViewBackgroudAlpha];
    
}

#pragma mark Display的核心方法.
//在superView上显示,如果要遮挡,也是遮挡整个superView.
//展示的逻辑手动指定,在哪里展示,关闭的逻辑只能是触碰或者定时器了.
//关闭的延迟,如果是0的话,就关闭自动隐藏的功能.
+(void)displayView:(UIView *)view inSuperview:(UIView *)superView withMaskView:(BOOL)flag corerRadius:(CGFloat)cornerRadius autoUndisplayDelay:(NSTimeInterval)delay backgroundColorAlpha:(CGFloat)alpha {
    //确定要不要遮挡其它部分.
    if(flag) {
        UIView *maskView = [[UIView alloc]initWithFrame:superView.bounds];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:MaskViewBackgroudAlpha];
        [superView addSubview:maskView];
        [maskView addSubview:view];
        view.center = maskView.selfCenter;
        
        objc_setAssociatedObject(view, &MaskViewKey, maskView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        [superView addSubview:view];
        view.center = superView.selfCenter;
    }
    
    //圆角效果
    [self makeConerRaius:cornerRadius withView:view];
    
    //背景色透明效果
    UIColor *c = view.backgroundColor;
    c = [c colorWithAlphaComponent:alpha];
    view.backgroundColor = c;
    
    //阴影效果
    //常用的设置阴影的方法.
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowRadius = 8.0;
    view.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    view.layer.shadowOpacity = 0.4;
    
    //动画效果
    [self view:view animateWithType:1];
    
    //这个view的相关信息,只能保存在这个view本身上.
    
    //配置定时器用来关闭.怎么判断这个timer有没有被释放???
    if(delay != 0) {
        [NSTimer scheduledTimerWithTimeInterval:delay repeats:NO block:^(NSTimer * _Nonnull timer) {
            [timer invalidate];
            [self undisplayView:view animateWithType:1];
        }];
    }
}

#pragma mark 关闭DisplayedView和MaskView的核心方法.
+ (void)undisplayView:(UIView *)view animateWithType:(int)type {
    [UIView animateWithDuration:0.2 animations:^{
        view.transform = CGAffineTransformMakeScale(1.4, 1.4);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        UIView *maskView = objc_getAssociatedObject(view, &MaskViewKey);
        if(maskView) {
            [maskView removeFromSuperview];
            objc_setAssociatedObject(view, &MaskViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }];
}

#pragma mark 动画效果
+ (void)view:(UIView *)view animateWithType:(int)type{
    view.transform = CGAffineTransformMakeScale(1.4, 1.4);
    view.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        view.transform = CGAffineTransformIdentity;
        view.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 展示Activity;
//0是默认有message的activityView.
+ (void)displayActivityViewInSuperview:(UIView *)superview {
    [self displayActivityViewInSuperview:superview withStyle:0];
}

+(void)displayActivityViewInSuperview:(UIView *)superview withStyle:(int)style {
    UIView *activityView = nil;
    switch (style) {
        case 0:{
            activityView = [GaActivityMessageView activityMessageViewWithMessage:@"please wait ..." andFontSize:20];
            break;
        }
        default:{
            activityView = [GaActivityView activityView];
            break;
        }
    }
    
    [self displayActivityView:activityView inSuperview:superview];
}



#pragma mark 展示ActivityView...
//控制activityView的displaynum.然后显示.
+ (void)displayActivityView:(UIView *)activityView inSuperview:(UIView *)superview {
    
    NSNumber *numDisplay = objc_getAssociatedObject(superview, &DisplayNumberKey);
    if(!numDisplay) {
        
        //当前view没有展示activityView.设置展示数为1,进行关联并展示.
        numDisplay = @(1);
        objc_setAssociatedObject(superview, &DisplayNumberKey,numDisplay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(superview, &ActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self displayView:activityView inSuperview:superview withMaskView:YES corerRadius:10 autoUndisplayDelay:0 backgroundColorAlpha:DisplayedViewBackgroudAlpha];
        
        GaLog(GaLogLevelGaDisplay,@"DisplayCount after display is :%@,display",numDisplay);
        
    }
    else {
        
        //当前view已经在展示activityView了.只将count数+1,更新关联就好了.
        NSInteger count = numDisplay.integerValue;
        count++;
        numDisplay = @(count);
        objc_setAssociatedObject(superview, &DisplayNumberKey,numDisplay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        GaLog(GaLogLevelGaDisplay,@"DisplayCount after display is :%@,continue display",numDisplay);
    }
}


#pragma mark 不展示Acitivity
//控制activityView的displaynum.然后undisplay
+ (void)undisplayActivityViewInSuperview:(UIView *)superview {
    
    NSNumber *numDisplay = objc_getAssociatedObject(superview, &DisplayNumberKey);
    //如果没有numDisplay,那就不用操作了.因为本来就没有.
    if(numDisplay) {
        NSInteger count = numDisplay.integerValue;
        //-1后,只可能是正数或者是0.
        count--;
        numDisplay = @(count);
        if(count==0) {

            //首先隐藏ActivityView
            UIView *activityView = objc_getAssociatedObject(superview, &ActivityViewKey);
            [self undisplayView:activityView animateWithType:1];


            //数量为0,隐藏,并且全部取消关联
            objc_setAssociatedObject(superview, &ActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(superview, &DisplayNumberKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            GaLog(GaLogLevelGaDisplay,@"DisplayCount after undisplay is :%@,hide",numDisplay);
        }
        else {
            // 正数,就减一操作,然后更新num就好.
            objc_setAssociatedObject(superview, &DisplayNumberKey, numDisplay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            GaLog(GaLogLevelGaDisplay,@"DisplayCount after undisplay is :%@,continue display",numDisplay);
        }
    }

    else {
        GaLog(GaLogLevelGaDisplay,@"already undisplayed");
    }
}

#pragma mark 彻底不展示Activity
+ (void)undisplayActivityViewCompletelyInSuperview:(UIView *)superview {
    
    NSNumber *numDisplay = objc_getAssociatedObject(superview, &DisplayNumberKey);
    
    //没有numDisplay,就不用操作.
    if(numDisplay) {
        
        //首先隐藏ActivityView
        UIView *activityView = objc_getAssociatedObject(superview, &ActivityViewKey);
        [self undisplayView:activityView animateWithType:1];
        
        
        //然后全部取消关联
        objc_setAssociatedObject(superview, &ActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(superview, &DisplayNumberKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        numDisplay = @(0);
        
        GaLog(GaLogLevelGaDisplay,@"DisplayCount after undisplay is :%@",numDisplay);
        
    }
    else {
        GaLog(GaLogLevelGaDisplay,@"already undisplayed");
    }
}








@end

