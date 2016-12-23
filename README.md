# react-native-shared-images
＃ iOS 分享链接 多张图片
#### iOS
1. `npm install react-native-shared-images --save`
2. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
3. Go to `node_modules` ➜ `react-native-camera` and add `RNImageWatermark.xcodeproj`
4. In XCode, in the project navigator, select your project. Add `RNImageWatermark.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
5. Click `RNImageWatermark.xcodeproj` in the project navigator and go the `Build Settings` tab. Make sure 'All' is toggled on (instead of 'Basic'). In the `Search Paths` section, look for `Header Search Paths` and make sure it contains both `$(SRCROOT)/../../../node_modules/react-native/React` - mark both as `recursive`.
5. Run your project (`Cmd+R`)

```js

####使用说明

##1、先引用库
import { SharedImages } from 'react-native-shared-images';

##2、接口说明
/*分享多张图片*
＊@para option {
	imagePaths         array   数组，存放图片物理地址
}
*/
await SharedImages.shareImages(option);

/*分享链接*
＊@para option {
	url         String   存放链接地址
}
*/
await SharedImages.shareUrl(option);
