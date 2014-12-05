//
//  ChatRoom.m
//  Pathion
//
//  Created by justin cheng on 1/10/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

#import "ChatRoom.h"
#import "ChatCell.h"

@interface ChatRoom ()

@end

@implementation ChatRoom
@synthesize tfEntry, chatTable, postNumber, className;
#define MAX_ENTRIES_LOADED 500

- (void)viewDidLoad
{
    [super viewDidLoad];
    tfEntry.delegate = self;
    tfEntry.clearButtonMode = UITextFieldViewModeWhileEditing;
    chatTable.delegate = self;
    chatTable.dataSource = self;
    [self registerForKeyboardNotifications];
    self.navigationItem.title = className;
    chatData  = [[NSMutableArray alloc] init];
    [self loadLocalChat];
    originalH = self.view.frame.size.height;
    keyboardState = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self freeKeyboardNotifications];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Chat textfield

-(IBAction) textFieldDoneEditing : (id) sender
{
    [sender resignFirstResponder];
    [tfEntry resignFirstResponder];
}

-(IBAction) backgroundTap:(id) sender
{
    [self.tfEntry resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (tfEntry.text.length>0) {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        if ([prefs integerForKey:@"blocked"] == 1) {
            return NO;
        }
        
        NSString *name = [prefs objectForKey:@"chatname"];
        if ([name  isEqual: @""]) {
            name = @"student";
        }
        PFObject *newMessage = [PFObject objectWithClassName:@"chatroom"];
        [newMessage setObject:tfEntry.text forKey:@"text"];
        [newMessage setObject:name forKey:@"name"];
        //[newMessage setObject:[NSDate date] forKey:@"date"];
        [newMessage setObject:[NSNumber numberWithInt:postNumber] forKey:@"PostNumber"];
        [newMessage setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"UID"];
        [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self loadLocalChat];
            }
        }];
        tfEntry.text = @"";
    }
    return NO;
}

-(void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}


-(void) freeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}


-(void) keyboardWasShown:(NSNotification*)aNotification
{
    if (keyboardState == 0) {
        NSDictionary* info = [aNotification userInfo];
    
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        CGRect keyboardFrame;
        [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, originalH- keyboardFrame.size.height)];
    
        [UIView commitAnimations];
        keyboardState = 1;
    }
}


-(void) keyboardWillChangeFrame:(NSNotification*)aNotification
{
    if (keyboardState == 1) {
        NSDictionary* info = [aNotification userInfo];
    
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        CGRect keyboardFrame;
        CGRect nkeyboardFrame;
        [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
        [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&nkeyboardFrame];
    
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, originalH- nkeyboardFrame.size.height)];
    
        [UIView commitAnimations];
    }
}

-(void) keyboardWillHide:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, originalH)];
    
    [UIView commitAnimations];
    keyboardState = 0;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    _reloading = YES;
    [self loadLocalChat];
}


#pragma mark - Table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [chatData sortUsingComparator:^NSComparisonResult(NSDictionary* obj1, NSDictionary* obj2) {
        return [(PFObject*)obj1 createdAt] < [(PFObject*)obj2 createdAt];
    }];
    return [chatData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *cell = (ChatCell *)[tableView dequeueReusableCellWithIdentifier: @"ChatCell"];
    NSUInteger row = [chatData count]-[indexPath row]-1;
    
    if (row < chatData.count){
        PFObject *object = [chatData objectAtIndex:row];
        NSString *chatText = [object objectForKey:@"text"];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        UIFont *font = [UIFont systemFontOfSize:14];
        CGRect boundingRec = [chatText boundingRectWithSize:CGSizeMake(225.0f, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        cell.textString.frame = CGRectMake(75, 14, boundingRec.size.width +20, boundingRec.size.height + 20);
        cell.textString.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        cell.textString.text = chatText;
        [cell.textString sizeToFit];
        
        NSDate *theDate = [object createdAt];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM hh:mm aa"];
        NSString *timeString = [formatter stringFromDate:theDate];
        
        boundingRec = [timeString boundingRectWithSize:CGSizeMake(21.0f, 90.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        cell.timeLabel.frame = CGRectMake(75, 14, boundingRec.size.width +10, boundingRec.size.height + 10);
        cell.timeLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        cell.timeLabel.text = timeString;
        [cell.timeLabel sizeToFit];
        
        NSString *name = [object objectForKey:@"name"];
        
        boundingRec = [name boundingRectWithSize:CGSizeMake(21.0f, 90.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        cell.userLabel.frame = CGRectMake(75, 14, boundingRec.size.width +10, boundingRec.size.height + 10);
        cell.userLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        cell.userLabel.text = name;
        [cell.userLabel sizeToFit];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellText = [[chatData objectAtIndex:chatData.count-indexPath.row-1] objectForKey:@"text"];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(225.0f, MAXFLOAT);
    CGRect boundingRec = [cellText boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cellFont} context:nil];
    return boundingRec.size.height + 40;
}

#pragma mark - Parse

- (void)loadLocalChat
{
    query = nil;
    query = [PFQuery queryWithClassName:@"chatroom"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"PostNumber" equalTo:[NSNumber numberWithInt:postNumber]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            for (PFObject *object in objects) {
                [temp addObject:object];
            }
            chatData = temp;
            [self loadedLocalChat];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)loadedLocalChat
{
    [chatTable reloadData];
    if ([chatData count] > 0) {
        [chatTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatData count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(IBAction)refresh:(id)sender
{
    [self loadLocalChat];
}

@end
