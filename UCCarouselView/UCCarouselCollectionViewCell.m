//
//  UCCarouselCollectionViewCell.m
//  UCCarouselView
//
//  Created by Uncle.Chen on 3/3/16.
//  Copyright © 2016 UC. All rights reserved.
//

#import "UCCarouselCollectionViewCell.h"
#import <WebKit/WebKit.h>

@interface UCCarouselCollectionViewCell () <WKUIDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation UCCarouselCollectionViewCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadImageView];
    }
    return self;
}

#pragma mark - Accessor

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = _image;
}

#pragma mark - UI

- (void)loadImageView {
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.imageView];
    }
}

@end
