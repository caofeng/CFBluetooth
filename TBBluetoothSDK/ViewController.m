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
    
    
    NSArray *titleArr = @[@"keyOK",@"keyRight",@"keyRDown",@"keyLDown",@"keyLeft",@"keyBack",@"keyStop",@"keyAuto",@"keyPulse",@"keyPulseUp",@"backups",@"getStatus",@"getLife",@"setPhoneName",@"getVersion"];
    
    for (int i=0; i<titleArr.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(10, 150+33*i, kScreenWidth/2-20, 28);
        [self.view addSubview:button];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
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
        [[TBBLEManager shareManager] backups:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }

        }];

    }else if (index == 11) {
        [[TBBLEManager shareManager] get_Status:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }
        }];

    }else if (index == 12) {
        [[TBBLEManager shareManager] getLife:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }

        }];

    }else if (index == 13) {
        
        [[TBBLEManager shareManager] setPhoneName:@"iPhone XS" result:^(NSData *data, NSError *error) {
            
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }
        }];

    }else if (index == 14) {
        [[TBBLEManager shareManager] getVersion:^(NSData *data, NSError *error) {
            if (error) {
                self.callbackLabel.text = [error localizedDescription];
            } else {
                self.callbackLabel.text = [NSString stringWithFormat:@"%@",data];
            }
        }];

    }
}

- (void)rightItemClick {
    
    NSLog(@"固件升级");
    
    /*
     
     once send 120 byte:
     
     TEST: iOS12, iPhone6S update 430k file, time 225s  success
     
     TEST: iOS11, iPhone7P update 430k file, time 246s  success
     
     TEST: iOS10, iPhone6P update 430k file, time 180s  success
     
     ----------------------------------------------------------
     
     once send 150 byte:
     
     TEST: iOS12, iPhone6S update 430k file, time 200s  success
     
     TEST: iOS11, iPhone7P update 430k file, time 200s  success
     
     TEST: iOS10, iPhone6P update 430k file, time 140s  success
     
     */
    
    
    [[TBBLEManager shareManager] startProgramUpdate:@"" updateprogress:^(NSData *data, CGFloat progress, NSError *error, BOOL updating) {
       
        if (updating) {
            
            self.callbackLabel.text = [NSString stringWithFormat:@"update progress %.0f %%",progress*100];
        }
        
        if (!updating && progress >= 1.0) {
            self.callbackLabel.text = @"update success";
        }
    }];
    
}

@end
