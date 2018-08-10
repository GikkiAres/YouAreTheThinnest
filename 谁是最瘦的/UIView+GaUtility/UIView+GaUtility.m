//
//  UIView+GaUtility.m
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2018/5/31.
//  Copyright © 2018 GikkiAres. All rights reserved.
//

#import "UIView+GaUtility.h"

@implementation UIView (GaUtility)

@end

@implementation UIView (GaGeometryUtility)

- (CGPoint)selfCenter {
    CGPoint pt = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);
    return pt;
}

@end
