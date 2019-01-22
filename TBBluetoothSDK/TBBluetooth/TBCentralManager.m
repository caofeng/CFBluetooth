//
//  TBCentralManager.m
//  TBBluetoothSDK
//
//  Created by Topband on 2018/11/15.
//  Copyright © 2018年 深圳拓邦股份有限公司. All rights reserved.
//

#import "TBCentralManager.h"

@interface TBCentralManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>

// 中心管理者(管理设备的扫描和连接)
@property (nonatomic, strong) CBCentralManager *centralManager;
// 存储的外部蓝牙设备
@property (nonatomic, strong) NSMutableArray<CBPeripheral *> *peripherals;

// 蓝牙设备的服务
@property (nonatomic, strong) CBService *service;
//蓝牙设备服务的特征,无回应
@property (nonatomic, strong) CBCharacteristic  *characNoReponse;
//蓝牙设备服务的特征,有回应
@property (nonatomic, strong) CBCharacteristic  *characNotifyReponse;

@property (nonatomic, copy) sendDataCallback result;

@end

@implementation TBCentralManager

- (CBCentralManager *)centralManager {
    
    if (!_centralManager) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    }
    return _centralManager;
}

- (NSMutableArray<CBPeripheral *> *)peripherals {
    if (!_peripherals) {
        _peripherals = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _peripherals;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self centralManager];
        self.autoConnectDevice = YES;
        self.connectState = TBDeviceConnectStateDisconnect;
    }
    return self;
}

- (void)scanallDevices {
    
    [self.centralManager stopScan];
    self.connectState = TBDeviceConnectStateDisconnect;
    [self.peripherals removeAllObjects];
    self.autoConnectDevice = YES;
    
    if (self.enableBluetooth) {
        //扫描所有设备-可以在此对扫描的设备过滤
        [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:[NSNumber numberWithBool:NO]}];
        //可以在此设置超时停止扫描。。。
    }
}

- (void)stopScan {
    [self.centralManager stopScan];
}

- (void)connectDevice {
    self.autoConnectDevice = YES;
    [self.centralManager stopScan];
    [self connectDevice:nil];
}

- (void)connectDevice:(CBPeripheral *__nullable)devicer{
    
    CBPeripheral *peripher = nil;
    NSString *bluetoothname = kBlePeripheralNamePre;
    if (devicer) {
        bluetoothname = devicer.name;
    }
    for (CBPeripheral *peri in self.peripherals) {
        if ([self isTargetDevice:peri]) {
            peripher = peri;
        }
    }
    //...在此连接设备
    if (peripher) {
        self.cbPeripheral = peripher;
        self.connectState = TBDeviceConnectStateConnecting;
        [self.centralManager connectPeripheral:self.cbPeripheral options:nil];
    } else {
        //TBLog(@"no found target device");
    }
}

//写入数据
- (void)sendData:(NSData *)data result:(sendDataCallback)result {
    
    if (self.cbPeripheral && self.service && self.characNoReponse && self.enableBluetooth && self.characNotifyReponse) {
        self.result = nil;
        self.result = result;
        [self.cbPeripheral writeValue:data forCharacteristic:self.characNoReponse type:CBCharacteristicWriteWithoutResponse];
        [self.cbPeripheral setNotifyValue:YES forCharacteristic:self.characNotifyReponse];
        
    } else {
        NSString *str  = @"";
        if (!self.service) {
            str  = @"= data send fail by no service UUID FF00 =";
        } else if (!self.characNoReponse) {
            str  = @"= data send fail by no service UUID FF01 =";

        } else if (!self.characNotifyReponse) {
            str  = @"= data send fail by no service UUID FF02 =";
        }
        //[self printLog:str];
        //[[NSNotificationCenter defaultCenter]postNotificationName:@"ErrorInfo" object:nil userInfo:@{@"tip":str}];
    }
}

/** 断开连接 */
- (void)cancelConnect {
    
    self.autoConnectDevice = NO;
    self.connectState = TBDeviceConnectStateDisconnect;
    if (self.centralManager.isScanning) {
        [self.centralManager stopScan];
    }
    
    if (self.cbPeripheral != nil) {
        [self.centralManager cancelPeripheralConnection:self.cbPeripheral];
    }
}

- (void)clearAllDevice {
    [self.peripherals removeAllObjects];
    [self cancelConnect];
}

- (BOOL)enableBluetooth {
    
    if (@available(iOS 10.0, *)) {
        return self.centralManager.state == CBManagerStatePoweredOn;
    } else {
        return self.centralManager.state == CBCentralManagerStatePoweredOn;
    }
}

#pragma Mark -CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            TBLog(@"CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            TBLog(@"CBCentralManagerStatePoweredOn");
            break;
        case CBCentralManagerStateResetting:
            TBLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnauthorized:
            TBLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStateUnknown:
            TBLog(@"CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateUnsupported:
            TBLog(@"CBCentralManagerStateUnsupported");
            break;
            
        default:
            break;
    }
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(centralManagerDidUpdateState:)]) {
            [self.delegate centralManagerDidUpdateState:central];
        }
        
        //蓝牙打开可用，发个通知
        if (central.state == CBCentralManagerStatePoweredOn) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kTBBluetoothCentralDeviceStateONNotification object:@(central.state == CBCentralManagerStatePoweredOn)];
        }
        
        if (central.state != CBCentralManagerStatePoweredOn) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kTBBluetoothCentralDeviceStateOFFNotification object:@(central.state == CBCentralManagerStatePoweredOn)];
        }
}

/**
 扫描到设备
 @param central 中心管理者
 @param peripheral 扫描到的设备
 @param advertisementData 广告信息
 @param RSSI 信号强度
 */

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    //已经扫描到外部设备--显示出来
    if (![self.peripherals containsObject:peripheral]) {
        [self.peripherals addObject:peripheral];
        //扫描到目标设备
        if ([self isTargetDevice:peripheral]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(scanTargetDevice:)]) {
                [self.delegate scanTargetDevice:peripheral];
            }
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDiscoverDeviceList:)]) {
            [self.delegate didDiscoverDeviceList:self.peripherals];
        }
    }
}

/**
 连接失败-重连
 @param central 中心管理者
 @param peripheral 连接失败的设备
 @param error 错误信息
 */

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    self.connectState = TBDeviceConnectStateDisconnect;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFailToConnectError:)]) {
        [self.delegate didFailToConnectError:error];
    }
    //找到所需要的外部设备
    self.cbPeripheral = peripheral;
    //开始链接
    self.connectState = TBDeviceConnectStateConnecting;
    [self.centralManager connectPeripheral:self.cbPeripheral options:nil];
    
}

/**
 连接断开--自动重连
 @param central 中心管理者
 @param peripheral 连接断开的设备
 @param error 错误信息
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    self.connectState = TBDeviceConnectStateDisconnect;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDisconnectError:)]) {
        [self.delegate didDisconnectError:error];
    }
    
    if (self.autoConnectDevice) {
        self.connectState = TBDeviceConnectStateConnecting;
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

/**
 连接成功
 @param central 中心管理者
 @param peripheral 连接成功的设备
 */

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    self.connectState = TBDeviceConnectStateConnected;
    self.cbPeripheral = peripheral;
    peripheral.delegate = self;
    // services:传入nil代表扫描所有服务
    [peripheral discoverServices:nil];
    // 设置设备的代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(didConnect)]) {
        [self.delegate didConnect];
    }
}

#pragma Mark - CBPeripheralDelegate

/**
 扫描到服务
 @param peripheral 服务对应的设备
 @param error 扫描错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        if ([self isTargetService:service]) {
            self.service = service;
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

/**
 扫描到对应的特征
 @param peripheral 设备
 @param service 特征对应的服务
 @param error 错误信息
 */

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    for (CBCharacteristic *character in service.characteristics) {
        if ([self isTargetNoResponseCharacterise:character]) {
            self.characNoReponse = character;
        }
        if ([self isTargetResponseCharacterise:character]) {
            self.characNotifyReponse = character;
        }
    }
}

/**
 根据特征读到数据---向蓝牙设备写入数据之后的回调
 @param peripheral 读取到数据对应的设备
 @param characteristic 特征
 @param error 错误信息
 */

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
    [self.cbPeripheral readValueForCharacteristic:characteristic];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (self.result) {
        NSData *data = characteristic.value;
        self.result(data, error);
    } else {
        TBLog(@"==No response==");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
}

#pragma Mark -- AdditionsMethod

//判断目标设备
- (BOOL)isTargetDevice:(CBPeripheral *)peripheral {
    if ([peripheral.name hasPrefix:kBlePeripheralNamePre]) {
        return YES;
    }
    
    return NO;
}
//判断目标设备的目标服务
- (BOOL)isTargetService:(CBService *)service {
    
    NSString *uuid = service.UUID.UUIDString;
    if ([uuid isEqualToString:kWriteServerUUID]) {
        return YES;
    }
    return NO;
}

//判断目标设备的目标服务的目标特征--无响应
- (BOOL)isTargetNoResponseCharacterise:(CBCharacteristic *)characterise {

    NSString *uuid = characterise.UUID.UUIDString;
    if ([uuid isEqualToString:kWriteNOResponseCharacteristicUUID]) {
        return YES;
    }
    return NO;
}

//判断目标设备的目标服务的目标特征--有响应
- (BOOL)isTargetResponseCharacterise:(CBCharacteristic *)characterise {
    
    NSString *uuid = characterise.UUID.UUIDString;
    if ([uuid isEqualToString:kReadNotifyCharacteristicUUID]) {
        return YES;
    }
    return NO;
}

- (void)printLog:(NSString *)log {
    
    TBLog(@"%@",log);
}

@end
