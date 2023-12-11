//
//  SparkTableViewCell.h
//  AiEdgeDemo
//
//  Created by pcfang on 6.5.23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SparkTableViewCell : UITableViewCell
- (void)updateCell:(BOOL)isSpark text:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
