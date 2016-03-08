//
//  UCCarouselView.h
//  UCCarouselView
//
//  Created by Uncle.Chen on 3/3/16.
//  Copyright © 2016 UC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCCarouselView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                    dataArray:(NSArray *)dataArray
           didSelectItemBlock:(void (^)(NSInteger didSelectItem))block;

- (instancetype)initWithFrame:(CGRect)frame
                    dataArray:(NSArray *)dataArray
                 timeInterval:(CGFloat)timeInterval
           didSelectItemBlock:(void (^)(NSInteger didSelectItem))block;

@end
