//
//  PSBroView.m
//  BroBoard
//
//  Created by Peter Shih on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 This is an example of a subclass of PSCollectionViewCell
 */

#import "PSBroView.h"
#import <Parse/Parse.h>

#define MARGIN 4.0

@interface PSBroView ()

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *captionLabel;
@end

@implementation PSBroView

@synthesize
imageView = _imageView,
captionLabel = _captionLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        
        self.captionLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.captionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
        self.captionLabel.backgroundColor = [UIColor blackColor];
        self.captionLabel.textColor = [UIColor lightGrayColor];
        self.captionLabel.textAlignment = NSTextAlignmentCenter;
        self.captionLabel.numberOfLines = 0;
        [self addSubview:self.captionLabel];
        
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.captionLabel.text = nil; 
}

- (void)dealloc {
    self.imageView = nil;
    self.captionLabel = nil;
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width - MARGIN * 2;
    CGFloat top = MARGIN;
    CGFloat left = MARGIN;
    
    // Image
    PFObject *imageObj = (PFObject*)self.object;
    NSNumber *objWidth = imageObj[@"Width"];
    NSNumber *objHeight = imageObj[@"Height"];
    CGFloat objectWidth = [objWidth floatValue];
    CGFloat objectHeight = [objHeight floatValue];
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    self.imageView.frame = CGRectMake(left, top, width, scaledHeight);
    
    // Label
    CGSize labelSize = CGSizeZero;
    labelSize = [self.captionLabel.text sizeWithFont:self.captionLabel.font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:self.captionLabel.lineBreakMode];
    top = self.imageView.frame.origin.y + self.imageView.frame.size.height + MARGIN;
    
    self.captionLabel.frame = CGRectMake(width - labelSize.width, top, labelSize.width, labelSize.height);
    
    //title label
//    labelSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:self.titleLabel.lineBreakMode];
//    
//    self.titleLabel.frame = CGRectMake(width - labelSize.width, top, labelSize.width, labelSize.height);
}

- (void)fillViewWithObject:(id)object {
    [super fillViewWithObject:object];
    PFObject *imageObj = (PFObject*)object;
//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://imgur.com/%@%@", [object objectForKey:@"hash"], [object objectForKey:@"ext"]]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        self.imageView.image = [UIImage imageWithData:data];
//    }];
    
//    self.captionLabel.text = [object objectForKey:@"title"];
    PFFile *imageFile = imageObj[@"Image"];
    if(imageFile != NULL && ![imageFile isKindOfClass:[NSNull class]] && !imageFile.isDirty){
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            self.imageView.image = [UIImage imageWithData:data];
        }];
    }
    self.captionLabel.text = imageObj[@"Description"];
   // self.titleLabel.text = @"National Park";
}

+ (CGFloat)heightForViewWithObject:(id)object inColumnWidth:(CGFloat)columnWidth {
    CGFloat height = 0.0;
    CGFloat width = columnWidth - MARGIN * 2;
    
    height += MARGIN;
    
    // Image
    PFObject *imageObj = (PFObject*)object;
    NSNumber *objWidth = imageObj[@"Width"];
    NSNumber *objHeight = imageObj[@"Height"];
    CGFloat objectWidth = [objWidth floatValue];
    CGFloat objectHeight = [objHeight floatValue];
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    height += scaledHeight;
    
    // Label
    NSString *caption = imageObj[@"Description"];
    CGSize labelSize = CGSizeZero;
    UIFont *labelFont = [UIFont boldSystemFontOfSize:14.0];
    labelSize = [caption sizeWithFont:labelFont constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    height += labelSize.height;  
    height += MARGIN;
    
    return height;
}

@end
