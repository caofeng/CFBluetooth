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

/** Company  do not motify */
static NSString * const kBlePeripheralNamePre = @"cook expert";

static NSString * const kWriteServerUUID = @"FFF0";
// --------
static NSString * const kReadNotifyCharacteristicUUID = @"FFF4";
// --------
static NSString * const kWriteNOResponseCharacteristicUUID = @"FF01";
// -------
static NSString * const kWriteCharacteristicUUID = @"FFF5";


typedef enum : NSUInteger {
    TBManagerStateUnknown = 0,
    TBManagerStateResetting,
    TBManagerStateUnsupported,
    TBManagerStateUnauthorized,
    TBManagerStatePoweredOff,
    TBManagerStatePoweredOn,
} TBManagerState;

typedef enum : NSUInteger {
    /** disconnect */
    TBDeviceConnectStateDisconnect = 0,
    /** connecting */
    TBDeviceConnectStateConnecting,
    /** connected */
    TBDeviceConnectStateConnected,
    /** unknow */
    TBDeviceConnectStateNone,
    
} TBDeviceConnectState;

/** mobile open buletooth setting Notification*/
static NSString * const kTBBluetoothCentralDeviceStateONNotification = @"kTBBluetoothCentralDeviceStateONNotification";

//** mobile close buletooth setting Notification*/
static NSString * const kTBBluetoothCentralDeviceStateOFFNotification = @"kTBBluetoothCentralDeviceStateOFFNotification";


#endif /* TBConfiguration_h */
