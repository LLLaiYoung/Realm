//
//  RealmCell.m
//  Realm
//
//  Created by chairman on 16/5/13.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "RealmCell.h"
#import "HiSchool.h"
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
#define kSpacing 10
#define kAvatarWidth 60
@interface RealmCell()
@property (nonatomic, strong) UIImageView *avatarImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitle;
@end
@implementation RealmCell
- (UIImageView *)avatarImage
{
    if (!_avatarImage) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAvatarWidth, kAvatarWidth)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImage = imageView;
        imageView.layer.cornerRadius = kAvatarWidth/2;
        imageView.layer.masksToBounds = YES;
    }
    return _avatarImage;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarImage.frame) + kSpacing, CGRectGetMinY(self.avatarImage.frame), SCREEN_SIZE.width - kAvatarWidth - kSpacing, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel = label;
    }
    return _titleLabel;
}
- (UILabel *)subTitle
{
    if (!_subTitle) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), self.titleLabel.bounds.size.width, self.titleLabel.bounds.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        _subTitle = label;
    }
    return _subTitle;
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.avatarImage];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitle];
}
- (void)setHiSchool:(HiSchool *)hiSchool {
    _hiSchool = hiSchool;
    self.avatarImage.image = [UIImage imageWithData:hiSchool.avatar];
    self.titleLabel.text = hiSchool.title;
    self.subTitle.text = hiSchool.subTitle;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
