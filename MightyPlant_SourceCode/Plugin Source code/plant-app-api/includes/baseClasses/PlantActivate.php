<?php

namespace Includes\baseClasses;
use WC_Customer;

class PlantActivate extends PlantBase {

	public static function activate() {
		( new PlantGetDependency( 'jwt-authentication-for-wp-rest-api' ) )->getPlugin();
		( new PlantGetDependency( 'woocommerce' ) )->getPlugin();
		( new PlantGetDependency( 'dokan-lite' ) )->getPlugin();
		( new PlantGetDependency( 'woo-delivery' ) )->getPlugin();
		( new PlantGetDependency( 'woo-advanced-shipment-tracking' ) )->getPlugin();
		( new PlantGetDependency( 'woo-featured-video' ) )->getPlugin();
		
		require_once PLANTAPP_API_DIR . 'includes/db/plantapp.db.php';		
		
	}

	public function init() {

		if ( isset( $_REQUEST['page'] ) && strpos($_REQUEST['page'], 'plantapp-configuration') !== false ) {
			// Enqueue Admin-side assets...
            add_action( 'admin_enqueue_scripts', array( $this, 'enqueueStyles' ) );
            add_action( 'admin_enqueue_scripts', array( $this, 'enqueueScripts' ) );
			add_action( 'admin_enqueue_scripts', 'wp_enqueue_media' );
        }

		// API handle
		( new PlantApiHandler() )->init();

		// Action to add option in the sidebar...
		add_action( 'admin_menu', array( $this, 'adminMenu' ) );

		// Action to change authentication api response ...
		add_filter( 'jwt_auth_token_before_dispatch', array($this, 'jwtAuthenticationResponse'), 10, 2 );


	}

	public function adminMenu() {
		$user = wp_get_current_user();
		$roles = ( array ) $user->roles;
	   	if( in_array('administrator' , $roles) ){
			add_menu_page( __( 'App Configuration' ), 'App Configuration', 'read', 'plantapp-configuration',  [
				$this,
				'adminDashboard'
			], $this->plugin_url . 'assets/images/sidebar.png', 99 );
		}
	}

    public function adminDashboard() {
        include( PLANTAPP_API_DIR . 'resources/views/plant_admin_panel.php' );
    }
	
	public function enqueueStyles() {
        wp_enqueue_style('plantapp_bootstrap_css', PLANTAPP_API_DIR_URI . 'assets/css/bootstrap.min.css' );
        wp_enqueue_style('plantapp_font_awesome', PLANTAPP_API_DIR_URI . 'assets/css/font-awesome.min.css' );
        wp_enqueue_style('plantapp_bootstrap_select', PLANTAPP_API_DIR_URI . 'admin/css/bootstrap-select.css');
        wp_enqueue_style('plantapp_custom', PLANTAPP_API_DIR_URI . 'assets/css/custom.css');
        wp_enqueue_style('plantapp_admin_panel_css', PLANTAPP_API_DIR_URI . 'admin/css/plantapp-api-admin.css');
    }

	public function enqueueScripts() {
        wp_enqueue_script('plantapp_bootstrap_js', PLANTAPP_API_DIR_URI . 'assets/js/bootstrap.min.js', [ 'jquery' ], false, true );
        wp_enqueue_script('plantapp_js_popper', PLANTAPP_API_DIR_URI . 'admin/js/popper.min.js', [ 'jquery' ], false, false );
        wp_enqueue_script('plantapp_bootstrap_select', PLANTAPP_API_DIR_URI . 'admin/js/bootstrap-select.js', [ 'jquery' ], false, true );
        wp_enqueue_script('plantapp_sweetalert2', PLANTAPP_API_DIR_URI . 'admin/js/sweetalert2.min.js', ['jquery'], false, true);
        wp_enqueue_script('plantapp_custom', PLANTAPP_API_DIR_URI . 'assets/js/custom.js', ['jquery'], false, true);
        wp_localize_script('plantapp_custom', 'plantapp_localize', array(
            'ajaxurl' => admin_url('admin-ajax.php'),
            'nonce' => wp_create_nonce('get_plantapp_admin_settings')
        ));

		wp_localize_script( 'plantapp_js_bundle', 'request_data', array(
			'ajaxurl'         => admin_url( 'admin-ajax.php' ),
			'nonce'           => wp_create_nonce( 'ajax_post' ),
			'plantappPluginURL' => PLANTAPP_API_DIR_URI,
		) );

		wp_enqueue_script( 'plantapp_js_bundle' );
	}

	public function jwtAuthenticationResponse( $data, $user ) {

		$user_info = get_userdata( $user->ID );

		$data['first_name'] = $user_info->first_name;
		$data['last_name']  = $user_info->last_name;
		$data['user_id']    = $user->ID;
		$data['user_role'] 	= $user->roles;
		$data['avatar'] = get_avatar_url($user->ID);

		$customer = (new WC_Customer( $user->ID ))->get_data();
		$data['billing'] 	= $customer['billing'];
	    $data['shipping'] 	= $customer['shipping'];
		
		$data['plantapp_profile_image'] = get_user_meta( $user->ID, 'plantapp_profile_image',true );
		

		return $data;
	}

}


