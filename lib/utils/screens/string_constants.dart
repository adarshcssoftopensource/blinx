class AppConstants {
  static const requiredName = 'Please enter full name';
  static const requiredEmail = 'Please enter email';
  static const validEmailError = 'Please enter valid email';

  static const requiredPassword = 'Please enter password';
  static const requiredPasswordInPattern =
      'Your password must be 8 to 25 characters long and include at least one uppercase letter, one lowercase letter, number, and one special character.';

  static const requiredOldPassword = 'Please enter old password';
  static const requiredNewPassword = 'Please enter new password';

  static const passwordDoesNotMatch = 'Passwords do not match';

  // Application Form
  static const fieldRequired = 'This field is required';
  static const unauthorized = 'Unauthorized';
  static const loginAgain = 'Please login again to continue';
  static const success = 'Success';
  static const notice = 'Notice';
  static const applicationForm = 'Application Form';
  static const bestFitQuestion = 'Why are you the best fit for this task? *';
  static const bestFitHint = 'I have implemented OAuth flows for...';
  static const executionPlanTitle = 'Your Execution Plan *';
  static const executionPlanHint =
      '1. Research requirements..\n2. Setup initial endpoints..';
  static const availabilityTitle = 'Your Availability *';
  static const availabilityHint = 'e.g., Available 10hrs/week starting Monday';
  static const submitApplication = 'Submit Application';

  // Job Card placeholders (or fixed labels if applicable)
  static const expertTier = 'Expert Tier';
  static const hoursPlaceholder = '~20 Hours';
  static const creditsPlaceholder = '500 Credits';
  static const taskTitlePlaceholder = 'Implement OAuth 2.0 Authentication Flow';
  static const categoryPlaceholder = 'Backend Infrastructure';

  // API & Generic Messages
  static const noMessageAvailable = 'No message available';
  static const unknownError = 'Unknown error occurred';
  static const anErrorOccurred = 'An error occurred';
  static const somethingWentWrong = 'Something went wrong.';
  static const applicationSubmittedSuccess =
      'Application submitted successfully';
  static const alreadyApplied = 'You have already applied for this task.';
  static const sessionExpired = 'Session expired. Please login again.';
  static const tryAgain = 'Something went wrong. Please try again.';

  // Task Submission
  static const add = 'Add';
  static const taskSubmission = 'Task Submission';
  static const definitionOfDone = 'Definition of Done';
  static const dodPlaceholder =
      'Complete all 4 video modules in the portal.\nScore at least 80% on the final quiz.\nSubmit a short reflection on a mock scenario.';
  static const proofOfWork = 'Proof of Work';
  static const proofHint =
      'Describe what you did, any challenges faced, or extra details for the steward_screen...';
  static const uploadPhotos = 'Upload Photos';
  static const uploadVideoOptional = 'Upload Video (Optional)';
  static const submitWork = 'Submit Work';
  static const statusOpen = 'Open';
  static const dueIn2d = 'Due in 2d';
  static const cleanupTaskTitle = 'Organize Local Beach Cleanup';
  static const creditsEcoWarrior = '500 Credits\nEco-Warrior';
  static const addImage = 'Add image';
  static const tapSelectVideo = 'Tap to select video';
  static const camera = 'Camera';
  static const gallery = 'Gallery';
  static const maxPhotosReached = 'You can add up to 5 photos only.';
  static const atLeastOnePhoto = 'Please add at least one photo';
  static const videoCompressionFailed = 'Video compression failed';

  // Marketplace
  static const marketplace = 'Marketplace';
  static const noApplicationsFound = 'No applications found.';
  static const taskLabel = 'Task';
  static const internalCredits = 'Internal Credits';
  static const growsLabel = 'Grows: ';
  static const searchHint = 'Search';
  static const filterApplied = 'Filter applied: ';
  static const allFilter = 'All';
  static const failedToFetchMarketplace = 'Failed to fetch marketplace data';
  static const failed = 'Failed';
  static const noAccessTokenFound = 'No access token found';
  static const viewDetails = 'View Details';
  static const technicalAnalyst = 'Technical Analyst';
  static const serverError = 'Server error';

  // Marketplace Detail
  static const marketplaceDetail = 'Marketplace Detail';
  static const noDataFound = 'No data found.';
  static const applicationUnderReview = 'Application Under Review';
  static const checkYourSubmission = 'Check Your Submission';
  static const applyForTask = 'Apply For Task';
  static const oneHour = '1 Hour';
  static const reward = 'Reward';
  static const reputation = 'Reputation';
  static const requiredProof = 'Required Proof';
  static const pending = 'pending';
  static const approved = 'approved';
  static const rejected = 'rejected';

  // My Submission
  static const missionProofSubmission = 'Mission Proof Submission';
  static const noDataAvailable = 'No Data Available';
  static const mySubmissionsFetched = 'My submissions fetched';

  // Steward Marketplace
  static const noTasksAvailable = 'No tasks available right now.';
  static const refreshPrompt = 'Pull down or tap retry to refresh.';
  static const retry = 'Retry';
  static const memberPrefix = 'Member: @';
  static const reputationTierContributor = 'Reputation Tier: Contributor';
  static const configuredReward = 'Configured Reward';
  static const creditAmount = 'Credit Amount';
  static const creditsLabel = ' Credits';
  static const ifRejecting = 'If rejecting';
  static const rejectReasonHint = 'Reason for resubmission request...';
  static const approve = 'Approve';
  static const reject = 'Reject';
  static const reasonRequired = 'Reason Required';
  static const enterRejectReason = 'Please Enter Reject Reason';
  static const invalidReason = 'Invalid Reason';
  static const reasonMinLength = 'Reason should be minimum 10 characters';
  static const fetchSuccessfully = 'Fetch Successfully';
  static const applicationDetailFetched = 'Application Detail fetched';
  static const applicationApproved = 'Application approved';
  static const applicationRejected = 'Application Rejected';

  // Authentication - General
  static const emailAddress = 'Email Address';
  static const enterEmail = 'Enter your email';
  static const password = 'Password';
  static const enterPassword = 'Enter your password';
  static const loginFailed = 'Login Failed';
  static const noInternet = 'No Internet';
  static const checkInternet = 'Please check your internet connection';
  static const or = 'OR';
  static const signInWithGoogle = 'Sign in with Google';
  static const signUpWithGoogle = 'Sign up with Google';
  static const dontHaveAccount = 'Don\'t have an account? ';
  static const alreadyHaveAccount = 'Already have account? ';
  static const signIn = 'Sign In';
  static const signUp = 'Sign Up';
  static const forgotPasswordLabel = 'Forgot Password?';

  // Sign In Screen
  static const welcomeBack = 'Welcome back! Sign in to your Blinx account';

  // Sign Up Screen
  static const fullName = 'Full name';
  static const enterFullName = 'Enter your full name';
  static const passwordStrengthError =
      'Password must contain uppercase, lowercase, special character & 8+ characters';
  static const agreeToTerms = 'By signing up, you agree to our ';
  static const termsOfUse = 'Terms of Use';
  static const privacyPolicy = 'Privacy Policy';
  static const and = ' and ';
  static const pleaseWait = 'Please wait';
  static const takePhoto = 'Take a photo';
  static const chooseFromGallery = 'Choose from gallery';

  // Forgot Password Screen
  static const forgotPasswordTitle = 'Forgot password';
  static const forgotPasswordSubtitle =
      'Please enter your email address to reset\nyour password';
  static const next = 'Next';

  // Reset Password Screen
  static const resetPasswordTitle = 'Reset password';
  static const resetPasswordSubtitle = 'Please reset your password to continue';
  static const newPassword = 'New Password';
  static const newPasswordHint = 'New password';
  static const confirmPassword = 'Confirm Password';
  static const confirmPasswordHint = 'Confirm password';
  static const requiredConfirmPassword = 'Please confirm your password';
  static const resetPassword = 'Reset Password';

  // OTP Verification Screen
  static const otpVerificationTitle = 'OTP Verification';
  static const otpVerificationSubtitle =
      'Enter the verification code we just sent to you ';
  static const enterOtp = 'Enter OTP';
  static const resendOtp = 'Resend OTP';
  static const completeOtpError = 'Please enter complete OTP';
  static const verifyOtp = 'Verify OTP';

  // Change Password Screen
  static const changePassword = 'Change Password';
  static const currentPassword = 'Current Password';
  static const enterOldPassword = 'Enter your old password';
  static const enterNewPassword = 'Enter your new password';
  static const enterConfirmPassword = 'Enter your confirm password';
  static const updatePassword = 'Update Password';

  static const selectTopic = 'Select a Topic';
  static const noTopicsFound = 'No topics found';

  // Topic names
  static const safety = 'safety';
  static const environment = 'environment';
  static const communityEvents = 'community events';
  static const localBusiness = 'local business';
  static const publicSpaces = 'public spaces';
  static const infrastructure = 'infrastructure';

  // Topic icons
  static const safeIcon = 'safe';
  static const environmentIcon = 'environment';
  static const communityIcon = 'community';
  static const localIcon = 'local';
  static const publicIcon = 'public';
  static const infrastructureIcon = 'infrastructure';

  // Asset paths
  static const iconPath = 'assets/icons/';

  // Share screen
  static const shareBlink = 'Share Blink';
  static const shareVia = 'Share Via';

  // Share platforms
  static const whatsapp = 'WhatsApp';
  static const facebook = 'Facebook';
  static const copyLink = 'Copy Link';
  static const instagram = 'Instagram';
  static const twitter = 'Twitter';

  // Friend avatar
  static const check = 'check';

  // Settings screen
  static const settings = 'Settings';
  static const manageIndividualAlerts = 'Manage individual alerts';

  // Settings items
  static const language = 'Language';
  static const notifications = 'Notifications';
  static const dataPreferences = 'Data Preferences';
  static const privacySecurity = 'Privacy & Security';
  static const draft = 'Draft';
  static const blockedUsers = 'Blocked Users';

  // Select topic screen
  static const search = 'Search';
  static const existingTopics = 'Existing Topics';

  // Report success screen
  static const reportedSuccessfully = 'Reported Successfully';
  static const backToHome = 'Back to home';

  // Report screen
  static const report = 'Report';
  static const reportReasonTitle = 'Select a reason for reporting this Blink';

  static const reportReasonSubtitle =
      "Help us understand what's wrong with this post";

  static const description = 'Description';
  static const submit = 'Submit';

  // Report options
  static const safetyConcern =
      'Safety concern (e.g., harmful, threatening content)';

  static const spam = 'Spam (irrelevant or repeated posts)';

  static const offTopic = 'Off-topic (not related to the community or context)';

  static const privacyViolation =
      'Privacy violation (sharing personal or sensitive info)';

  // Recent safety screen
  static const recent = 'Recent';
  static const nearby = 'Nearby';
  static const noBlinksYet = 'No blinks yet!';
  static const verified = 'Verified';
  static const dotSeparator = ' · ';
  static const justNow = 'Just now';
  static const minuteAgo = 'm ago';
  static const hourAgo = 'h ago';
  static const dayAgo = 'd ago';
  static const weekAgo = 'w ago';
  static const empty = '';

  // Image assets
  static const leftVector = 'left_vector.png';
  static const verifiedIcon = 'verified';

  // Post detail screen
  static const blinkDetails = 'Blink Details';
  static const relatedTopics = 'Related Topics';
  static const noRelatedTopics = 'No related topics';
  static const reportThisBlinks = 'Report this Blinks';
  static const blockUser = 'Block user';

  // Asset names
  static const reportIcon = 'report';
  static const blockIcon = 'block';

  // Count suffix
  static const thousandSuffix = 'k';
  static const blinks = ' Blinks';

  //No Public Blinx Yet Screen
  static const enableBluetoothToDetectNearbyBlinksAndSendProximityAlerts =
      'Enable Bluetooth to detect nearby Blinks and send proximity alerts.';
  static const bluetooth = 'Bluetooth';
  static const turnOnBluetoothToView = 'Turn on Bluetooth to view';
  static const thereMightBeBlinksNearYou = 'There might be blinks near you';
  static const ItsABitQuietHereBeTheFirstToShareSomethingInterestingInYourArea =
      'It\'s a bit quiet here. Be the first to share something interesting in your area!';
  static const noPublicBlinxYet = 'No Public Blinx Yet';
  static const share = 'Share';

  //No Posts Yet Screen
  static const noPostsYet = 'No Posts Yet';
  static const postTheFirstBlinx = 'Post the First Blinx';
  static const LetsMakeYourFirstBlinxStartWithAPhotoNoteOrPlace =
      'Let\'s make your first Blinx. Start with a photo, note, or place.';
  static const location = 'Location';
  static const toFindNearbyBlinksWeNeedYourLocationYouCanChangeThisAnytime =
      'To find nearby Blinks, we need your Location.\nYou can change this anytime.';
  static const allow = 'Allow';
  static const notNow = 'Not Now';

  //Home Screen
  static const nearBlinks = 'There might be blinks near you';
  static const yourFirstBlinxWithPhoto =
      "Let's make your first Blinx. Start with a photo, note, or place.";
  static const connectionErrorHandling =
      'We can\'t seem to connect to the internet. Please check your connection';
  static const connectionError = 'Connection Error';
  static const yourFirstBlinx =
      "Let's make your first Blinx. Start with a photo, note, or place.";

  //Draft Screen
  static const noDraftsFound = 'No drafts found';
  static const draftDetails = 'Draft Details';
  static const save = 'Save';
  static const publish = 'Publish';
  static const selectImage = 'Select Image';
  static const removeImage = 'Remove Image';
  static const cancel = 'Cancel';
  static const user = 'User';
  static const private = 'Private';
  static const public = 'Public';
  static const postVisibility = 'Post Visibility';
  static const charactersAllowed = 'Maximum 500 characters allowed';

  // Create Post Screen
  static const whatDoYouWantToTalkAbout = 'What do you want to talk about?';
  static const imageVideoPreview = 'Image/Video Preview';
  static const theBlinxPostWillSharePublicly =
      'The blink post will share publicly to everyone';
  static const theBlinxPostWillSharePrivately =
      'The blink post will share with user only (Privately)';
  static const selectATopicRequired = 'Select a Topic*';
  static const saveAsDraft = 'Save as Draft';
  static const publishPost = 'Publish';
  static const pleaseWriteSomethingBeforeSavingAsDraft =
      'Please write something before saving as draft!';
  static const pleaseSelectTopicBeforeSavingAsDraft =
      'Please select a topic before saving as draft!';
  static const pleaseSelectTopicBeforePublishing =
      'Please select a topic before publishing!';
  static const pleaseWriteSomethingBeforePublishing =
      'Please write something before publishing!';
  static const topicRequired = 'Topic Required';
  static const pleaseSelectTopicFirst = 'Please select a topic first!';
  static const limitExceeded = 'Limit Exceeded';
  static const contentCannotExceed500 = 'Content cannot exceed 500 characters';

  // Comments Screen
  static const comments = 'Comments';
  static const noCommentsYet = 'No comments yet. Be the first!';
  static const writeYourMessage = 'Write your message...';
  static const deleteComment = 'Delete Comment';
  static const areYouSureDeleteComment =
      'Are you sure you want to delete this comment?';
  static const deleteReply = 'Delete Reply';
  static const areYouSureDeleteReply =
      'Are you sure you want to delete this \nreply?';
  static const delete = 'Delete';
  static const replyingTo = 'Replying to ';
  static const liked = 'Liked';
  static const like = 'Like';
  static const reply = 'Reply';

  // Connection Error Screen
  static const weCannotConnectToInternet =
      'We can\'t seem to connect to the internet. Please check your connection';
  static const williamson = 'Williamson';
  static const alanaUser = 'Alana Maesya';
  static const fiftyMinAgo = '50m ago';
  static const halfMileAway = '0.5 miles away';
  static const fashionDescription =
      'In 2025, fashion is all about blending sustainability with bold creativity. Expect vibrant colors.';
  static const hashtagEnvironment = '#Environment';
  static const hashtagSafety = '#Safety';
  static const likesCount = '212';
  static const commentsCount = '2k';
  static const sharesCount = '5x';

  // Bluetooth Screen
  static const bluetoothTitle = 'Bluetooth';
  static const bluetoothDescription =
      'Enable Bluetooth to detect nearby Blinks and send proximity alerts.';
  static const findingNearbyBlinxUsers = 'Finding nearby Blinx users...';
  static const noNearbyBlinxUsersFound = 'No nearby Blinx users found';
  static const metersAway = 'm away';

  // Blocked Users Screen
  static const blockedUsersTitle = 'Blocked Users';
  static const noBlockedUsers = 'No blocked users';
  static const unblock = 'Unblock';

  // ── Mission Activity Screen ──────────────────────────────────────────────────
  static const missionActivityTitle = 'Mission Activity';
  static const activityTimeline = 'Activity Timeline';
  static const noActivityYet = 'No activity yet.';
  static const failedToLoadActivity =
      'Failed to load activity.\nPlease try again.';
  static const expertRewards = 'Expert Rewards';
  static const creditsRewardTitle = 'Credits';
  static const creditsRewardSubtitle = 'Will be added on approval';
  static const reputationRewardTitle = 'Reputation';
  static const reputationRewardSubtitle = 'Environment   •   Community';
  static const viewSubmitProof = 'View Submit Proof';
  static const eventTypeClaimed = 'claimed';
  static const eventTypeProofSubmitted = 'proof_submitted';
  static const eventTypeUnderReview = 'under_review';
  static const eventTypeCreditApproved = 'credit_approved';
  static const titleMissionClaimed = 'Mission Claimed';
  static const titleProofSubmitted = 'Proof Submitted';
  static const titleUnderReview = 'Under Review';
  static const titleCreditApproved = 'Credit Approved';
  static const photos = 'photos';
  static const characters = 'Characters';

  // ── Mission Detail Screen ────────────────────────────────────────────────────
  static const missionDetailTitle = 'Mission Detail';
  static const failedToLoadMission =
      'Failed to load mission details.\nPlease try again.';
  static const tabCommunity = 'Community';
  static const tabWeekly = 'Weekly';
  static const postedTimeAgo = 'posted 2d ago';
  static const viewsCount = '234 views';
  static const sectionLocation = 'Location';
  static const viewOnMap = 'View on Map';
  static const sectionDuration = 'Duration';
  static const sectionDifficulty = 'Difficulty';
  static const sectionRewards = 'Rewards';
  static const sectionCredits = 'Credits';
  static const sectionCommunityRep = 'Community Rep';
  static const sectionRequirements = 'Requirements';
  static const requirementProfileComplete = 'Profile Complete Required';
  static const requirementProfileCompleteSubtitle =
      'You must complete your profile before claiming this feature';
  static const requirementAge = 'Age 18+';
  static const requirementBackgroundCheck = 'Background check completed';
  static const requirementBackgroundCheckSubtitle =
      'Background check is required to claim this mission';
  static const requirementPhysicalCapable = 'Physical activity capable';
  static const requirementPhysicalCapableSubtitle =
      'Must be physically capable to complete this mission';
  static const photoRequired = 'Photo Required';
  static const notesRequired = 'Notes Required';
  static const completeProfileToClaim =
      'Complete your profile to claim this mission';
  static const claimNow = 'Claim now';
  static const completeProfileToClaimBtn = 'Complete Profile to Claim';
  static const saveForLater = 'Save for later';

  // ── Missions Screen ──────────────────────────────────────────────────────────
  static const filterAvailable = 'Available';
  static const filterActive = 'Active';
  static const filterSubmitted = 'Submitted';
  static const filterCompleted = 'Completed';
  static const statusAvailable = 'available';
  static const statusActive = 'active';
  static const status = 'status';
  static const statusSubmitted = 'submitted';
  static const statusCompleted = 'completed';
  static const noMissionsAvailable = 'No missions available right now';
  static const viewSubmission = 'View Submission';
  static const submitProofBtn = 'Submit Proof';
  static const startBtn = 'Start';

  // ── Missions Refresh Screen ──────────────────────────────────────────────────
  static const pullToRefresh = 'Pull to refresh';
  static const noMissionsAvailableTitle = 'No Missions Available';
  static const noMissionsAvailableDesc =
      'There are currently no missions in this\ncategory. Check back later for new opportunities\nor try adjusting your filters.';
  static const refreshList = 'Refresh List';

  // ── Onboarding Screen ────────────────────────────────────────────────────────
  static const onboardingTitle1 = 'Share Local Updates';
  static const onboardingDesc1 =
      'Instantly post what\'s happening around you. Keep your community informed and connected.';
  static const onboardingTitle2 = 'Discover Nearby Info';
  static const onboardingDesc2 =
      'Explore a live feed of events, news, and alerts happening right in your neighborhood.';
  static const onboardingTitle3 = 'Contribute to Awareness';
  static const onboardingDesc3 =
      'Your posts help build a safer, more aware community. Be the eyes and ears of your area.';
  static const onboardingSkip = 'Skip';
  static const onboardingNext = 'Next';
  static const onboardingFinish = 'Finish';

  // ── Submit Proof Screen ──────────────────────────────────────────────────────
  static const submitProofTitle = 'Submit Proof';
  static const submitProofMissionName = 'Community Garden Voluntary Mission';
  static const submitProofStatusActive = 'Active';
  static const submitProofDuration = '2–3 hours';
  static const submitProofDifficulty = 'Beginner';
  static const submitProofSubtitle =
      'Submit your proof of completion to earn rewards';
  static const uploadPhotosTitle = 'Upload Photos';
  static const addPhoto = 'Add Photo';
  static const uploadPhotoInfo =
      'Upload 4 clear photos for showing your complete work.';
  static const additionalNotes = 'Additional notes';
  static const additionalNotesHint =
      'Describe what you did, any challenges faced, and what you learned...';
  static const submissionRequirements = 'Submission Requirements';
  static const minPhotosRequired = 'Minimum 2 photos required';
  static const minPhotosAdded = '1 photo added';
  static const minCharsRequired = 'Minimum 50 characters required';
  static const whatHappensNext = 'What Happens Next?';
  static const stepSubmitProof = 'Submit Proof';
  static const stepSubmitSubtitle = 'Upload photos and notes';
  static const stepUnderReview = 'Under Review';
  static const stepUnderReviewSubtitle =
      'Mission coordinator reviews submission';
  static const stepRewardsEarned = 'Rewards Earned';
  static const stepRewardsSubtitle =
      'Credits and reputation added to your profile';
  static const submitProofButton = 'Submit Proof';
  static const cancelLabel = 'Cancel';
  static const cameraOption = 'Camera';
  static const galleryOption = 'Gallery';

  // ── View Submit Screen ───────────────────────────────────────────────────────
  static const viewSubmitProofTitle = 'View Submit Proof';
  static const failedToLoadSubmission =
      'Failed to load submission.\nPlease try again.';
  static const proofPhotos = 'Proof photos';
  static const noPhotosSubmitted = 'No photos submitted';
  static const additionalNotesLabel = 'Additional notes';
  static const statusApproved = 'approved';
  static const statusRejected = 'rejected';
  static const statusApprovedText = 'Approved';
  static const statusRejectedText = 'Rejected';
  static const statusPendingText = 'Pending';

  // ── Wallet Screen 1 ──────────────────────────────────────────────────────────
  static const walletTitle = 'Wallet';
  static const availableCredits = 'Available Credits';
  static const microGrantsBalance = 'Micro-grants Balance';
  static const creditsBalanceNonCash = 'Credits balance (non‑cash)';
  static const walletApproved = 'Approved';
  static const walletDisclaimer =
      'The Blinx Wallet is an informational ledger only. Blinx does not '
      'hold funds or process financial transactions.';
  static const reputationScore = 'Reputation Score';
  static const reputationDataPending = 'Reputation data is pending';
  static const recentActivity = 'Recent Activity';
  static const seeAll = 'See All';
  static const missionCompleted = 'Mission Completed';
  static const yesterday = 'Yesterday';
  static const creditAmountDisplay = '+00 CR';
  static const postedStatus = 'Posted';

  // ── Wallet Screen 2 ──────────────────────────────────────────────────────────
  static const recentActivityTitle = 'Recent Activity';

  // ── Reset Password Screen ────────────────────────────────────────────────────
  static const pleaseEnterNewPassword = 'Please enter new password';
  static const passwordStrengthFullError =
      'Password must be at least 8 characters and include uppercase, lowercase, number & special character';
  static const pleaseConfirmPassword = 'Please confirm your password';
  static const passwordsDoNotMatch = 'Passwords do not match';

  // Create Plan Screen
  static const createPlan = 'Create plan';
  static const title = 'Title';
  static const planTitle = 'Plan title';
  static const summary = 'Summary';
  static const shortSummary = 'Short summary...';
  static const dates = 'Dates';
  static const selectDates = 'Select dates';
  static const place = 'Place';
  static const loadingPlaces = 'Loading places...';
  static const noSavedPlaces = 'No saved places';
  static const selectPlaces = 'Select places';
  static const done = 'Done';
  static const savePlan = 'Save';

  // Validation & Snackbar Messages
  static const pleaseEnterTitle = 'Please enter a title';
  static const pleaseSelectDates = 'Please select dates';
  static const planCreatedSuccessfully = 'Plan created successfully!';

  // Plan Detail Screen
  static const savedPlaces = 'Saved Places';
  static const noPlacesAddedYet = 'No places added yet';
  static const addPlacesToTripPlan =
      'Add places to your trip plan and manage them easily.';
  static const addPlace = '+ Add place';
  static const continuePlanning = 'Continue Planning →';

  // Plans Screen
  static const plans = 'Plans';
  static const noUpcomingPlansYet = 'No upcoming plans yet';
  static const newPlan = '+ New Plan';

  // Saved Places Screen
  static const selectMultiplePlaces = 'Select multiple places';
  static const noSavedPlacesFound = 'No saved places found';
  static const savePlanning = 'Save Planning';

  // Snackbar Messages
  static const planSavedSuccessfully = 'Plan saved successfully!';
  static const failedToSavePlaces =
      'Failed to save some places. Please try again.';

  // Tune Your World
  static const tuneYourWorld = 'Tune Your World';
  static const saveInterests = 'Save Interests';

  // Edit Profile Screen
  static const editProfile = 'Edit Profile';
  static const name = 'Name';

  // Common
  static const String edit = "Edit";
  static const String logout = "Logout";
  static const String member = "Member";

  // Profile
  static const String profile = "Profile";
  static const String loggedOutSuccessfully = "Logged Out Successfully";

  // Plans
  static const String addPlacesToYourTrip =
      "Add places to your trip plan and manage them easily.";

  // Profile Tabs
  static const String posts = "Posts";
  static const String saved = "Saved";

  // Profile Sections
  static const String upcomingPlans = "Upcoming Plans";
  static const String sharedPlans = "Shared Plans";
  static const String interests = "Interests";
  static const String communityStanding = "Community Standing";

  // Upcoming Plan Detail
  static const String upcomingPlanDetail = "Upcoming Plan Detail";
  static const String places = "Places";
  static const String upcoming = "UPCOMING";
  // Upcoming Plans
  static const String searchPlans = "Search plans...";

  // Shared Plans
  static const String searchSharedPlans = "Search shared plans...";
  static const String noSharedPlansYet = "No shared plans yet";

  // Shared Plan Detail
  static const String sharedPlanDetail = "Shared Plan Detail";
  static const String saveToMyPlans = "Save to My Plans";
  static const String noSavedPlacesYet = "No Saved Places Yet";
  static const String profileProgress = 'Profile Progress';
  static const String profileProgressScreen = 'Profile Progress Screen';
}
