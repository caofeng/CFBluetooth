//
//  TBCentralManager.h
//  TBBluetoothSDK
//
//  Created by Topband on 2018/11/15.
//  Copyright © 2018年 深圳拓邦股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TBConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^sendDataCallback)(NSData *data,NSError *error);

@protocol TBCentralManagerDelegate <NSObject>

- (void)centralManagerDidUpdateState:(CBCentralManager *)central;

@optional

/** callback when Scan device */
- (void)didDiscoverDeviceList:(NSArray<CBPeripheral *> *)deviceList;

/** callback when find target device */
- (void)scanTargetDevice:(CBPeripheral *)peripheral;

/** callback when connect device fail */
- (void)didFailToConnectError:(NSError *)error;

/** callback when disconnected device */
- (void)didDisconnectError:(NSError *)error;

/** callback when connect device success */
- (void)didConnect;

@end

@interface TBCentralManager : NSObject

@property (nonatomic, weak)id<TBCentralManagerDelegate> delegate;

/** target device  */
@property (nonatomic, strong) CBPeripheral *cbPeripheral;
/**
 return YES if the center device Bluetooth is available
 */
@property (nonatomic, assign)BOOL enableBluetooth;

@property (nonatomic, assign)BOOL autoConnectDevice;

/**
 return State of Peripheral connect
 */
@property (nonatomic, assign)TBDeviceConnectState connectState;

/** Scan devices */
- (void)scanallDevices;

- (void)stopScan;

/** connect target device */
- (void)connectDevice;

/** connect target device */
- (void)connectDevice:(CBPeripheral *__nullable)devicer;

/** send data to device and callback */
- (void)sendData:(NSData *)data result:(sendDataCallback)result;

/** disconnect */
- (void)cancelConnect;

@end

NS_ASSUME_NONNULL_END
