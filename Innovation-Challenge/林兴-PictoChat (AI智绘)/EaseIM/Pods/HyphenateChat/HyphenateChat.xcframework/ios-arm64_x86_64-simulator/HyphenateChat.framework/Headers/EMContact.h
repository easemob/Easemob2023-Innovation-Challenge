//
//  EMContact.h
//  HyphenateChat
//
//  Created by li xiaoming on 2023/8/30.
//  Copyright © 2023 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  \~chinese
 *  联系人信息。
 *
 *  \~english
 *  The contact object.
 */
@interface EMContact : NSObject <NSCoding>

/**
 *  \~chinese
 *  联系人用户Id。
 *
 *  \~english
 *  The contact userId.
 */
@property (nonatomic,strong,readonly) NSString* _Nonnull userId;

/**
 *  \~chinese
 *  联系人备注。
 *
 *  \~english
 *  The contact remark.
 */
@property (nonatomic,strong) NSString* _Nullable remark;

/**
 *  \~chinese
 *  初始化联系人对象
 *
 *  @param userId  联系人用户Id
 *  @param remark  联系人备注
 *
 *  @return 联系人对象
 *
 *  \~english
 *  Initialize contact object
 *
 *  @param userId  The contact userId
 *  @param remark  The contact remark
 *
 *  @return Contact object
 */

- (instancetype)initWithUserId:(NSString* _Nonnull)userId remark:(NSString* _Nullable)remark;
@end
