//
//  ChatRoom.h
//  Pathion
//
//  Created by justin cheng on 1/10/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
//#import "PF_EGORefreshTableHeaderView.h"

#define TABBAR_HEIGHT 0.0f
#define TEXTFIELD_HEIGHT 70.0f

@interface ChatRoom : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITextField    *tfEntry;
    IBOutlet UITableView    *chatTable;
    NSMutableArray          *chatData;
    BOOL _reloading;
    NSString                *className;
    PFQuery                 *query;
    int                     postNumber;
    int                     originalH;
    int                     keyboardState;
}
@property(nonatomic, retain) IBOutlet UITextField *tfEntry;
@property(nonatomic, retain) IBOutlet UITableView *chatTable;
@property(nonatomic) int postNumber;
@property(nonatomic) NSString *className;
-(void) registerForKeyboardNotifications;
-(void) freeKeyboardNotifications;
-(void) keyboardWasShown:(NSNotification*)aNotification;
-(void) keyboardWillHide:(NSNotification*)aNotification;
-(void) keyboardWillChangeFrame:(NSNotification*)aNotification;
-(void) loadLocalChat;
-(void) loadedLocalChat;
-(IBAction)refresh:(id)sender;
@end
