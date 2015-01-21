//
//  ImageViewController.m
//  imaginarium2
//
//  Created by Andres Kwan on 12/2/14.
//  Copyright (c) 2014 Kwan Castle. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()<UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIImage * image;
@property (nonatomic, strong)UIImageView *logoView;
@property (nonatomic, strong)UIImage * imageLogo;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.logoView];
    //whit this line of code
    //there is no need of the delegate
    self.navigationItem.leftBarButtonItem = [self.splitViewController displayModeButtonItem];
    UIViewController * masterVC = self.navigationController.splitViewController.viewControllers[0];
    UIViewController * detailVC = self.navigationController.splitViewController.viewControllers[1];
    NSLog(@"TILE????: %@, lastObj %@",masterVC.title, self.navigationController.splitViewController.viewControllers.firstObject);
    self.navigationItem.leftBarButtonItem.title = masterVC.title;
    self.navigationItem.leftItemsSupplementBackButton = true;
}

#pragma mark - Propiedades
- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.1;
    _scrollView.delegate = self;
    
    self.scrollView.contentSize = self.image? self.image.size : CGSizeZero;
}

- (UIImage *)image
{
    NSLog(@"self.imageView.image is nil? %@",self.imageView.image);
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    self.scrollView.zoomScale = 1.0;
    self.imageView.image = image; // does not change the frame of the UIImageView
    self.imageView.frame = CGRectMake(0,0,image.size.width, image.size.height);
    self.scrollView.contentSize = self.image? self.image.size : CGSizeZero;
    [self.spinner stopAnimating];
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
//    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]]; // blocks main queue!
    [self startDownloadingImage];
}

- (UIImageView *)logoView
{
    UIImage * imgLogo = [UIImage imageNamed:@"stanford-logo"];
    if (!_logoView) _logoView = [[UIImageView alloc]initWithImage:imgLogo];
    _logoView.frame  = CGRectMake(0.0, 0.0, imgLogo.size.width/4, imgLogo.size.height/4);
    _logoView.center = CGPointMake(25.0, 35.0);
    return _logoView;
}

#pragma mark - UIScrollViewDelegate

// mandatory zooming method in UIScrollViewDelegate protocol

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - Multithreading
- (void)startDownloadingImage
{
    [self.spinner startAnimating];
    self.image = nil;
    
    if (self.imageURL) {
        NSURLRequest * request = [NSURLRequest requestWithURL:self.imageURL];
        
        //background task to handle the download
        // another configuration option is backgroundSessionConfiguration (multitasking API required though)
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        // create the session without specifying a queue to run completion handler on (thus, not main queue)
        // we also don't specify a delegate (since completion handler is all we need)
        NSURLSession * session = [NSURLSession sessionWithConfiguration:config];
//                                                                       delegate:nil
//                                                                  delegateQueue:nil];
        
        NSURLSessionDownloadTask * task = [session downloadTaskWithRequest:request
         completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
             //what happend when done?
             if (!error) {
                 //take in count time!!!
                 //what about if the user ask for another picture?
                 if ([request.URL isEqual:self.imageURL]) {
                     //No in the main queue
                     UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                     //this should happen in the main thread
                     //                         dispatch_async(dispatch_get_main_queue(), ^{self.image = image;});
                     //another way to do it
                     [self performSelectorOnMainThread:@selector(setImage:)
                                            withObject:image
                                         waitUntilDone:NO];
                     
                 }
             }
         }];
        [task resume];
    }
}

#pragma mark - UISplitViewControllerDelegate
//- (void)awakeFromNib
//{
//    self.splitViewController.delegate = self;
//}
//
//- (BOOL)splitViewController:(UISplitViewController *)svc
//   shouldHideViewController:(UIViewController *)vc
//              inOrientation:(UIInterfaceOrientation)orientation
//{
//    return UIInterfaceOrientationIsPortrait(orientation);
//}
//
//-(void)splitViewController:(UISplitViewController *)svc
//    willHideViewController:(UIViewController *)aViewController
//         withBarButtonItem:(UIBarButtonItem *)barButtonItem
//      forPopoverController:(UIPopoverController *)pc
//{
//    barButtonItem.title = aViewController.title;
//    self.navigationItem.leftBarButtonItem = barButtonItem;
//}
//
//- (void)splitViewController:(UISplitViewController *)svc
//     willShowViewController:(UIViewController *)aViewController
//  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
//{
//    self.navigationItem.leftBarButtonItem = nil;
//}
@end
