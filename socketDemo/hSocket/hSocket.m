//
//  hSocket.m
//  socketDemo
//
//  Created by Admin on 2016/12/14.
//  Copyright © 2016年 侯迎春. All rights reserved.
//

#import "hSocket.h"
#import <sys/socket.h>//socket相关
#import <netinet/in.h>//internet相关
#import <arpa/inet.h>//地址解析协议相关

static int  ipDomain;
static int  skType;

@interface hSocket()

/// 连接 socket
@property (nonatomic, assign) int clientSocket;

@end

@implementation hSocket

// 开始连接
- (BOOL)startConnection {
    self.clientSocket = socket(ipDomain,skType , 0);
    
    //大于0 成功
    if (self.clientSocket > 0) {
        NSLog(@"socket create success %d",self.clientSocket);
    }
    else{
        NSLog(@"socket create error");
        return  NO;
    }
    
    //connection 连接到“服务器”
    /**
     参数
     1> 客户端socket
     2> 指向数据结构sockaddr的指针，其中包括目的端口和IP地址
     服务器的"结构体"地址，C语言没有对象
     3> 结构体数据长度
     返回值
     0 成功/其他 错误代号，非0即真
     */

    
    
    struct sockaddr_in severAddress;
    // IPV4 - 协议
    severAddress.sin_family = ipDomain;
    // inet_addr函数可以把ip地址转换成一个整数
    severAddress.sin_addr.s_addr = inet_addr(self.targetSeverIP.UTF8String);
    // 端口小端存储
    severAddress.sin_port = htons([self.targetSeverPort intValue]);
    
    int result = connect(self.clientSocket, (const struct sockaddr *)&severAddress, sizeof(severAddress));
    
    return (result == 0);
}

///  发送和接收字符串
///  只跟 socket 打交道，和界面无关
- (NSString *)sendAndRecv:(NSString *)message {
    // send发送
    /**
     参数
     1> 客户端socket
     2> 发送内容地址 void * == id
     3> 发送内容长度
     4> 发送方式标志，一般为0
     返回值
     如果成功，则返回发送的字节数，失败则返回SOCKET_ERROR
     */
    
    ssize_t sendLen = send(self.clientSocket, message.UTF8String, strlen(message.UTF8String), 0);
    NSLog(@"%ld", sendLen);
    
    // recv 接收 - 几乎所有的网络访问，都是有来有往的
    /**
     参数
     第一个int :创建的socket
     void *：接收内容的地址
     size_t：接收内容的长度
     第二个int.：接收数据的标记 0，就是阻塞式，一直等待服务器的数据
     返回值 接收到的数据长度
     */
    // unsigned char，字符串的数组
    uint8_t buffer[1024];
    
    ssize_t recvLen = recv(self.clientSocket, buffer, sizeof(buffer), 0);
    
    // 从buffer中读取服务器发回的数据
    // 按照服务器返回的长度，从 buffer 中，读取二进制数据，建立 NSData 对象
    NSData *data = [NSData dataWithBytes:buffer length:recvLen];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}


///  断开连接
- (void)disConnection {
    close(self.clientSocket);
}



- (void)setSocketType:(SOCKETTYPE)socketType
{
    _socketType = socketType;
    switch (socketType) {
        case SOCKET_TYPE_TCP:
            skType = SOCK_STREAM;
            break;
            
        default:
            skType = SOCK_DGRAM;
            break;
    }
}

- (void)setIpDomainType:(IPDOMATYPE)ipDomainType
{
    _ipDomainType = ipDomainType;
    switch (ipDomainType) {
        case IP_DOMA_V6:
            ipDomain = AF_INET6;
            break;
            
        default:
            ipDomain = AF_INET;
            break;
    }
}

@end
