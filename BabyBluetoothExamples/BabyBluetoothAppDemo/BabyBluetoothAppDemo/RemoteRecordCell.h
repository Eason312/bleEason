//
//  RemoteRecordCell.h
//  P2PCamera
//
//  Created by yan luke on 13-1-24.
//
//

#import <UIKit/UIKit.h>

@interface RemoteRecordCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIImageView* iconImg;
@property (nonatomic, retain) IBOutlet UILabel* nameLabel;
@property (nonatomic, retain) IBOutlet UILabel* typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel2;
@property (weak, nonatomic) IBOutlet UIButton *BtnBle;







@end
