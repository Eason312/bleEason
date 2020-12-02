//
//  ViewController.h
//  Test
//
//  Created by K.O on 2018/7/20.
//  Copyright © 2018年 rela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalCell.h"
#import "PickerView.h"



#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralInfo.h"
#import "SVProgressHUD.h"
#import "CharacteristicViewController.h"
@interface ViewController : UIViewController<PickerViewResultDelegate>{
    
@public
BabyBluetooth *baby;
}

@property __block NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (nonatomic,strong)CBCharacteristic *characteristic;

@end

