<?php

// require_once ( dirname(__FILE__) . '/configs.inc');


/*
  เป้นการเช็ด  BundleIdentifier ที่ยอมให้มีการ login เข้าใช้งานระบบเท่านั้น
  BundleIdentifier : จะถูกส่งเข้ามาทุกครั้งทีมีการ login
*/
function checkBundleIdentifier($bi){
  $val = array(BI_IOS_BASIC, BI_IOS_IDNA, BI_ANDROID_BASIC, BI_ANDROID_IDNA);

  if (in_array(strtolower($bi), $val)) {
    return TRUE;
  }else{
    return FALSE;
  }
}

function URL_SERVER(){
    if(isset($_SERVER['HTTPS'])){
        $protocol = ($_SERVER['HTTPS'] && $_SERVER['HTTPS'] != "off") ? "https" : "http";
    }
    else{
        $protocol = 'http';
    }
    return $protocol . "://" . $_SERVER['HTTP_HOST'];
}

/*
 * ปัญหาเกิดจาก function file_save_data() ต้อง call โดยใช้ services  global $user; จะไม่มี ค่า ทำให้ uid = 0 ดังนั้นเราจำเป้นต้อง copy  function file_save_data => function klovers_file_save_data() เพือส่งค่า uid มาด้วย
*/
function klovers_file_save_data($uid, $data, $destination = NULL, $replace = FILE_EXISTS_RENAME) {
  // global $user;

  if (empty($destination)) {
    $destination = file_default_scheme() . '://';
  }
  if (!file_valid_uri($destination)) {
    watchdog('file', 'The data could not be saved because the destination %destination is invalid. This may be caused by improper use of file_save_data() or a missing stream wrapper.', array('%destination' => $destination));
    drupal_set_message(t('The data could not be saved, because the destination is invalid. More information is available in the system log.'), 'error');
    return FALSE;
  }

  if ($uri = file_unmanaged_save_data($data, $destination, $replace)) {
    // Create a file object.
    $file = new stdClass();
    $file->fid = NULL;
    $file->uri = $uri;
    $file->filename = drupal_basename($uri);
    $file->filemime = file_get_mimetype($file->uri);
    $file->uid = $uid;//$user->uid;
    $file->status = FILE_STATUS_PERMANENT;
    // If we are replacing an existing file re-use its database record.
    if ($replace == FILE_EXISTS_REPLACE) {
      $existing_files = file_load_multiple(array(), array('uri' => $uri));
      if (count($existing_files)) {
        $existing = reset($existing_files);
        $file->fid = $existing->fid;
        $file->filename = $existing->filename;
      }
    }
    // If we are renaming around an existing file (rather than a directory),
    // use its basename for the filename.
    elseif ($replace == FILE_EXISTS_RENAME && is_file($destination)) {
      $file->filename = drupal_basename($destination);
    }

    return file_save($file);
  }
  return FALSE;
}


function ___test()
{
	return "test___";
}

// https://firebase.google.com/docs/cloud-messaging/http-server-ref
// https://github.com/adocwang/mipush/blob/f604c5353d73720282094e2f21b325a5c029069a/xmpush/DevTools.php ส่งแยกตาม package name
function basic_send_push_notification($token, $title="KLOVERS.ORG", $message="MESSAGE", $sound, $vibrate = 0, $badge=0)
{

  //The device token.
  // $token = "eB6kaZNzDcU:APA91bEYNZKgpkwpqtio6BysInKIzopuX4Yqd_AuaUuI5dpjPUvwKCjEYal4kyTELBBIuqliRpVp1L2ebWYLam807Z_f5mtiYOg-M41Mn5ahEtwkL0ZkV3hbBY35QJHDWAv9EBe1j6et"; //token here


  // $key = "AIzaSyA2f-3viF2ZvEubBH318pYB-CFDaa1N0XY";


  $ch = curl_init("https://fcm.googleapis.com/fcm/send");

  //Title of the Notification.
  // $title = "KLOVERS";

  //Body of the Notification.
  // $text = "text";

  //Creating the notification array.
  $notification = array(  'title'   => $title , 
              'text'    => $message, 
              'sound'   => $sound, 
              'vibrate' => $vibrate,
              'badge'   => $badge);


  //This array contains, the token and the notification. The 'to' attribute stores the token.
  /*
   มี 2 แบบ
  1. ส่งที่ละ token
   ex.
   $arrayToSend = array('to' => $token, 'notification' => $notification,'priority'=>'high');

  2. การส่งสามารถส่ง token แบบ array ได้ที่ละ token
   ex. 
   $registrationIds = array( $token, $token2, ....);
   $arrayToSend = array('registration_ids'  => $registrationIds, 'notification' => $notification,'priority'=>'high');

  */

   /*
https://github.com/adocwang/mipush/blob/f604c5353d73720282094e2f21b325a5c029069a/xmpush/DevTools.php
   */
  $arrayToSend = array('to' => $token, 'notification' => $notification,'priority'=>'high');

  /*
$fields = array('registration_id' => $regId, 'restricted_package_name' => $packageName);
  */


  //Generating JSON encoded string form the above array.
  $json = json_encode($arrayToSend);
  //Setup headers:
  $headers = array();
  $headers[] = 'Content-Type: application/json';
  $headers[] = 'Authorization: key=' . FIREBASE_BASIC_KEY; // key here

  //Setup curl, add headers and post parameters.
  curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");                                           
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);    // close echo message                      
  curl_setopt($ch, CURLOPT_POSTFIELDS, $json);
  curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);       

  //Send the request
  $response = curl_exec($ch);

  //Close request
  curl_close($ch);
  return $response;
}

/*
 function ใช้สำหรับสร้างรหัสผ่าน
*/
function generateKey($length = 6) {
    $characters = '0123456789';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}

/*
  function สร้างชือของ annonymous 
  หลักก่าร
     จะ replace ทีมีอักษร _ ด้วย "" ก่อนเพราะว่าค่า device id  ของ ios จะมี ตัวเลขกับ _ ซึ่งเราไม่ต้องการ _ เราจึงต้อง replace "" ก่อนแล้วค่อยดึงออกมา 10 ตัวเท่านั้น
*/
function generate_name_annmousu($name, $length = 10)
{
  $new_name = str_replace(array("_", "-"), "", $name);

  if (strlen($new_name) > 11)
    return substr($new_name, 0, 10);

  return $new_name;
}


/*
 เราจะกรองเบื้องต้นในการ เรียกใช้ api
*/
function check_header(){
  $getallheaders = getallheaders();
  if (array_key_exists("bundle_identifier", $getallheaders) && array_key_exists("platform", $getallheaders)) {
    
    // กรณี bundle_identifier != "heart.idna" จะ retrun false
    if (!checkBundleIdentifier($getallheaders["bundle_identifier"])) {
      return FALSE;
    }

    // กรณีไม่มี udid  จะ retrun false
    // if (strcasecmp($getallheaders["udid"], BI_IOS_IDNA) != 0) {
    //   return FALSE;
    // }

    /*
    จะ return true มีอยู่กรณีที่ว่า ต้อง bundle_identifier == "heart.idna" กับ platform == 'ios' หรือ 'android' เท่านั้น
    */
    if ((strcasecmp($getallheaders["platform"], "ios") != 0) || (strcasecmp($getallheaders["platform"], "android") != 0) || (strcasecmp($getallheaders["platform"], "firebase") != 0))  {
      return TRUE;
    }

    return FALSE;
  }

  return FALSE;
}


/*
  เป็น function load user ทั้งหมดยกเว่น admin เท่านั่น
*/
function load_user(){
  $uids = db_select('users', 'ur')
        ->fields('ur', array('uid'))
        // ->condition('ur.uid', $uid, '!=')
        // ->condition('ur.uid', 0, '!=')
        // ->condition('ur.uid', 1, '!=')
        ->condition('ur.uid', 0, '!=')
        ->condition('ur.uid', 1, '!=')
        ->execute()
        ->fetchCol();

  $mul_users =  user_load_multiple($uids);

  return $mul_users;
}


function generateRandomString($length = 10) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}

// https://andrewho.nl/encrypt-decrypt-strings-php-easy-way/
function dec_enc($action, $string) {
    $output = false;

    $encrypt_method = "AES-256-CBC";
    $secret_key = config_pages_get(CONFIG_PAGES_TYPE, 'field_qrcode_secret_key');// ;QRCODE_SECRET_KEY;
    $secret_iv  = config_pages_get(CONFIG_PAGES_TYPE, 'field_qrcode_secret_iv');//  QRCODE_SECRET_IV;

    // hash
    $key = hash('sha256', $secret_key);
    
    // iv - encrypt method AES-256-CBC expects 16 bytes - else you will get a warning
    $iv = substr(hash('sha256', $secret_iv), 0, 16);

    if( $action == 'encrypt' ) {
        $output = openssl_encrypt($string, $encrypt_method, $key, 0, $iv);
        $output = base64_encode($output);
    }
    else if( $action == 'decrypt' ){
        $output = openssl_decrypt(base64_decode($string), $encrypt_method, $key, 0, $iv);
    }

    return $output;
}

?>