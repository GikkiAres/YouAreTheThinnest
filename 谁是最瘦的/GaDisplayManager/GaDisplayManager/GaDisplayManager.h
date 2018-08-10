//
//  GaDisplayManager.h
//  GaAlarm
//
//  Created by GikkiAres on 2018/5/11.
//  Copyright © 2018 GikkiAres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+GaUtility.h"
#import "GaMessageView.h"
#import "GaActivityView.h"
#import "GaActivityMessageView.h"
#import <objc/runtime.h>
#import "GaLogMacro.h"

@interface GaDisplayManager : NSObject

+(GaDisplayManager *)sharedManager;

+ (void)displayMessage:(NSString *)message inSuperview:(UIView *)superview;

+ (void)displayActivityViewInSuperview:(UIView *)superview;
+(void)displayActivityViewInSuperview:(UIView *)superview withStyle:(int)style;
+ (void)undisplayActivityViewInSuperview:(UIView *)superview;

+(void)displayView:(UIView *)view inSuperview:(UIView *)superView withMaskView:(BOOL)flag corerRadius:(CGFloat)cornerRadius autoUndisplayDelay:(NSTimeInterval)delay backgroundColorAlpha:(CGFloat)alpha;
+ (void)undisplayView:(UIView *)view animateWithType:(int)type;
@end
