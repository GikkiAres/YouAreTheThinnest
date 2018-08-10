//
//  GaMessageLayer.h
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2018/5/31.
//  Copyright © 2018 GikkiAres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GaMessageLayer : CALayer

@property (nonatomic, retain) NSString *title;
@property (nonatomic,strong) UIFont *font;

@end

