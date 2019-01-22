//
//  ViewController.m
//  TBBluetoothSDK
//
//  Created by Topband on 2018/11/14.
//  Copyright © 2018年 深圳拓邦股份有限公司. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#import "ViewController.h"
#import "TBBluetooth.h"
#import "UIViewController+HUD.h"
#import "AFNetworking.h"

@interface ViewController ()

@property (nonatomic, strong)UILabel    *findDeviceLabel;
@property (nonatomic, strong)UIButton   *connectBnt;
@property (nonatomic, strong)UILabel    *stateLabel;
@property (nonatomic, strong)UILabel    *callbackLabel;
@property (nonatomic, strong)UIButton   *disconnectBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"TEST";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"固件升级" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"扫描设备" style:UIBarButtonItemStyleDone target:self action:@selector(leftItemClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    self.findDeviceLabel = [[UILabel alloc]init];
    self.findDeviceLabel.frame = CGRectMake(10, 80, (kScreenWidth-40)/3, 50);
    [self.view addSubview:self.findDeviceLabel];
    self.findDeviceLabel.backgroundColor = [UIColor grayColor];
    self.findDeviceLabel.textColor = [UIColor whiteColor];
    self.findDeviceLabel.font = [UIFont systemFontOfSize:14];
    self.findDeviceLabel.textAlignment = NSTextAlignmentCenter;
    self.findDeviceLabel.text = @"not find target";

    
    self.connectBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.connectBnt.frame = CGRectMake(CGRectGetMaxX(self.findDeviceLabel.frame)+10, 80, (kScreenWidth-40)/3, 50);
    [self.connectBnt setTitle:@"connect" forState:UIControlStateNormal];
    [self.view addSubview:self.connectBnt];
    [self.connectBnt addTarget:self action:@selector(connectDeviceClick) forControlEvents:UIControlEventTouchUpInside];
    self.connectBnt.backgroundColor = [UIColor redColor];
    
    self.stateLabel = [[UILabel alloc]init];
    self.stateLabel.frame = CGRectMake(CGRectGetMaxX(self.connectBnt.frame)+10, 80, 100, 50);
    self.stateLabel.text = @"disconnect";
    [self.view addSubview:self.stateLabel];
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    self.stateLabel.backgroundColor = [UIColor grayColor];
    self.stateLabel.textColor = [UIColor whiteColor];
    
    
    self.callbackLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2, 150, kScreenWidth/2-10, 300)];
    self.callbackLabel.textAlignment = NSTextAlignmentCenter;
    self.callbackLabel.numberOfLines = 0;
    [self.view addSubview:self.callbackLabel];
    self.callbackLabel.backgroundColor = [UIColor grayColor];
    self.callbackLabel.textColor = [UIColor whiteColor];
    
    
    self.disconnectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.disconnectBtn.frame = CGRectMake(kScreenWidth/2, 500, kScreenWidth/2-10, 50);
    [self.disconnectBtn setTitle:@"disconnect Device" forState:UIControlStateNormal];
    [self.view addSubview:self.disconnectBtn];
    [self.disconnectBtn addTarget:self action:@selector(disConnectDeviceClick) forControlEvents:UIControlEventTouchUpInside];
    self.disconnectBtn.backgroundColor = [UIColor redColor];
    
    [TBBLEManager shareManager].scanTargetDevice = ^(BOOL found) {
        if (found) {
            self.findDeviceLabel.text = @"find target";
        }
    };
    
    
    NSArray *titleArr = @[@"keyOK",@"keyRight",@"keyRDown",@"keyLDown",@"keyLeft",@"keyBack",@"keyStop",@"keyAuto",@"keyPulse",@"keyPulseUp",@"setPhoneName",@"getVersion",@"setStatus",@"shutdown updateProgress"];
    
    for (int i=0; i<titleArr.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(10, 150+33*i, kScreenWidth/2-20, 28);
        [self.view addSubview:button];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    
    [[TBBLEManager shareManager]get_StatusWithInterval:750 callback:^(NSData *data, NSError *error) {
        NSLog(@"==getStatus=%@",data);
    }];
    
    [[TBBLEManager shareManager]getLifeWithInterval:750 callback:^(NSData *data, NSError *error) {
        NSLog(@"==getLife=%@",data);
    }];
    
    [[TBBLEManager shareManager]backupsWithInterval:750 callback:^(NSData *data, NSError *error) {
        NSLog(@"==backups=%@",data);
    }];
}

- (void)connectDeviceClick {
    
    [[TBBLEManager shareManager] connectResult:^(NSError *error) {
        if (!error) {
            self.stateLabel.text = @"connected";
        }
    }];
}

- (void)disConnectDeviceClick {
    
    [[TBBLEManager shareManager] disconnect];
    self.stateLabel.text = @"disconnect";
    self.callbackLabel.text = @"";
}

- (void)buttonClick:(UIButton *)button {
    
    NSInteger index = button.tag - 100;
    
    if (index == 0) {
        
        [[TBBLEManager shareManager]keyOk:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }
        }];

    }else if (index == 1) {
        [[TBBLEManager shareManager] keyRight:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }
            
        }];

    }else if (index == 2) {
        [[TBBLEManager shareManager] keyRDown:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }

        }];

    }else if (index == 3) {
        [[TBBLEManager shareManager] keyLDown:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }

        }];

    }else if (index == 4) {
        [[TBBLEManager shareManager] keyLeft:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }
        }];

    }else if (index == 5) {
        [[TBBLEManager shareManager] keyBack:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }
        }];

    }else if (index == 6) {
        [[TBBLEManager shareManager] keyStop:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }

        }];

    }else if (index == 7) {
        [[TBBLEManager shareManager] keyAuto:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }

        }];

    }else if (index == 8) {
        [[TBBLEManager shareManager] keyPulse:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }
        }];

    }else if (index == 9) {
        [[TBBLEManager shareManager] keyPulseUp:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }

        }];

    }else if (index == 10) {
        
        [[TBBLEManager shareManager] setPhoneName:@"iPhone XS" result:^(NSData *data, NSError *error) {
            
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }
        }];

    }else if (index == 11) {
        [[TBBLEManager shareManager] getVersion:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }
        }];
    } else if (index == 12) {
        
        Byte byte[] = {0xFF};
        [[TBBLEManager shareManager] set_Status:byte result:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }
        }];
    } else if (index == 13) {
        [[TBBLEManager shareManager] cancelProgamUpdate];
    }
}

- (void)leftItemClick {
    
    if ([TBBLEManager shareManager].isBluetoothEnabled) {
        
        [[TBBLEManager shareManager] startScanAllDevices];
        
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未打开蓝牙,去打开？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionleft =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *actionright =[UIAlertAction actionWithTitle:@"去打开" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
            
        }];
        [alert addAction:actionleft];
        [alert addAction:actionright];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)rightItemClick {
    
    NSLog(@"固件升级");
    
    
    [self showHUDLoadingWithText:@"file downloading..."];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://plgd0k1hz.bkt.clouddn.com/BL1175.bin"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];

        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [self hideHUD:YES];
        [self showHUDWithText:@"download success" duration:2];
        [self updateHardwareFilepath:filePath.path];
        TBLog(@"File downloaded to: %@", filePath.path);
    }];
    
    [downloadTask resume];
    
}

- (void)updateHardwareFilepath:(NSString *)filepath {
    
    [[TBBLEManager shareManager] startProgramUpdate:filepath updateprogress:^(NSData *data, CGFloat progress, NSError *error, BOOL updating) {
        
        if (updating) {
            
            self.callbackLabel.text = [NSString stringWithFormat:@"update progress %.0f %%",progress*100];
        }
        
        if (!updating && progress >= 1.0) {
            self.callbackLabel.text = @"update success";
            TBLog(@"升级成功之后需要把在此把文件删除");
        }
    }];
    
}

@end
