<?php 
require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
global $wpdb;
$charset_collate = $wpdb->get_charset_collate();

$wishlist_table = $wpdb->prefix . 'plant_app_wishlist_product'; // do not forget about tables prefix

$sql = "CREATE TABLE `{$wishlist_table}` (
    ID bigint(20) NOT NULL AUTO_INCREMENT,    
    user_id bigint(20) UNSIGNED NOT NULL,
    pro_id bigint(20) UNSIGNED NOT NULL,
    wishlist_id bigint(20) UNSIGNED NOT NULL,    
    created_at datetime  NULL,
    
    PRIMARY KEY  (ID)
  ) $charset_collate;";

  maybe_create_table($wishlist_table,$sql);

  $cart_table = $wpdb->prefix . 'plant_app_add_to_cart'; // do not forget about tables prefix

  $sql = "CREATE TABLE `{$cart_table}` (
    ID bigint(20) NOT NULL AUTO_INCREMENT,    
    user_id bigint(20) UNSIGNED NOT NULL,
    pro_id bigint(20) UNSIGNED NOT NULL,
    quantity bigint(20) UNSIGNED NOT NULL,
    color varchar(50) NULL DEFAULT NULL,
    size varchar(50) NULL DEFAULT NULL,   
    created_at datetime  NULL,  
    PRIMARY KEY  (ID)
  ) $charset_collate;";

maybe_create_table($cart_table,$sql);

?>