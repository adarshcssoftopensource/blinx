class ImageConstants {
  static const imagePath = 'assets/images/';
  static const imagePathPng = 'assets/icons/';
  static const imagePathSvg = 'assets/svg/';

  static const commentIcon = '${imagePath}comment_icon.png';
  static const dummyPostImage = '${imagePath}dummy_post_image.png';

  static const image1 = '${imagePath}image1.png';
  static const image2 = '${imagePath}image2.png';
  static const image3 = '${imagePath}Image3.png';

  static const likeIcon = '${imagePath}like_icon.png';
  static const redLikeIcon = '${imagePath}red_like_icon.png';

  static const profilePic = '${imagePath}profile_pic.png';
  static const sendIcon = '${imagePath}send_icon.png';
  static const shareIcon = '${imagePath}share_icon.png';
  static const verifiedIcon = '${imagePath}verified_icon.png';
  static const reportFlagIcon = '${imagePath}report_flag_icon.png';
  static const blinxLogo = '${imagePath}blinx_logo.png';
  static const williamson = '${imagePath}williamson.png';

  static const redFlag = '${imagePathPng}ic_flag.png';

  //SVG
  static const crossIcon = '${imagePathSvg}ic_cross.svg';
}

class CommonUi {
  static String setSvgImage(String image) {
    return 'assets/svg/$image.svg';
  }

  static String setPngImage(String image) {
    return 'assets/images/$image.png';
  }

  static String setPngIcon(String image) {
    return 'assets/icons/$image.png';
  }
}
