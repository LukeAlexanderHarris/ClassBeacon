//
//  NotesViewController.m
//  ClassBeacon
//
//  Created by lah37@kent.ac.uk on 16/3/2015.
//  Copyright (c) 2015 lah37@kent.ac.uk. All rights reserved.
//

#import "NotesViewController.h"

@interface NotesViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation NotesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Check to see if note is not nil, which let's us know that the note
    // had already been saved.
    if (self.note != nil) {
        self.titleTextField.text = [self.note objectForKey:@"title"];
        self.contentTextView.text = [self.note objectForKey:@"content"];
    }
}

- (IBAction)saveWasPressed:(id)sender {
    
    NSString *title = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([title length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You must at least enter a title"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        if (self.note != nil) {
            [self updateNote];
        }
        else {
            [self saveNote];
        }
    }
    
}

- (void)saveNote
{
    
    PFObject *newNote = [PFObject objectWithClassName:@"Notes"];
    newNote[@"title"] = self.titleTextField.text;
    newNote[@"content"] = self.contentTextView.text;
    newNote[@"author"] = [PFUser currentUser];
    
    [newNote saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
    
}

- (void)updateNote
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Notes"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:[self.note objectId] block:^(PFObject *oldNote, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            oldNote[@"title"] = self.titleTextField.text;
            oldNote[@"content"] = self.contentTextView.text;
            
            [oldNote saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                        message:[error.userInfo objectForKey:@"error"]
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
            }];
        }
        
    }];
    
}

@end
