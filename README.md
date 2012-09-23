QLPreviewPanel+AdditionalViews
========

An extension for the OSX cocoa class QLPreviewPanel which is used to show and control Apple's Quicklook panel. (10.7+).<br/>
The Category provides two new properties to the PreviewPanel to set additional views in the titlebar. (iOS-like)


    @property(nonatomic, retain) NSView *leftBarView;
    @property(nonatomic, retain) NSView *rightBarView;

![Screenshot](http://github.com/Daij-Djan/QuicklookAdditionalViews/raw/master/screenshot.png)

---
The Extension works in any cocoa app, uses no private API and has no dependencies. The code uses method Swizzling and associative storage [shady but cool] to get the runtime to 'integrate' our category and even do it _automatically_ (only drop in the file and you're good to go!)

