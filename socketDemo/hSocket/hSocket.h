//
//  hSocket.h
//  socketDemo
//
//  Created by Admin on 2016/12/14.
//  Copyright © 2016年 侯迎春. All rights reserved.
//


#import <Foundation/Foundation.h>

//ip域类型
typedef enum : NSUInteger {
    IP_DOMA_DEFAULT, //默认ipv4
    IP_DOMA_V6,      //ipV6
} IPDOMATYPE;

//socket类型
typedef enum : NSUInteger {
    SOCKET_TYPE_TCP,
    SOCKET_TYPE_UDP,
} SOCKETTYPE;

@interface hSocket : NSObject

// 连接的服务器地址
@property (nonatomic, strong) NSString *targetSeverIP;

// 连接的目标端口
@property (nonatomic, strong) NSString *targetSeverPort;

// ip域
@property (nonatomic, assign) IPDOMATYPE ipDomainType;

// socket类型  还将根据设置的类型 选择协议
@property (nonatomic, assign) SOCKETTYPE socketType;


// 启动通信 返回值是否连接
- (BOOL) startConnection;

@end
