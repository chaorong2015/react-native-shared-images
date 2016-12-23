'use strict';
const { NativeModules } = require('react-native');
const RCTSharedImages = NativeModules.SharedImages;
module.exports.SharedImages = {
	/**
   * Display the iOS share sheet. The `options` object should contain
   * one or both of `message` and `url` and can additionally have
   * a `subject` or `excludedActivityTypes`:
   *
   * - `url` (string) - a URL to share
   * - `message` (string) - a message to share
   * - `subject` (string) - a subject for the message
   * - `excludedActivityTypes` (array) - the activities to exclude from the ActionSheet
   *
   * NOTE: if `url` points to a local file, or is a base64-encoded
   * uri, the file it points to will be loaded and shared directly.
   * In this way, you can share images, videos, PDF files, etc.
   */
  shareImages: (options) => {
    // console.log('RCTSharedImages=share=', RCTSharedImages);
    return new Promise((resolve, reject) => {
      RCTSharedImages.shareImages(options,(error, data) => {
        if (error) {
          console.log(error);
          return reject(error);
        } else {
          console.log(data);
          resolve(data);
        }
    });
    });
  },
  shareUrl: (options) => {
    // console.log('RCTSharedImages=share=', RCTSharedImages);
    return new Promise((resolve, reject) => {
      RCTSharedImages.shareUrl(options,(error, data) => {
        if (error) {
          console.log(error);
          return reject(error);
        } else {
          console.log(data);
          resolve(data);
        }
    });
    });
  },
  testPrint: () => {
    console.log('NativeModules=testPrint=', NativeModules);
  	console.log('RCTSharedImages=testPrint=', RCTSharedImages);
    return new Promise((resolve, reject) => {
	    RCTSharedImages.testPrint("test message",(error, data) => {
			  if (error) {
			    console.log(error);
			    return reject(error);
			  } else {
			    console.log(data);
			    resolve(data);
			  }
		});
    });
  }
};