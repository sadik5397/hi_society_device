//CodeSnippets
//region ---------- Authorization ----------
String i18n_enterEmail(bool isBN) => isBN ? 'ইমেইল আইডি দিন (হাই সোসাইটির জন‍্য)' : 'Enter Hi Society email';
String i18n_enterPassword(bool isBN) => isBN ? 'পাসওয়ার্ড দিন' : 'Enter Password';
String i18n_requiredField(bool isBN) => isBN ? 'এই ঘর পূরণ করতে হবে' : 'This field is required';
String i18n_login(bool isBN) => isBN ? 'লগ-ইন' : 'Login';
String i18n_invalidEntry(bool isBN) => isBN ? 'তথ‍্য সঠিক নয়, দয়া করে আবার দেখুন' : 'Invalid entry! Please check';
String i18n_havingTroubleLogin(bool isBN) => isBN ? 'লগ-ইন করতে সমস্যা? ' : 'Having trouble login?';
String i18n_pleaseContact(bool isBN) => isBN ? "'হাই সোসাইটি'-র সাথে যোগাযোগ করুন" : 'Please contact HI SOCIETY';
//endregion

//region ---------- Home ----------
String i18n_appTitle(bool isBN) => isBN ? 'হাই সোসাইটি' : 'Hi Society';
String i18n_visitorManagement(bool isBN) => isBN ? 'ভিজিটার ম্যানেজমেন্ট' : 'Visitor Management';
String i18n_deliveryManagement(bool isBN) => isBN ? 'পার্সেল ডেলিভারি' : 'Delivery Management';
String i18n_digitalGatePass(bool isBN) => isBN ? 'ডিজিটাল গেট পাস' : 'Digital Gate Pass';
String i18n_intercom(bool isBN) => isBN ? 'ইন্টার-কম' : 'Intercom';
String i18n_requiredCarParking(bool isBN) => isBN ? 'কার পার্কিং ব্যবস্থাপনা' : 'Required Car Parking';
String i18n_overstayAlert(bool isBN) => isBN ? 'অধিক রাত্রিতে ফের' : 'Overstay Requests';
String i18n_utilityContacts(bool isBN) => isBN ? 'জরুরী কাজের লোক' : 'Utility Contacts';
String i18n_residents(bool isBN) => isBN ? 'বসবাসকারী' : 'Residents';
String i18n_tapSwitchGuard(bool isBN) => isBN ? 'গার্ড প্রোফাইলে যেতে ক্লিক করুন' : 'Tap to switch Guard profile';
String i18n_deActiveDevice(bool isBN) => isBN ? 'ডিএক্টিভেট ডিভাইস' : 'Deactivate Device';
String i18n_switchProfile(bool isBN) => isBN ? 'গার্ড প্রোফাইল পরিবর্তন করুন' : 'Switch Guard Profile';
//endregion

//region ---------- Delivery Management ----------
String i18n_rcvParcel(bool isBN) => isBN ? 'পার্সেল গ্রহণ করতে' : 'Receive Parcel';
String i18n_dsbParcel(bool isBN) => isBN ? 'পার্সেল বিলি করতে' : 'Disburse Parcel';
String i18n_flat(bool isBN) => isBN ? 'ফ্লাট' : 'Flat';
String i18n_whichFlat(bool isBN) => isBN ? 'কোন ফ্লাটে যেতে চাই?' : 'Which Flat to Go?';
String i18n_itemType(bool isBN) => isBN ? 'আইটেম টাইপ / শ্রেণী নির্বাচন করুন ' : 'Item Type';
String i18n_whatItem(bool isBN) => isBN ? 'কোন আইটেম?' : 'What Item?';
String i18n_merchant(bool isBN) => isBN ? 'বিক্রেতা' : 'Merchant';
String i18n_whichMerchant(bool isBN) => isBN ? 'কোন বিক্রেতা?' : 'Which Merchant?';
String i18n_deliverMethod(bool isBN) => isBN ? 'ডেলিভারি পদ্ধতি' : 'Deliver Method';
String i18n_next(bool isBN) => isBN ? 'পরবর্তী' : 'Next';
String i18n_submit(bool isBN) => isBN ? 'জমা' : 'Submit';
String i18n_cancel(bool isBN) => isBN ? 'বাতিল' : 'Cancel';
String i18n_tryAgain(bool isBN) => isBN ? 'আবার চেষ্টা করুন' : 'Try Again';
String i18n_goHome(bool isBN) => isBN ? 'মূল মেনুতে ফেরৎ যেতে' : 'Go to Main Screen';
String i18n_cantRcv(bool isBN) => isBN ? 'পার্সেলটি এখন গ্রহণ করতে পারছি না' : 'Can\'t Receive Parcel Now';
String i18n_pleaseWait(bool isBN) => isBN ? 'দয়া করে অপেক্ষা করুন' : 'Please Wait';
String i18n_timeOut(bool isBN) => isBN ? 'সময় শেষ' : 'Time Out';
String i18n_parcelRcvd(bool isBN) => isBN ? 'পার্সেল গ্রহণ করা হয়েছে' : 'Parcel Received';
String i18n_residentsResponse(bool isBN) => isBN ? 'পার্সেল গ্রহীতার উত্তর' : 'Resident\'s Response';
String i18n_enterCode(bool isBN) => isBN ? 'পরবর্তীতে পার্সেল নেয়ার জন্য ওটিপি' : 'Enter Pickup Parcel Later OTP Below';
String i18n_pickupCodeNoEmpty(bool isBN) => isBN ? 'ওটিপির ঘর খালি থাকা যাবে না' : 'Pickup Code Mustn\'t be Empty';
String i18n_orScanQr(bool isBN) => isBN ? 'অথবা QR স্ক্যান করুন' : 'Or, Scan QR';
String i18n_rcvParcelQrLine1(bool isBN) => isBN ? 'আপনার পার্সেলটি পরে নেয়ার জন্য ওটিপি/কিউআর' : 'If you have a Pickup Parcel Later OTP with QR code,';
String i18n_rcvParcelQrLine2(bool isBN) => isBN ? 'কোডটি বের করুন এবং ক‍্যামেরার সামনে ধরুন' : 'Open it and face it to the screen';
String i18n_rcvParcelQrLine3(bool isBN) => isBN ? 'কিউআর কোডটি স্ক‍্যান করুন' : 'Scan The QR Code';
String i18n_qrFound(bool isBN) => isBN ? 'কিউআর কোড পাওয়া গেছে! "পরবর্তী" টিপুন' : 'QR Code Found! Tap Submit to Proceed';
String i18n_qrTrouble(bool isBN) => isBN ? 'কিউআর কোডটি স্ক‍্যান করতে সমস‍্যা?' : 'Having Trouble Scanning QR Code?';
String i18n_typeManually(bool isBN) => isBN ? 'কোড টি নিজে লিখুন' : 'Type the CODE Manually';
String i18n_arrivedAt(bool isBN) => isBN ? 'পৌঁছানো সময়' : 'Arrived at';
String i18n_weFound(bool isBN) => isBN ? 'আমরা আপনার পার্সেলটি পেয়েছি / পার্সেলটি পাওয়া গেছে' : 'We’ve found your';
String i18n_weNoFound(bool isBN) => isBN ? 'দুঃখিত! আপনার পার্সেলটি পাওয়া যাচ্ছে না!!' : 'Sorry!! We did not find your';
String i18n_parcel(bool isBN) => isBN ? 'পার্সেল' : 'PARCEL';
String i18n_deliverParcelAtCustomersDoor(bool isBN) => isBN ? 'কাস্টমারের দরজায় দিয়ে আসতে চাই' : 'I want to deliver the parcel at customer\'s door';
String i18n_customerComeDownHereToReceive(bool isBN) => isBN ? 'কাস্টমারের নিচে এসে নিজে গ্রহণ করুক' : 'I want customer come down here to receive';
String i18n_dropParcelHere(bool isBN) => isBN ? 'পার্সেলটি এখানে রেখে যেতে চাই (পেইড)' : 'I want to drop the parcel here (PAID)';
String i18n_product(bool isBN) => isBN ? 'প্রোডাক্ট' : 'Product';
String i18n_food(bool isBN) => isBN ? 'খাবার' : 'Food';
String i18n_medicine(bool isBN) => isBN ? 'ঔষুধ' : 'Medicine';
String i18n_document(bool isBN) => isBN ? 'কাগজপত্র' : 'Document';
String i18n_others(bool isBN) => isBN ? 'অন্যান্য' : 'Others';
//endregion

//region ---------- Digital Gate Pass ----------
String i18n_patePassQrLine1(bool isBN) => isBN ? 'আপনার গেটপাসের কিউআর কোড দিন' : 'If you have a Digital Gate Pass coupon with QR code,';
String i18n_sorry(bool isBN) => isBN ? 'দুঃখিত' : 'Sorry!!';
String i18n_invalidGatePass(bool isBN) => isBN ? 'গেটপাসটি সঠিক নয়' : 'INVALID GATE PASS';
String i18n_welcomeBack(bool isBN) => isBN ? 'ফিরে আসার জন্য স্বাগতম' : 'Welcome Back';
String i18n_gatePass(bool isBN) => isBN ? 'গেট পাস' : 'Gate Pass';
String i18n_enterGatePass(bool isBN) => isBN ? 'ডিজিটাল গেটপাস কোডটি দিন' : 'Enter Digital Gate Pass Code';
String i18n_gatePassNoEmpty(bool isBN) => isBN ? 'গেটপাস কোড খালি রাখা যাবে না' : 'Gate Pass Code Mustn\'t be Empty';
//endregion

//region ---------- Residents ----------
String i18n_buildingId(bool isBN) => isBN ? 'বিল্ডিং আইডি' : 'Building ID';
String i18n_buildingAddress(bool isBN) => isBN ? 'ঠিকানা' : 'Address';
String i18n_buildingManager(bool isBN) => isBN ? 'ম্যানেজার' : 'Manager';
String i18n_listOfFlats(bool isBN) => isBN ? 'বিল্ডিং-এর ফ্ল্যাটের লিষ্ট' : 'List of Flat Number of this building';
String i18n_tapToAssign(bool isBN) => isBN ? 'বসবাসকারীর সংখ্যা নির্দিষ্ট করুন' : 'Tap to assign resident(s)';
String i18n_isAlreadyAssigned(bool isBN) => isBN ? 'বসবাসকারীর সংখ্যা আগেই নির্ধারিত করা হয়েছে' : 'Is Assigned Already';
String i18n_assigningResident(bool isBN) => isBN ? 'ফ্ল্যাটে বসবাসকারী সংখ্যা দিন' : 'Assigning Resident to Flat';
String i18n_wait(bool isBN) => isBN ? 'অপেক্ষা করুন' : 'WAIT';
String i18n_takenBy(bool isBN) => isBN ? 'আগেই ব‍্যবহৃত হয়েছে' : 'Taken By';
//endregion

//region ---------- Security Alerts ----------
String i18n_acknowledged(bool isBN) => isBN ? 'লিপিবদ্ধ করা হয়েছে' : 'Acknowledged';
String i18n_fromFlat(bool isBN) => isBN ? 'ফ্লাট থেকে' : 'From Flat';
//endregion

//region ---------- Utility Contacts ----------
String i18n_noContactFound(bool isBN) => isBN ? 'নাম্বারটি পাওয়া যায়নি' : 'No Contacts Found';
String i18n_contacts(bool isBN) => isBN ? 'যোগাযোগ' : 'Contacts';
//endregion

//region ---------- Visitor Management ----------
String i18n_purpose(bool isBN) => isBN ? 'উদ্দেশ্য' : 'Purpose';
String i18n_selectPurpose(bool isBN) => isBN ? 'উদ্দেশ্য নির্বাচন করুন' : 'Please Select Purpose';
String i18n_invalidPhone(bool isBN) => isBN ? 'সঠিক মোবাইল নম্বর লিখুন' : 'Please type a valid mobile number';
String i18n_date(bool isBN) => isBN ? 'তারিখ' : 'Date';
String i18n_time(bool isBN) => isBN ? 'সময়' : 'Time';
String i18n_permissionDeclined(bool isBN) => isBN ? 'অনুরোধটি রাখা হয়নি' : 'PERMISSION DECLINED';
String i18n_newVisitor(bool isBN) => isBN ? 'নতুন ভিজিটর' : 'New Visitor';
String i18n_fullName(bool isBN) => isBN ? 'পূর্ণ নাম' : 'Full Name';
String i18n_address(bool isBN) => isBN ? 'ঠিকানা' : 'Address';
String i18n_email(bool isBN) => isBN ? 'ইমেইল (ঐচ্ছিক)' : 'Email (Optional)';
String i18n_mobile(bool isBN) => isBN ? 'মোবাইল নাম্বার' : 'Mobile Number';
String i18n_takePhoto(bool isBN) => isBN ? 'ছবি আপলোড করুন' : 'Take Photo';
String i18n_enterMobile(bool isBN) => isBN ? 'আপনার মোবাইল নাম্বার দিন' : 'Enter Your Mobile Number';
String i18n_selectFlat(bool isBN) => isBN ? 'ফ্ল্যাটটি নির্বাচন করুন' : 'Please Select Flat';
//endregion
