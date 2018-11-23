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

+ (instancetype)shareManager;

/**
   return YES if the center device Bluetooth is available
 */
@property (nonatomic, assign)BOOL enableBluetooth;

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

/** callback when find targer device,but do not connect */
@property (nonatomic, copy)void(^scanTargetDevice)(BOOL found);

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

- (void)getLife:(ResultCmd)result;

- (void)backups:(ResultCmd)result;

- (void)get_Status:(ResultCmd)result;

- (void)setPhoneName:(NSString *)name result:(ResultCmd)result;

/**
 hardware update
 @param filePath 文件路径(must available like [NSData dataWithContentsOfFile:filePath])
 */
- (void)startProgramUpdate:(NSString *)filePath updateprogress:(UpdateProgress)progress;

@end

NS_ASSUME_NONNULL_END
