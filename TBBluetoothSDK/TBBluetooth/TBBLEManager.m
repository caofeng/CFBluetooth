//
//  TBBluetoothDeviceManager.m
//  TBBluetoothSDK
//
//  Created by Topband on 2018/11/15.
//  Copyright © 2018年 深圳拓邦股份有限公司. All rights reserved.
//

#import "TBBLEManager.h"
#import "TBCentralManager.h"

// Protocol constants
static const int PROTOCOL_SOH = 0x01;  //start of 128-byte data packet
static const int PROTOCOL_STX = 0x02;  // start of 1024-byte data packet
static const int PROTOCOL_EOT = 0x04;  // end of transmission
static const int PROTOCOL_ACK = 0x06; // acknowledge
static const int PROTOCOL_NAK = 0x15;
static const int PROTOCOL_CA = 0x18;
static const int PROTOCOL_C = 0x43;
static const int PROTOCOL_SOH_LEN = 128;
static const int PROTOCOL_STX_LEN = 1024;


@interface TBBLEManager ()<TBCentralManagerDelegate>

@property (nonatomic, strong) TBCentralManager *centralManager;

@property (nonatomic, copy)Complemention connectResult;
//当前已发送块数
@property (nonatomic, assign)NSInteger currentSendCount;
//正在固件升级
@property (nonatomic, assign)BOOL isUpdating;

@property (nonatomic, copy)UpdateProgress updateProgress;

@property (nonatomic, assign)NSTimeInterval updateInterval;

@end

@implementation TBBLEManager

+ (void)initSDK {
    [self shareManager];
}

+ (instancetype)shareManager {
    static TBBLEManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.centralManager = [[TBCentralManager alloc]init];
        self.centralManager.delegate = self;
    }
    return self;
}

- (void)startScanAllDevices {
    [self.centralManager scanallDevices];
}

- (void)stopScanDevices {
    [self.centralManager stopScan];
}

- (void)scanTargetDevice:(CBPeripheral *)peripheral {
    if (peripheral && self.scanTargetDevice) {
        self.scanTargetDevice(YES);
        self.connectedPeripheral = peripheral;
    }
}

- (void)connectResult:(Complemention)complemention {
    self.connectResult = complemention;
    [self.centralManager connectDevice];
}

- (void)disconnect {
    [self.centralManager cancelConnect];
}

- (BOOL)enableBluetooth {
    return self.centralManager.enableBluetooth;
}

- (TBDeviceConnectState)connectState {
    return self.centralManager.connectState;
}

#pragma Mark -- TBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    if (@available(iOS 10.0, *)) {
        if (central.state == CBManagerStatePoweredOn) {
            [self.centralManager scanallDevices];
        }
    } else {
        if (central.state == CBCentralManagerStatePoweredOn) {
            [self.centralManager scanallDevices];
        }
    }
}

- (void)didDiscoverDeviceList:(NSArray<CBPeripheral *> *)deviceList {
    if (self.listPairFoodProcessors) {
        self.listPairFoodProcessors(deviceList);
    }
}

/** 连接蓝牙设备失败*/
- (void)didFailToConnectError:(NSError *)error {
    self.connectResult(error);
}

/** 已经断开连接 */
- (void)didDisconnectError:(NSError *)error {
    //self.connectResult(error);
}
/** 成功连接蓝牙设备 */
- (void)didConnect {
    self.connectResult(nil);
}

#pragma Mark -- 业务

- (void)keyOk:(ResultCmd)result {
    
    Byte byte[] = {0xA5,0x01,0x56};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    [self.centralManager sendData:data result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (result) {
            result(data,error);
        }
    }];
}
- (void)keyRight:(ResultCmd)result {
    
    Byte byte[] = {0xA5,0x02,0xA8};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    [self.centralManager sendData:data result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (result) {
            result(data,error);
        }
    }];
}
- (void)keyRDown:(ResultCmd)result {
    
    Byte byte[] = {0xA5,0x03,0x57};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    [self.centralManager sendData:data result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (result) {
            result(data,error);
        }
    }];
    
}
- (void)keyLDown:(ResultCmd)result {
    
    Byte byte[] = {0xA5,0x04,0xAB};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    
    [self.centralManager sendData:data result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (result) {
            result(data,error);
        }
    }];
}
- (void)keyLeft:(ResultCmd)result {
    
    Byte byte[] = {0xA5,0x05,0x54};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    
    [self.centralManager sendData:data result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (result) {
            result(data,error);
        }
    }];
}
- (void)keyBack:(ResultCmd)result {
    
    Byte byte[] = {0xA5,0x06,0xAA};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    
    [self.centralManager sendData:data result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (result) {
            result(data,error);
        }
    }];
}
- (void)keyStop:(ResultCmd)result {
    
    Byte byte[] = {0xA5,0x07,0x55};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];

    [self.centralManager sendData:data result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (result) {
            result(data,error);
        }
    }];
    
}
- (void)keyAuto:(ResultCmd)result {
    
    Byte byte[] = {0xA5,0x08,0xAD};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    [self.centralManager sendData:data result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (result) {
            result(data,error);
        }
    }];

}
- (void)keyPulse:(ResultCmd)result {
    
    Byte byte[] = {0xA5,0x09,0x52};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    [self.centralManager sendData:data result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (result) {
            result(data,error);
        }
    }];
}
- (void)keyPulseUp:(ResultCmd)result {
    
    Byte byte[] = {0xA5,0x0A,0xAC};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    [self.centralManager sendData:data result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (result) {
            result(data,error);
        }
    }];
}

/** 需要回调 */
- (void)backups:(ResultCmd)result {
    
    Byte byte[] = {0xA5,0x0E,0xAE};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    [self.centralManager sendData:data result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (result) {
            result(data,error);
        }
    }];
    
}

- (void)get_Status:(ResultCmd)result {
    
    Byte byte[] = {0xA5,0x0F,0x51};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    [self.centralManager sendData:data result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (result) {
            result(data,error);
        }
    }];
}

- (void)getLife:(ResultCmd)result {
    
    Byte byte[] = {0xA5,0x11,0x5E};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    [self.centralManager sendData:data result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (result) {
            result(data,error);
        }
    }];
}

- (void)setPhoneName:(NSString *)name result:(ResultCmd)result  {
    
    if (name.length <= 0) {
        return;
    }
    
    NSData *nameData = [name dataUsingEncoding:NSUTF8StringEncoding];
    
    //长度已处理
    NSUInteger length = nameData.length+4;
    Byte byteData[4] = {};
    byteData[0] =(Byte)(Byte)((length & 0x00FF));
    
    Byte byte[] = {0xA5,0x12,byteData[0]};
    
    NSMutableData *mudata = [NSMutableData dataWithBytes:byte length:sizeof(byte)];
    [mudata appendData:nameData];
    
    int crc = CRC8_Get((Byte *)[mudata bytes], mudata.length);
    
    Byte crcByte[1] = {};
    crcByte[0] =(Byte)(Byte)((crc & 0x00FF));
    NSData *crcData = [NSData dataWithBytes:crcByte length:sizeof(crcByte)];
    [mudata appendData:crcData];
    
    [self.centralManager sendData:mudata result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (result) {
            result(data,error);
        }
    }];
}

- (void)getVersion:(ResultCmd)result {
    
    Byte byte[] = {0xA5,0x13,0x5F};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    [self.centralManager sendData:data result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (result) {
            result(data,error);
        }
    }];
}

//----------------------

/** 固件升级 */
- (void)startProgramUpdate:(NSString *)filePath updateprogress:(UpdateProgress)progress {
    
    //TODO:TEST
    
    if (!self.isUpdating) {
        
        self.updateInterval = [[NSDate date] timeIntervalSince1970];
        self.updateProgress = progress;
        
//        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
//        NSString *fileName = [filePath lastPathComponent];
//        long long fileSize = fileData.length;
//        TBLog(@"==fileInfo==%@\n===%lld",fileName,fileSize);
        
        NSData *fileData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"BL1175_V163bf" ofType:@"bin"]];
        long long fileSize = fileData.length;
        NSString *fileName = @"BL1175_V163bf.bin";

        if (!filePath || filePath <=0 ) {
            
            TBLog(@"file no found");
            self.isUpdating = NO;
            
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self programUpdateStartFileData:fileData fileName:fileName fileSize:fileSize];
        });
        
    } else {
        
        TBLog(@"hardware is updating");
    }

}

#pragma Mark -- StartUpdate

- (void)programUpdateStartFileData:(NSData *)filedata fileName:(NSString *)fileName fileSize:(long long)fileSize {
    
    __weak typeof (self)weakSelf = self;
    
    self.isUpdating = YES;
    //请求数据包
    Byte checkbyte[] = {PROTOCOL_C};
    NSData * checkData = [NSData dataWithBytes:checkbyte length:sizeof(checkbyte)];
    
    Byte stopbyte[] = {PROTOCOL_CA};
    NSData * stopData = [NSData dataWithBytes:stopbyte length:sizeof(stopbyte)];
    
    //开始升级
    Byte byte[] = {0xA5,0x0D,0x50};
    NSData *data_ = [NSData dataWithBytes:byte length:sizeof(byte)];
    
    [self.centralManager sendData:data_ result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        
        TBLog(@"=start:=%@==%@",data,error);
        
        if ([checkData isEqual:[data subdataWithRange:NSMakeRange(0, 1)]]) {
            //起始帧
            [weakSelf sendHeadDataFiledata:filedata fileName:fileName fileSize:fileSize result:^(NSData *data, NSError *error) {
                
            }];
        } else if ([stopData isEqual:[data subdataWithRange:NSMakeRange(0, 1)]]) {
            weakSelf.isUpdating = NO;
            TBLog(@"==send data stop==");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.updateProgress) {
                weakSelf.updateProgress(data, 0.00, error,weakSelf.isUpdating);
            }
        });
    }];
}


#pragma Mark -- 起始帧

- (void)sendHeadDataFiledata:(NSData *)filedata fileName:(NSString *)fileName fileSize:(long long)fileSize result:(ResultCmd)result {
    
    NSMutableData *mudata = [NSMutableData data];
    //step1
    Byte byte[] = {PROTOCOL_SOH, 0x00, 0xFF};
    NSData * data_ = [NSData dataWithBytes:byte length:sizeof(byte)];
    [mudata appendData:data_];
    
    //step2
    unsigned char bytes[PROTOCOL_SOH_LEN];
    for (int i = 0; i < 128; i++) bytes[i] = 0;

    NSData * nsd1 = [fileName dataUsingEncoding:NSUTF8StringEncoding]; //
    unsigned char* bytes1 = (unsigned char*) [nsd1 bytes];
    unsigned char bytes2[] = { 0x00 };
    NSString * fs = [NSString stringWithFormat:@"%lld",fileSize];
    NSData * nsd3 = [fs dataUsingEncoding:NSUTF8StringEncoding]; //
    unsigned char* bytes3 = (unsigned char*) [nsd3 bytes];
    //
    memcpy(bytes, bytes1, nsd1.length);
    memcpy(bytes+nsd1.length, bytes2, 1);
    memcpy(bytes+nsd1.length+1, bytes3, nsd3.length);
    
    NSData * data1 = [NSData dataWithBytes:bytes length:PROTOCOL_SOH_LEN];
    [mudata appendData:data1];
    //step3
    [mudata appendData:[self createCRCData:data1]];
    
    __weak typeof (self)weakSelf = self;

    [self updateSendData:mudata result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        TBLog(@"==起始帧结果:=%@==%@",data,error);
        //确认
        Byte ackbyte[] = {PROTOCOL_ACK};
        NSData * ackData = [NSData dataWithBytes:ackbyte length:sizeof(ackbyte)];
        
        //请求数据包
        Byte checkbyte[] = {PROTOCOL_C};
        NSData * checkData = [NSData dataWithBytes:checkbyte length:sizeof(checkbyte)];
        
        if ([ackData isEqual:[data subdataWithRange:NSMakeRange(0, 1)]]) {
            TBLog(@"数据帧开始");
            //数据帧开始
            weakSelf.currentSendCount = 1;
            [weakSelf sendFiledata:filedata result:^(NSData *data, NSError *error) {
                
            }];
            
        } else if ([checkData isEqual:[data subdataWithRange:NSMakeRange(0, 1)]]){
            
            [weakSelf programUpdateStartFileData:filedata fileName:fileName fileSize:fileSize];
        } else {
            weakSelf.isUpdating = NO;
        }
    }];
}

#pragma Mark -- 数据帧

- (void)sendFiledata:(NSData *)filedata result:(ResultCmd)result {
    
    NSData *contentData = filedata;
    NSInteger sumDataLength = contentData.length;
    
    //开辟存数据的空间
    NSInteger dataPackageFrame = sumDataLength % PROTOCOL_STX_LEN ? sumDataLength/PROTOCOL_STX_LEN+1 : sumDataLength/PROTOCOL_STX_LEN;
    
    NSMutableArray *dataPackageArray = [NSMutableArray arrayWithCapacity:0];
    
    //将固件包按1K大小打散，存于数组中
    for (NSInteger i = 0; i < dataPackageFrame; i++) {
        
        if (i < dataPackageFrame-1){
            
            NSData *subData = [contentData subdataWithRange:NSMakeRange(PROTOCOL_STX_LEN * i, PROTOCOL_STX_LEN)];
            [dataPackageArray addObject:subData];
            
        } else if (i == dataPackageFrame-1) {
            
            NSData *subData = [contentData subdataWithRange:NSMakeRange(PROTOCOL_STX_LEN * i, sumDataLength - PROTOCOL_STX_LEN*i)];
            
            NSMutableData *lastData = [NSMutableData data];
            [lastData appendData:subData];

            if (subData.length > PROTOCOL_SOH_LEN) {
                //1024
                Byte byte[PROTOCOL_STX_LEN-subData.length];//填充
                for (int i = 0; i < PROTOCOL_STX_LEN-subData.length; i++) {
                    byte[i] = 0x1A;
                }
                NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
                [lastData appendData:data];
                
            } else {
                //128
                Byte byte[PROTOCOL_SOH_LEN-subData.length];//填充
                for (int i = 0; i < PROTOCOL_SOH_LEN-subData.length; i++) {
                    byte[i] = 0x1A;
                }
                NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
                [lastData appendData:data];
            }
            [dataPackageArray addObject:lastData];
        }
    }
    
    // send data block
    [self sendFileBlockDataArray:dataPackageArray result:^(NSData *data, NSError *error) {
        
    }];
}


- (void)sendFileBlockDataArray:(NSArray *)dataPackArray result:(ResultCmd)result {
    //410
    if (self.currentSendCount <= dataPackArray.count) {
        
        NSMutableData *mudata = [NSMutableData data];
        NSData *dataPackage = dataPackArray[self.currentSendCount-1];
        
        unsigned char bytes[3];
        
        if (dataPackage.length == PROTOCOL_SOH_LEN) {
            bytes[0] = PROTOCOL_SOH;
        } else {
            bytes[0] = PROTOCOL_STX;
        }
        
        NSInteger sendCountBis;
        NSInteger sendCountNot;
        if (self.currentSendCount > 255) {
            sendCountBis = (self.currentSendCount % 256);
            sendCountNot = 255 - self.currentSendCount % 256;
        } else {
            sendCountNot = 255 - self.currentSendCount;
            sendCountBis = self.currentSendCount;
        }
        
        bytes[1] = sendCountBis;
        bytes[2] = sendCountNot;
        
        NSData * data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
        //...
        [mudata appendData:data];
        //数据
        [mudata appendData:dataPackage];
        //crc
        [mudata appendData:[self createCRCData:dataPackage]];
        
        __weak typeof (self)weakSelf = self;

        [self updateSendData:mudata result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.updateProgress) {
                    weakSelf.updateProgress(data, (CGFloat)weakSelf.currentSendCount/dataPackArray.count, error,YES);
                }
            });
            
            Byte byte[] = {PROTOCOL_ACK};
            NSData * checkData = [NSData dataWithBytes:byte length:sizeof(byte)];
            
            Byte cbyte[] = {PROTOCOL_C};
            NSData * checkDatac = [NSData dataWithBytes:cbyte length:sizeof(cbyte)];
            
            Byte stopbyte[] = {PROTOCOL_CA};
            NSData * stopData = [NSData dataWithBytes:stopbyte length:sizeof(stopbyte)];
            
            if ([checkData isEqual:[data subdataWithRange:NSMakeRange(0, 1)]]) {
                TBLog(@"==send success next data block==");
                //下一帧
                if (weakSelf.currentSendCount == dataPackArray.count) {
                    //最后一帧数据帧成功,回调
                    [weakSelf sendDataEnd];
                    
                    return ;
                }
                weakSelf.currentSendCount+=1;
                [weakSelf sendFileBlockDataArray:dataPackArray result:^(NSData *data, NSError *error) {
                }];
                
            } else if ([checkDatac isEqual:[data subdataWithRange:NSMakeRange(0, 1)]]) {
                //重发一次
                TBLog(@"==重复一帧==");
                [weakSelf sendFileBlockDataArray:dataPackArray result:^(NSData *data, NSError *error) {
                }];
                
            } else if ([stopData isEqual:[data subdataWithRange:NSMakeRange(0, 1)]]){
                //终止传输
                TBLog(@"==终止一帧==");
                weakSelf.isUpdating = NO;
            }
        }];
    }
}

#pragma Mark -- 数据结束帧

- (void)sendDataEnd {
    
    //
    Byte nakbyte[] = {PROTOCOL_NAK};
    NSData *nakData = [NSData dataWithBytes:nakbyte length:sizeof(nakbyte)];
    
    //确认
    Byte ackbyte[] = {PROTOCOL_ACK};
    NSData * ackData = [NSData dataWithBytes:ackbyte length:sizeof(ackbyte)];
    
    Byte byte[] = {PROTOCOL_EOT};
    NSData *data_ = [NSData dataWithBytes:byte length:sizeof(byte)];
    
    __weak typeof (self)weakSelf = self;

    [self.centralManager sendData:data_ result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        
        TBLog(@"=End Data:EOT=%@===%@",data,error);
        if ([nakData isEqual:[data subdataWithRange:NSMakeRange(0, 1)]]) {
            
            [weakSelf sendDataEnd];
            
        } else if ([ackData isEqual:[data subdataWithRange:NSMakeRange(0, 1)]]) {
            [weakSelf programUpdateSuccess];
        }
    }];
}

#pragma Mark -- 升级成功

- (void)programUpdateSuccess {
        
    NSMutableData *mudata = [NSMutableData data];
    Byte byte[] = {PROTOCOL_SOH, 0x00, 0xFF};
    NSData * data1 = [NSData dataWithBytes:byte length:sizeof(byte)];
    [mudata appendData:data1];
    
    unsigned char bytes[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    
    NSData * data_ = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [mudata appendData:data_];
    [mudata appendData:[self createCRCData:data_]];
    __weak typeof (self)weakSelf = self;

    [self updateSendData:mudata result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        TBLog(@"==success data:==%@",data);
        weakSelf.isUpdating = NO;
        weakSelf.updateInterval = [[NSDate date] timeIntervalSince1970] - weakSelf.updateInterval;
        TBLog(@"==update sum time:=%f",weakSelf.updateInterval);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.updateProgress) {
                weakSelf.updateProgress(data, 1.0, error,NO);
            }
        });
    }];
}

#pragma Mark -- AdditionsMethod

- (NSData *)createCRCData:(NSData *)data {
    unsigned char* bytes = (unsigned char*) data.bytes;
    NSInteger len = data.length;
    int crc = crc16(bytes, len);
    unsigned char crcbytes[2];
    crcbytes[0] = (crc & 0xFF00) >> 0x8;
    crcbytes[1] = crc & 0xFF;
    NSData *crcdata = [NSData dataWithBytes:crcbytes length:2];
    return crcdata;
}

//发送最后一块数据成功才会回调
- (void)updateSendData:(NSData *)data result:(nonnull sendDataCallback)result{
    
    int maxlength = 150;
    
    if (data.length > maxlength) {
        
        BOOL remainder = (data.length % maxlength)==0 ? YES:NO;
        
        NSInteger count = data.length / maxlength;
        unsigned char* bytes = (unsigned char*) data.bytes;
        
        int var9;
        for (var9 = 0; var9 < count; var9++) {
            unsigned char bytesToSend[maxlength];
            for (int y = 0; y < maxlength; y++) {
                bytesToSend[y] = bytes[(var9*maxlength + y)];
            }
            NSData * dataToSend = [NSData dataWithBytes:bytesToSend length:maxlength];
            
            [self.centralManager sendData:dataToSend result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
                if (remainder && (var9==count-1)) {
                    if (result) {
                        result(data,error);
                    }
                }
            }];
        }
        
        if (!remainder) {
            int l = data.length % maxlength;
            unsigned char bytesToSend[l];
            
            for (int y = 0; y < l; y++) {
                bytesToSend[y] = bytes[(count*maxlength + y)];
            }
            NSData * dataToSend = [NSData dataWithBytes:bytesToSend length:l];
            [self.centralManager sendData:dataToSend result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
                if (result) {
                    result(data,error);
                }
            }];
        }
        
    } else {
        
        [self.centralManager sendData:data result:^(NSData * _Nonnull data, NSError * _Nonnull error) {
            if (result) {
                result(data,error);
            }
        }];
    }
}


typedef unsigned char INT08U;

INT08U CRC8_Tab[ 16 ] =
{
    0x00, 0xFF, 0x01, 0xFE,
    0x02, 0xFD, 0x03, 0xFC,
    0x04, 0xFB, 0x05, 0xFA,
    0x06, 0xF9, 0x07, 0xF8
};

INT08U CRC8_Get(INT08U * dat, INT08U len)
{
    INT08U i, temp, crc=0;
    
    for(i = 0; i < len; i ++)
    {
        temp = (crc >> 4) ^ (dat[i] >> 4);
        crc <<= 4;
        crc ^= CRC8_Tab[temp];
        temp = (crc >> 4) ^ (dat[i] & 0x0F);
        crc <<= 4;
        crc ^= CRC8_Tab[temp];
    }
    
    return crc;
}

static unsigned short crc16(const unsigned char *buf, unsigned long count)
{
    unsigned short crc = 0;
    int i;
    
    while(count--) {
        crc = crc ^ *buf++ << 8;
        
        for (i=0; i<8; i++) {
            if (crc & 0x8000) {
                crc = crc << 1 ^ 0x1021;
            } else {
                crc = crc << 1;
            }
        }
    }
    return crc;
}

@end
