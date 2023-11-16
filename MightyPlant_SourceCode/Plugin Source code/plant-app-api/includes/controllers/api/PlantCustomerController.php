<?php

namespace Includes\Controllers\Api;
use WP_REST_Response;
use WP_REST_Server;
use WP_Query;
use WP_Post;
use Wp_User;
use Includes\baseClasses\PlantBase;

class PlantCustomerController extends PlantBase {


    public $module = 'customer';

    public $nameSpace;

    function __construct() {

        $this->nameSpace = PLANTAPP_API_NAMESPACE;

        add_action( 'rest_api_init', function () {

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/save-profile-image', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_save_profile_image' ],
            'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/change-password', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_change_password' ],
				'permission_callback' => '__return_true'
            ));
            
            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/forget-password', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_forgotPassword' ],
				'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/social-login', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_customer_by_social' ],
				'permission_callback' => '__return_true'
            ));
            
            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/forgot-password', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_forgot_password' ],
				'permission_callback' => '__return_true'
            ));

			register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/delete-account', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_delete_user_account' ],
				'permission_callback' => '__return_true'
			));
         });

    }

    public function plantapp_save_profile_image($request)
    {
        $header = $request->get_headers();
        $parameters = $request->get_params();
        
        $data = plantAppValidationToken($request);

		if (!$data['status']) {
			return comman_custom_response($data,401);
        }
        
        $userid = $data['user_id'];
        $users = get_userdata( $userid );
        if( isset($_FILES['profile_image']) && $_FILES['profile_image'] != null ){
            $profile_image = media_handle_upload( 'profile_image', 0 );
            
            update_user_meta( $userid, 'plantapp_profile_image', wp_get_attachment_url($profile_image) );
        }
		$player_id = ( isset($parameters['player_id']) && !empty($parameters['player_id'])) ? $parameters['player_id'] : null;

        if( $player_id != null ){
            update_user_meta($userid, 'plantapp_player_id', $player_id);
        }
		$response['plantapp_profile_image'] = get_user_meta($userid, 'plantapp_profile_image', true );
		$response['message'] = 'Profile has been updated succesfully';

        return comman_custom_response( $response );
    }

    public function plantapp_change_password($request) {

		$data = plantAppValidationToken($request);

		if (!$data['status']) {
			return comman_custom_response($data,401);
		}

		$parameters = $request->get_params();

		$userdata = get_user_by('ID', $data['user_id']);
		
		if ($userdata == null) {
			
			if ($userdata == null) {
				$message = __('User not found');
				return comman_message_response($message,400);
			}
		}

		$status_code = 200;

		if (wp_check_password($parameters['old_password'], $userdata->data->user_pass)){
			wp_set_password($parameters['new_password'], $userdata->ID);
			$message = __("Password has been changed successfully");
		}else {
			$status_code = 400;
			$message = __("Old password is invalid");
		}
		return comman_message_response($message,$status_code);
	}

    public function plantapp_forgot_password($request) {
		$parameters = $request->get_params();
		$email = $parameters['email'];
		
		$user = get_user_by('email', $email);
		$message = null;
		$status_code = null;
		
		if($user) {      

			$title = 'New Password';
            $password = plantAppGenerateString();
            $message = '<label><b>Hello,</b></label>';
            $message.= '<p>Your recently requested to reset your password. Here is the new password for your App</p>';
            $message.='<p><b>New Password </b> : '.$password.'</p>';
            $message.='<p>Thanks,</p>';

            $headers = "MIME-Version: 1.0" . "\r\n";
            $headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
			$is_sent_wp_mail = wp_mail($email,$title,$message,$headers);

            if($is_sent_wp_mail) {
				wp_set_password( $password, $user->ID);
				$message = __('Password has been sent successfully to your email address.');
				$status_code = 200;
			} elseif (mail( $email, $title, $message, $headers )) {
				wp_set_password( $password, $user->ID);
				$message = __('Password has been sent successfully to your email address.');
				$status_code = 200;
			} else {
				$message = __('Email not sent');
				$status_code = 400;
			}
		} else {
			$message = __('User not found with this email address');
			$status_code = 400;
		}
		return comman_message_response($message,$status_code);
    }

    public function plantapp_get_customer_by_social ( $request )
	{
        $parameters = $request->get_params();
		$email = $parameters['email'];
		$password = $parameters['accessToken'];
        $user = get_user_by('email', $email);

        $address = array(
            'first_name' => $parameters['firstName'],
            'last_name'  => $parameters['lastName'],            
            'email'      => $email  
        );

        if ( !$user ) {
            $user = wp_create_user( $email, $password, $email );
            wp_update_user([
				'ID' => $user,
				'display_name' => $parameters['firstName'] .' '. $parameters['lastName'],
			]);
            update_user_meta( $user, 'plantapp_loginType', $parameters['loginType']);
            update_user_meta( $user, "billing_first_name", $address['first_name'] );
            update_user_meta( $user, "billing_last_name", $address['last_name']);
            update_user_meta( $user, "billing_email", $address['email'] );

            update_user_meta( $user, "shipping_first_name", $address['first_name'] );
            update_user_meta( $user, "shipping_last_name", $address['last_name']);

            update_user_meta( $user, 'first_name', trim( $address['first_name'] ) );
            update_user_meta( $user, 'last_name', trim( $address['last_name'] ) );            
        } else {
            $loginType = get_user_meta( $user->ID, 'plantapp_loginType' , true );
            if( !isset($loginType) || $loginType == ''){
                return comman_message_response('You are already registered with us.',400);
            }
            wp_set_password( $password, $user->ID);
        }
        $u = new WP_User( $user);
        $u->set_role( 'customer' );

        $response = plantAppGenerateToken( "username=".$email."&password=".$password  );
        
        return comman_custom_response(json_decode($response['body'],true));
    }

    public function plantapp_forgotPassword($request)
	{
		$parameters = $request->get_params();
		$email = $parameters['email'];
		
		$user = get_user_by('email', $email);
		$message = null;
		$status_code = null;
		
		if($user)
		{
			$user_login = $user->user_login;
			$user_email = $user->user_email;
			$key        = get_password_reset_key( $user );

			if ( is_wp_error( $key ) ) {
				return $key;
			}

			// Localize password reset message content for user.
			$locale = get_user_locale( $user );

			$switched_locale = switch_to_locale( $locale );

			if ( is_multisite() ) {
				$site_name = get_network()->site_name;
			} else {
				/*
				* The blogname option is escaped with esc_html on the way into the database
				* in sanitize_option. We want to reverse this for the plain text arena of emails.
				*/
				$site_name = wp_specialchars_decode( get_option( 'blogname' ), ENT_QUOTES );
			}

			$message = "<p>". __( 'Someone has requested a password reset for the following account:' ) . "</p>";
			/* translators: %s: Site name. */
			$message .= "<p>". sprintf( __( 'Site Name: %s' ), $site_name ) . "</p>";
			/* translators: %s: User login. */
			$message .= "<p>". sprintf( __( 'Username: %s' ), $user_login ) . "</p>";
			$message .= "<p>". __( 'If this was a mistake, ignore this email and nothing will happen.' ) . "</p>";
			$message .= "<p>". __( 'To reset your password, visit the following address:' ) . "</p>";
			$message .= "<p>". network_site_url( "wp-login.php?action=rp&key=$key&login=" . rawurlencode( $user_login ), 'login' ) . '&wp_lang=' . $locale . "</p>";

			if ( ! is_user_logged_in() ) {
				$requester_ip = $_SERVER['REMOTE_ADDR'];
				if ( $requester_ip ) {
					$message .= sprintf(
						/* translators: %s: IP address of password reset requester. */
						"<p>". __( 'This password reset request originated from the IP address %s.' ),
						$requester_ip
					) . "</p>";
				}
			}

			/* translators: Password reset notification email subject. %s: Site title. */
			$title = sprintf( __( '[%s] Password Reset' ), $site_name );
			
			$headers = "MIME-Version: 1.0" . "\r\n";
            $headers .= "Content-type:text/html;charset=UTF-8"."\r\n";
			
			$is_sent_wp_mail = wp_mail($email,$title,$message,$headers);
			
            if($is_sent_wp_mail) {				
				$message = __('Password reset link has been sent successfully to your email address.');
				$status_code = 200;
			} elseif (mail( $email, $title, $message, $headers )) {
				$message = __('Password reset link has been sent successfully to your email address.');
				$status_code = 200;
			} else {
				$message = __('Email not sent');
				$status_code = 400;
			}
		} else {
			$message = __('User not found with this email address');
			$status_code = 400;
		}
		return comman_message_response($message,$status_code);
	}

	public function plantapp_delete_user_account($request)
	{
		global $wpdb;
		$data = plantAppValidationToken($request);
	
		if (!$data['status']) {
			return comman_custom_response($data,401);
		}
	
		require_once ABSPATH . 'wp-admin/includes/user.php';
		
		$user_id = $data['user_id'];
        $user = wp_get_current_user();
		$roles = ( array ) $user->roles;
	   	if( in_array('administrator' , $roles) ){
            return comman_message_response( __('Admin cannot be deleted'), 400);
        }
		$result = wp_delete_user($user_id);
	
		$message = __('Your account has been deleted successfully');
		$status_code = 200;
	
		if ( ! $result ) {
			$message = __( 'The user cannot be deleted.');
			$status_code = 400;
		} else {
			$wishlist_table = $wpdb->prefix.'plant_app_wishlist_product';
			$wpdb->delete( $wishlist_table , [ 'user_id' => $user_id ] );
	
			$cart_table = $wpdb->prefix.'plant_app_add_to_cart';
			$wpdb->delete( $cart_table , [ 'user_id' => $user_id ] );
		}
	
		return comman_message_response($message, $status_code);
	}

}
