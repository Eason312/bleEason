//
//  ttttViewController.h
//  BabyBluetoothAppDemo
//
//  Created by Eason on 2020/10/27.
//  Copyright © 2020 刘彦玮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ttttViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
