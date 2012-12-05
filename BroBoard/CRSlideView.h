//
//  CRSlideView.h
//  BroBoard
//
//  Created by Phillipe Casorla Sagot on 9/25/12.
//
//

#import <UIKit/UIKit.h>
#import "PPRevealSideViewController.h"

@interface CRSlideView : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tableView;
    NSArray *parks;
}
@end
