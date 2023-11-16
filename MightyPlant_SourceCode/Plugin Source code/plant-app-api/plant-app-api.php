<?php

/**
 * @wordpress-plugin
 * Plugin Name:       PlantApp
 * Plugin URI:        https://meetmighty.com/mobile/plantapp
 * Description:       Custom Woocommerce Api Like Cart, Wishlist, Filter Product, Category.
 * Version:           1.1.0
 * Author:            MeetMighty
 * Author URI:        https://meetmighty.com/
 * License:           GPL-2.0+
 * License URI:       http://www.gnu.org/licenses/gpl-2.0.txt
 * Text Domain:       plant-app-api
 * Domain Path:       /languages
 */

// If this file is called directly, abort.
use Includes\baseClasses\PlantActivate;
use Includes\baseClasses\PlantDeactivate;

/**
 * Currently plugin version.
 * Start at version 1.0.0 and use SemVer - https://semver.org
 * Rename this for your plugin and update it as you release new versions.
 */
define( 'PLANTAPP_API_VERSION', '1.1.0' );

defined( 'ABSPATH' ) or die( 'Something went wrong' );

// Require once the Composer Autoload
if ( file_exists( dirname( __FILE__ ) . '/vendor/autoload.php' ) ) {
	require_once dirname( __FILE__ ) . '/vendor/autoload.php';
} else {
	die( 'Something went wrong' );
}

if (!defined('PLANTAPP_API_DIR'))
{
	define('PLANTAPP_API_DIR', plugin_dir_path(__FILE__));
}

if (!defined('PLANTAPP_API_DIR_URI'))
{
	define('PLANTAPP_API_DIR_URI', plugin_dir_url(__FILE__));
}


if (!defined('PLANTAPP_API_NAMESPACE'))
{
	define('PLANTAPP_API_NAMESPACE', 'plant-app');
}

if (!defined('PLANTAPP_API_PREFIX'))
{
	define('PLANTAPP_API_PREFIX', "PT_");
}


if (!defined('JWT_AUTH_SECRET_KEY')){
	define('JWT_AUTH_SECRET_KEY', 'your-top-secrect-key');
}

if (!defined('JWT_AUTH_CORS_ENABLE')){
	define('JWT_AUTH_CORS_ENABLE', true);
}


include( PLANTAPP_API_DIR . 'includes/custom_filed_wc/custom_filed_wc.php' );
include( PLANTAPP_API_DIR . 'includes/notification/sendnotification.php' );

require_once( ABSPATH . 'wp-admin/includes/image.php' );
require_once( ABSPATH . 'wp-admin/includes/file.php' );
require_once( ABSPATH . 'wp-admin/includes/media.php' );


add_filter( 'plugin_row_meta', 'plantapp_custom_plugin_row_meta', 10, 2 );

function plantapp_custom_plugin_row_meta( $plugin_meta, $plugin_file ) {
	
	if ( $plugin_file == plugin_basename( __FILE__ ) )
	{
        $new_links = [
			'doc' => '<a href="https://meetmighty.com/codecanyon/document/mightyplantapp/" target="_blank">Documentation</a>',
			'support' => '<a href="https://support.meetmighty.com/" target="_blank">Support</a>',
		];
         
        $plugin_meta = array_merge( $plugin_meta, $new_links );
    }
	
    return $plugin_meta;
}

/**
 * The code that runs during plugin activation
 */
register_activation_hook( __FILE__, [ PlantActivate::class, 'activate'] );

/**
 * The code that runs during plugin deactivation
 */
register_deactivation_hook( __FILE__, [PlantDeactivate::class, 'init'] );


( new PlantActivate )->init();