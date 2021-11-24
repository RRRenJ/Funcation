//
//  JPLLiveWSResponse.h
//  jper
//
//  Created by RRRenJ on 2020/6/16.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPLLiveWSMessageInfo : NSObject

@property (nonatomic, copy) NSString *  live_id;

@property (nonatomic, copy) NSString *  num;

@property (nonatomic, copy) NSString *  nickname;

@property (nonatomic, copy) NSString *  message;


@end


@interface JPLLiveWSMessage : NSObject

@property (nonatomic, copy) NSString *  message_id;

@property (nonatomic, copy) NSString *  message_type;

@property (nonatomic, strong) JPLLiveWSMessageInfo *  message_info;

@end

@interface JPLLiveWSResponse : NSObject

@property (nonatomic, copy) NSString *  sendUserId;

@property (nonatomic, assign) NSInteger  code;

@property (nonatomic, copy) NSString *  msg;

@property (nonatomic, strong) JPLLiveWSMessage *  data;

@end





NS_ASSUME_NONNULL_END
