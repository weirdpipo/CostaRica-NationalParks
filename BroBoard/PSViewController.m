//
//  PSViewController.m
//  BroBoard
//
//  Created by Peter Shih on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSViewController.h"
#import "PSBroView.h"
#import <Parse/Parse.h>

/**
 This is an example of a controller that uses PSCollectionView
 */

/**
 Detect iPad
 */
static BOOL isDeviceIPad() {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES; 
    }
#endif
    return NO;
}

@interface PSViewController ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) PSCollectionView *collectionView;

@end

@implementation PSViewController

@synthesize
items = _items,
collectionView = _collectionView;

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.items = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPark:) name:@"selectPark" object:nil];
    }
    return self;
}
-(void) selectPark:(NSNotification*)notif{
    NSString *parkName = (NSString*)notif.object;
    PFQuery *images = [PFQuery queryWithClassName:@"NationalParkImage"];
    [images whereKey:@"Description" containsString:parkName];
    [images findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            self.items = [NSMutableArray arrayWithArray:objects];
            [self dataSourceDidLoad];
        } else {
            [self dataSourceDidError];
        }
    }];
    
}
- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.collectionView.delegate = nil;
    self.collectionView.collectionViewDelegate = nil;
    self.collectionView.collectionViewDataSource = nil;
    
    self.collectionView = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.collectionView.delegate = nil;
    self.collectionView.collectionViewDelegate = nil;
    self.collectionView.collectionViewDataSource = nil;
    
    self.collectionView = nil;
    self.items = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.collectionView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.collectionView];
    self.collectionView.collectionViewDelegate = self;
    self.collectionView.collectionViewDataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (isDeviceIPad()) {
        self.collectionView.numColsPortrait = 1;
        self.collectionView.numColsLandscape = 5;
    } else {
        self.collectionView.numColsPortrait = 1;
        self.collectionView.numColsLandscape = 3;
    }
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:self.collectionView.bounds];
    loadingLabel.text = @"Loading...";
    loadingLabel.textAlignment = UITextAlignmentCenter;
    
    UILabel *loadingLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/8)];
    loadingLabel2.text = @"National Parks of Costa Rica";
    loadingLabel2.textAlignment = UITextAlignmentCenter;
    loadingLabel2.font = [UIFont fontWithName:@"Helvetica-Bold" size:25.0f];
    loadingLabel2.backgroundColor = [UIColor blackColor];
    loadingLabel2.textColor = [UIColor lightGrayColor];
    
    self.collectionView.loadingView = loadingLabel;
    self.collectionView.headerView = loadingLabel2;
    
    [self loadDataSource];

}

- (void)loadDataSource {
//    // Request
//    NSString *URLPath = [NSString stringWithFormat:@"http://imgur.com/gallery.json"];
//    NSURL *URL = [NSURL URLWithString:URLPath];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        
//        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//        
//        if (!error && responseCode == 200) {
//            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            if (res && [res isKindOfClass:[NSDictionary class]]) {
//                self.items = [res objectForKey:@"gallery"];
//                [self dataSourceDidLoad];
//            } else {
//                [self dataSourceDidError];
//            }
//        } else {
//            [self dataSourceDidError];
//        }
//    }];
    PFQuery *images = [PFQuery queryWithClassName:@"NationalParkImage"];
    [images findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            self.items = [NSMutableArray arrayWithArray:objects];
            [self dataSourceDidLoad];
        } else {
            [self dataSourceDidError];
        }
    }];
}

- (void)dataSourceDidLoad {
    [self.collectionView reloadData];
}

- (void)dataSourceDidError {
    [self.collectionView reloadData];
}

#pragma mark - PSCollectionViewDelegate and DataSource
- (NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView {
    return [self.items count];
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView viewAtIndex:(NSInteger)index {
    NSDictionary *item = [self.items objectAtIndex:index];
    
    PSBroView *v = (PSBroView *)[self.collectionView dequeueReusableView];
    if (!v) {
        v = [[PSBroView alloc] initWithFrame:CGRectZero];
    }
    
    [v fillViewWithObject:item];
    
    return v;
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index {
    NSDictionary *item = [self.items objectAtIndex:index];
    
    return [PSBroView heightForViewWithObject:item inColumnWidth:self.collectionView.colWidth];
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndex:(NSInteger)index {
//    NSDictionary *item = [self.items objectAtIndex:index];
    
    // You can do something when the user taps on a collectionViewCell here
}

@end
