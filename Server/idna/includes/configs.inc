<?php
	define("CONFIG_PAGES_TYPE", "configure_idna");

	define("TAG", "iDNA Module");
	// define("PATH_FOLDER_QRCODE", "sites/default/files/qrcode");


	define("DEFUALT_NUMBER_HEART", "50");       // จำนวน Heart ที่เราให้ครั้งเมือสมัคร
	define("DEFUALT_HEART_FREE_DAILY", "10");   // จำนวน Heart ที่เราให้ทุกวัน โดยมีเงื่อนไขว่า User ต้องเปิดวันนั้นๆ
	define("LIMIT_SEND_HEART", "2");


	define("DEFUALT_PASSWORD", "HEARTBASIC");
	define("DEFUALT_DISPLAY_USER_ANNONYMOUS", "ANNONYMOUS");
	define("DEFUALT_STATUS_MESSAGE", "status message");


	// URL STORE
	define("DEFUALT_IOS_URL_STORE_BASIC", "https://itunes.apple.com/us/app/heart-basic/id1184807478?ls=1&mt=8");
	// define("DEFUALT_IOS_URL_STORE_IDNA", "https://itunes.apple.com/us/app/dna/id1184836132?ls=1&mt=8");
	define("DEFUALT_ANDROID_URL_STORE_BASIC", "https://itunes.apple.com/us/app/heart-basic/id1184807478");
	// define("DEFUALT_ANDROID_URL_STORE_IDNA", "https://itunes.apple.com/us/app/heart-basic/id1184807478");


	// Firebase Config             
	// define("FIREBASE_BASIC_KEY", "AIzaSyBoWN3hYF-fmOmXUKwFuM5GnuIcxdpmC3o");  // 
	define("FIREBASE_BASIC_KEY", "AIzaSyDfCPJJNM0SusVYNCzo76e9S4esYkqVjzA");  
	// define("FIREBASE_DEFAULT_URL", 'https://test-toonchat.firebaseio.com/');
	define("FIREBASE_DEFAULT_PATH", '/idna/');
	define("FIREBASE_LOGIN_PATH", 'user/');
	define("FIREBASE_MY_APPLIPATIONS_PATH", 'my_applications/');
	define("FIREBASE_MY_APPLIPATIONS_POSTS_PATH", 'posts/');

	define("FIREBASE_CENTER", 'center/'); 
	define("FIREBASE_CENTER_SLIDE", 'center-slide/'); 


	define("PATH_GROUPS", "groups");
	define("PATH_CLASSS", "classs");
	define("PATH_FOLLOWING", "following");


	// Bundle Identifier  
	define("BI_IOS_BASIC", "heart.basic");
	define("BI_IOS_IDNA", "heart.idna");

	define("BI_ANDROID_BASIC", "heart.basic");
	define("BI_ANDROID_IDNA", "heart.idna");


	// define("DEFUALT_LENGTH_CHAT_ID", 20); 

	// เป็น password ทีใช้ เข้าระบบ string uid ของ user ทีใช้สำหรับสร้าง  QRCode
	// define("QRCODE_SECRET_KEY", "aaa04b7e103a0cd8b54763051cef08bc55abe029fdebae5e1d417e2ffb2a00a3");
	// define("QRCODE_SECRET_IV", "bbb04b7e103a0cd8b54763051cef08bc55abe029fdebae5e1d417e2ffb2a00a3");

	define("FRIEND_STATUS_FRIEND", "10");
	define("FRIEND_STATUS_FRIEND_CANCEL", "13");
	define("FRIEND_STATUS_FRIEND_REQUEST", "11");  
	define("FRIEND_STATUS_WAIT_FOR_A_FRIEND", "12");  
?>