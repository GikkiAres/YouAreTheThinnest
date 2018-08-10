//
//  GaMessageLayer.m
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2018/5/31.
//  Copyright © 2018 GikkiAres. All rights reserved.
//

#import "GaMessageLayer.h"

@implementation GaMessageLayer

- (id)initWithLayer:(id)layer {
    if ((self = [super init])) {
//        _caption = @"";
    }
    return self;
}
+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"title"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

- (void)drawInContext:(CGContextRef)ctx {
    
    //将CGContextRef绘制环境压入栈中,成为当前环境.
    UIGraphicsPushContext(ctx);

    CGRect f = self.bounds;
    CGRect s = f;
    s.origin.y -= 1;
    //对当前环境进行操作,当前环境是环境栈中的第一个.
    //这个绘制只能水平居中,不能竖直居中???
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentCenter;
    NSMutableDictionary *dic = [@{
                          NSParagraphStyleAttributeName:style,
                          NSFontAttributeName:self.font,
                          NSForegroundColorAttributeName:[UIColor blackColor]
                          } mutableCopy];
    
//    [[UIColor blackColor] set];
    [_title drawInRect:f withAttributes:dic];

//    [[UIColor whiteColor] set];
    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [_title drawInRect:s withAttributes:dic];

    UIGraphicsPopContext();
}


@end
