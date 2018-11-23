//
//  TBConfiguration.h
//  TBBluetoothSDK
//
//  Created by Topband on 2018/11/19.
//  Copyright © 2018年 深圳拓邦股份有限公司. All rights reserved.
//

#ifndef TBConfiguration_h
#define TBConfiguration_h


#ifdef DEBUG

#define TBLog(format, ...) printf("Class: <%s:(%d) > %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )

#else

#define TBLog(format, ...)

#endif

/** 蓝牙设备名称前缀 */
static NSString * const kBlePeripheralNamePre = @"cook expert";

static NSString * const kBlePeripheralIdentifier = @"237D682C-F638-7045-B8C7-94C5706FA54C";

static NSString * const kNotifyServerUUID = @"FF00";

static NSString * const kWriteServerUUID = @"FF00";


// --------
static NSString * const kReadNotifyCharacteristicUUID = @"FF02";
// --------
static NSString * const kWriteCharacteristicUUID = @"49535343-8841-43F4-A8D4-ECBE34729BB3";
// --------
static NSString * const kWriteNOResponseCharacteristicUUID = @"FF01";
// -------
static NSString * const kReadWriteNotiftCharacteristicUUID = @"49535343-ACA3-481C-91EC-D85E28A60318";


typedef enum : NSUInteger {
    TBManagerStateUnknown = 0,
    TBManagerStateResetting,
    TBManagerStateUnsupported,
    TBManagerStateUnauthorized,
    TBManagerStatePoweredOff,
    TBManagerStatePoweredOn,
} TBManagerState;

typedef enum : NSUInteger {
    /** 已断开 */
    TBDeviceConnectStateDisconnect = 0,
    /** 连接中 */
    TBDeviceConnectStateConnecting,
    /** 已连接 */
    TBDeviceConnectStateConnected,
    /** 连接状态未知 */
    TBDeviceConnectStateNone,
    
} TBDeviceConnectState;

/** 中心设备蓝牙打开 通知*/
static NSString * const kTBBluetoothCentralDeviceStateONNotification = @"kTBBluetoothCentralDeviceStateONNotification";

/** 中心设备蓝牙关闭(不可用状态) 通知*/
static NSString * const kTBBluetoothCentralDeviceStateOFFNotification = @"kTBBluetoothCentralDeviceStateOFFNotification";


#endif /* TBConfiguration_h */
