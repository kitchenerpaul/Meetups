//
//  WebViewController.m
//  MeetMeUp
//
//  Created by Paul Kitchener on 10/12/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *meetUpWebView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkActivityIndicator;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;


@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:[self.webDictionary objectForKey:@"event_url"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.meetUpWebView loadRequest:request];

    self.networkActivityIndicator.hidesWhenStopped = YES;
    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;

}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.networkActivityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.networkActivityIndicator stopAnimating];

    self.backButton.enabled = self.meetUpWebView.canGoBack;
    self.forwardButton.enabled = self.meetUpWebView.canGoForward;

    self.navigationItem.title = [self.meetUpWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (IBAction)onBackButtonPressed:(id)sender {
    [self.meetUpWebView goBack];

}

- (IBAction)onForwardButtonPressed:(id)sender {
    [self.meetUpWebView goForward];
}

- (IBAction)dismissButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
