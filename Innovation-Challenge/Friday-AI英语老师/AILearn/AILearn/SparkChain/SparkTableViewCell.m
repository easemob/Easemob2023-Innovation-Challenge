//
//  SparkTableViewCell.m
//  AiEdgeDemo
//
//  Created by pcfang on 6.5.23.
//

#import "SparkTableViewCell.h"

@interface SparkTableViewCell ()
@property (nonatomic, strong) UILabel * textLB;
@property (nonatomic, strong) UIImageView * bgIV;

@property (nonatomic, strong) NSLayoutConstraint * bgLeft;
@property (nonatomic, strong) NSLayoutConstraint * bgRight;
@end

@implementation SparkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bgIV];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell:(BOOL)isSpark text:(NSString *)content {
    self.textLB.text = content;
    [self.contentView removeConstraints:self.contentView.constraints];
    NSMutableArray * constraints = [NSMutableArray array];
    if (isSpark) {
        self.bgLeft.constant = 15;
        UIImage * image = [UIImage imageNamed:@"other.png"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height / 2, image.size.width / 2, image.size.height / 2, image.size.width / 2)];
        self.bgIV.image = image;
        NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:self.bgIV attribute:(NSLayoutAttributeLeft) relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10];
        [constraints addObject:left];
       
    } else {
        self.bgRight.constant = -15;
        UIImage * image = [UIImage imageNamed:@"me.png"];
        image =[image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height / 2, image.size.width / 2, image.size.height / 2, image.size.width / 2)];
        self.bgIV.image = image;
        NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:self.bgIV attribute:(NSLayoutAttributeRight) relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];
        [constraints addObject:right];
    }
    
    [self.bgIV setNeedsUpdateConstraints];
    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:self.bgIV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:2.0 / 3 constant:0];
    [constraints addObject:width];
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:self.bgIV attribute:(NSLayoutAttributeTop) relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5];
    [constraints addObject:top];
    NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:self.bgIV attribute:(NSLayoutAttributeBottom) relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5];
    [constraints addObject:bottom];
    [self.contentView addConstraints:constraints];
    
    [self.contentView layoutIfNeeded];
}

- (UILabel *)textLB {
    if (!_textLB) {
        _textLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLB.font = [UIFont systemFontOfSize:16];
        _textLB.textColor = [UIColor darkTextColor];
        _textLB.translatesAutoresizingMaskIntoConstraints = false;
        _textLB.numberOfLines = 0;
        _textLB.layer.cornerRadius = 5.0f;
        _textLB.layer.masksToBounds = true;
    }
    return _textLB;
}


- (UIImageView *)bgIV {
    if(!_bgIV) {
        _bgIV = [[UIImageView alloc] init];
        _bgIV.translatesAutoresizingMaskIntoConstraints = false;
        [_bgIV addSubview:self.textLB];
        
        NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:self.textLB attribute:NSLayoutAttributeLeft relatedBy:(NSLayoutRelationEqual) toItem:_bgIV attribute:(NSLayoutAttributeLeft) multiplier:1.0 constant:5];
        self.bgLeft = left;
        NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:self.textLB attribute:NSLayoutAttributeRight relatedBy:(NSLayoutRelationEqual) toItem:_bgIV attribute:(NSLayoutAttributeRight) multiplier:1.0 constant:-5];
        self.bgRight = right;
        NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:self.textLB attribute:NSLayoutAttributeTop relatedBy:(NSLayoutRelationEqual) toItem:_bgIV attribute:(NSLayoutAttributeTop) multiplier:1.0 constant:5];
        NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:self.textLB attribute:NSLayoutAttributeBottom relatedBy:(NSLayoutRelationEqual) toItem:_bgIV attribute:(NSLayoutAttributeBottom) multiplier:1.0 constant:-5];
        
        
        
        
        [_bgIV addConstraints:@[left,top,right,bottom]];
    }
    
    return _bgIV;
}

@end
