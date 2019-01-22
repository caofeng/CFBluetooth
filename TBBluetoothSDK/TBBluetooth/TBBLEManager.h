//
//  TBBluetoothDeviceManager.h
//  TBBluetoothSDK
//
//  Created by Topband on 2018/11/15.
//  Copyright © 2018年 深圳拓邦股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBConfiguration.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

typedef void(^Complemention)(NSError *error);
typedef void(^ResultCmd)(NSData *data,NSError *error);
typedef void(^UpdateProgress)(NSData *data,CGFloat progress,NSError *error,BOOL updating);

NS_ASSUME_NONNULL_BEGIN

@interface TBBLEManager : NSObject

/** init */
+ (void)initSDK;

- (void)setLogOpen:(BOOL)open;

+ (instancetype)shareManager;

/**
   return YES if the center device Bluetooth is available
 */
@property (nonatomic, assign)BOOL isBluetoothEnabled;

/**
    connected Peripheral
 */
@property (nonatomic, strong)CBPeripheral   *connectedPeripheral;

/** Scan all Bluetooth devices around you */
- (void)startScanAllDevices;

/** stop Scan */
- (void)stopScanDevices;

/**
 return State of Peripheral connect
 */
@property (nonatomic, assign)TBDeviceConnectState connectState;

/** callback when scan Bluetooth */
@property (nonatomic, copy)void(^listPairFoodProcessors)(NSArray< CBPeripheral*> *deviceList);

/** listen to the Bluetooth system setting (enabled / disabled) and call a callback if that changes. */
@property (nonatomic, copy)void(^bluetoothSettingChanged)(BOOL enabled);

/** callback when find targer device,but do not connect */
@property (nonatomic, copy)void(^scanTargetDevice)(BOOL found);

/**  a callback that notify the app when the connection state changes */
@property (nonatomic, copy)void(^connectStateChanged)(TBDeviceConnectState connectState);

/** connect Device */
- (void)connectResult:(Complemention)complemention;

/** disconnect Device */
- (void)disconnect;


/** ------ business Method ------*/

- (void)keyOk:(ResultCmd)result;

- (void)keyRight:(ResultCmd)result;

- (void)keyRDown:(ResultCmd)result;

- (void)keyLDown:(ResultCmd)result;

- (void)keyLeft:(ResultCmd)result;

- (void)keyBack:(ResultCmd)result;

- (void)keyStop:(ResultCmd)result;

- (void)keyAuto:(ResultCmd)result;

- (void)keyPulse:(ResultCmd)result;

- (void)keyPulseUp:(ResultCmd)result;

- (void)getVersion:(ResultCmd)result;

- (void)set_Status:(Byte *)status result:(ResultCmd)result;

/**
 @param interval  Unit ms--default:750，not too litter, >=600 is perfect
 */
- (void)get_StatusWithInterval:(NSTimeInterval)interval callback:(ResultCmd)callback;
/**
 @param interval  Unit ms--default:750
 */
- (void)getLifeWithInterval:(NSTimeInterval)interval callback:(ResultCmd)callback;
/**
 @param interval  Unit ms--default:750
 */
- (void)backupsWithInterval:(NSTimeInterval)interval callback:(ResultCmd)callback;

/**
 @param name  length must < 1 byte
 */
- (void)setPhoneName:(NSString *)name result:(ResultCmd)result;

/**
 fireware update
 @param filePath 文件路径(must available like [NSData dataWithContentsOfFile:filePath])
 */
- (void)startProgramUpdate:(NSString *)filePath updateprogress:(UpdateProgress)progress;

/** cancel fireware update */
- (void)cancelProgamUpdate;

@end

NS_ASSUME_NONNULL_END
