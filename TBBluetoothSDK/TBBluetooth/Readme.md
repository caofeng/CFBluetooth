SDK使用介绍： （SDK中的日志只会在 DEBUG 时有输出）

1.project info.plist file add key：Privacy - Bluetooth Peripheral Usage Description

2.  #import "TBBluetooth.h"

3. AppDelegate.m 初始化SDK：

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [TBBLEDeviceManager initSDK];

return YES;
}

4. 监测蓝牙是否可用: [TBBLEManager shareManager].enableBluetooth
    监测蓝牙是否可用是个异步回调，不可在程序刚开打的时候调用此值，否则返回的是NO,
    
    或者监听蓝牙可用的通知  kTBBluetoothCentralDeviceStateONNotification
    蓝牙不可用通知 kTBBluetoothCentralDeviceStateOFFNotification
     
5.  获取扫描到的周边蓝牙设备列表: (根据需要使用此回调)
    [TBBLEManager shareManager].listPairFoodProcessors = ^(NSArray<TBDevicer *> * _Nonnull deviceList) {
        
    };
    
6. 当扫描到目标外设时回调:
    [[TBBLEManager shareManager].scanTargetDevice = ^(BOOL found) {
        if (found) {
            NSLog(@"发现目标外设，可以连接了");
            }
    }];
    
     
7. 连接目标外设:  （调用此方法时会停止扫描外设）
    [[TBBLEManager shareManager] connectResult:^(NSError *error) {
        if (!error) {
            NSLog(@"连接成功");
            }
    }];

8. 获取目标外设的连接状态： [TBBLEManager shareManager].connectState

9. 断开连接: [[TBBLEManager shareManager] disconnect];

10. 业务方法调用： [[TBBLEManager shareManager]keyOk];

