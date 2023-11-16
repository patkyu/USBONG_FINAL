<?php

function plantAppValidationToken ($request) {
	$data = [
		'message' => 'Valid token',
        'status' => true,
	];
	$response = collect((new Jwt_Auth_Public('jwt-auth', '1.1.0'))->validate_token($request,false));
   
	if ($response->has('errors')) {
		$data['status'] = false;
		$data['message'] = isset(array_values($response['errors'])[0][0]) ? array_values($response['errors'])[0][0] : __("Authorization failed");
	}else {
        $current_user_id = get_current_user_id();
        $data['user_id'] = $current_user_id != 0 ? $current_user_id : null;// $response['data']->user->id;
		$user_meta = get_userdata($data['user_id']);

		$user_roles = $user_meta->roles;
		$data['role'] = $user_roles[0];
    }
	return $data;
}

function plantAppGenerateToken( $data ) {
	return wp_remote_post( get_home_url() . "/wp-json/jwt-auth/v1/token" , array(
		'body' => $data
	));
}
function plantAppValidateRequest($rules, $request, $message = [])
{
	$error_messages = [];
	$required_message = ' field is required';
	$email_message =  ' has invalid email address';

	if (count($rules)) {
		foreach ($rules as $key => $rule) {
			if (strpos($rule, '|') !== false) {
				$ruleArray = explode('|', $rule);
				foreach ($ruleArray as $r) {
					if ($r === 'required') {
						if (!isset($request[$key]) || $request[$key] === "" || $request[$key] === null) {
							$error_messages[] = isset($message[$key]) ? $message[$key] : str_replace('_', ' ', $key) . $required_message;
						}
					} elseif ($r === 'email') {
						if (isset($request[$key])) {
							if (!filter_var($request[$key], FILTER_VALIDATE_EMAIL) || !is_email($request[$key])) {
								$error_messages[] = isset($message[$key]) ? $message[$key] : str_replace('_', ' ', $key) . $email_message;
							}
						}
					}
				}
			} else {
				if ($rule === 'required') {
					if (!isset($request[$key]) || $request[$key] === "" || $request[$key] === null) {
						$error_messages[] = isset($message[$key]) ? $message[$key] : str_replace('_', ' ', $key) . $required_message;
					}
				} elseif ($rule === 'email') {
					if (isset($request[$key])) {
						if (!filter_var($request[$key], FILTER_VALIDATE_EMAIL) || !is_email($request[$key]) ) {
							$error_messages[] = isset($message[$key]) ? $message[$key] : str_replace('_', ' ', $key) . $email_message;
						}
					}
				}
			}

		}
	}

	return $error_messages;
}

function plantAppGetErrorMessage ($response) {
	return isset(array_values($response->errors)[0][0]) ? array_values($response->errors)[0][0] : __("Internal server error");
}

function plantAppGenerateString($length_of_string = 10)
{
	// String of all alphanumeric character
	$str_result = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
	return substr(str_shuffle($str_result),0, $length_of_string);
}

if(!function_exists('comman_message_response')){
	function comman_message_response( $message, $status_code = 200)
	{
		$response = new WP_REST_Response(array(
				"message" => $message
			)
		);
		$response->set_status($status_code);
		return $response;
	}
}

if(!function_exists('comman_custom_response')){
	function comman_custom_response( $res, $status_code = 200 )
	{
		$response = new WP_REST_Response($res);
		$response->set_status($status_code);
		return $response;
	}
}

if(!function_exists('comman_list_response')){
    function comman_list_response( $data )
    {
        $response = new WP_REST_Response(array(
            "data" => $data
        ));

        $response->set_status(200);
        return $response;
    }
}
if(!function_exists('plantapp_title_filter')){
function plantapp_title_filter( $where, $wp_query ){
    global $wpdb;
    if( $search_term = $wp_query->get( 'plantapp_title_filter' ) ) :
        $search_term = $wpdb->esc_like( $search_term );
        $search_term = ' \'%' . $search_term . '%\'';
        $title_filter_relation = ( strtoupper( $wp_query->get( 'title_filter_relation' ) ) == 'OR' ? 'OR' : 'AND' );
        $where .= ' '.$title_filter_relation.' ' . $wpdb->posts . '.post_title LIKE ' . $search_term;
    endif;
    return $where;
}
}

add_filter( 'posts_where', 'plantapp_title_filter', 10, 2 );

function plantapp_check_zone_location($zone, $code, $postcode = '') {
    $zone_locations = $zone['zone_locations'];

    if (count($zone_locations)) {
        $zone_check = false;
        foreach ($zone_locations as $zone) {
            if ($zone->type == 'state' && $zone->code == $code) {
                $zone_check = true;
            }
        }


        if ($zone_check) {
            foreach ($zone_locations as $location) {
                if ($postcode != '') {
                    if ($location->type == 'postcode' || $location->type == 'country') {
                        if (strpos($location->code, '*') !== false) {
                            $new_postcode = substr($postcode, 0, 4). '*';
                            if ($new_postcode == $location->code) {
                                return true;
                            }
                        } else {
                            if ($location->code == $postcode) {
                                return true;
                            }
                        }
                    } else {
                        if ($location->code == $code) {
                            return true;
                        }
                    }

                } else {
                    if ($location->code == $code) {
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

function plantapp_check_ip_limitation_on_shipping_method ($zone) {
    $zone_locations = $zone['zone_locations'];
    $post_codes = [];
    if (count($zone_locations)) {
        foreach ($zone_locations as $location) {
            if ($location->type == 'postcode') {
                array_push($post_codes, $location->code);
            }
        }
    }
    return $post_codes;
}

function plantapp_get_images_link($id)
{
    global $product;
    $array = [];
    $img = [];
    $product = wc_get_product($id);
    $thumb = wp_get_attachment_image_src($product->get_image_id() , "thumbnail");
    $full = wp_get_attachment_image_src($product->get_image_id() , "full");
        $img[] = $thumb[0];
        $img[] = $full[0];

		$gallery = [];
        foreach ($product->get_gallery_image_ids() as $img_id)
        {
            $g = wp_get_attachment_image_src($img_id, "full");
            $gallery[] = $g[0];
        }
        $array['image'] = $img;
        $array['gallery'] = $gallery;
        return $array;
}

function plantapp_get_special_product_details_helper ($type, $userid = null)
{
	$product = [];
	global $wpdb;

	$product_meta = $wpdb->get_results("SELECT * FROM $wpdb->postmeta WHERE meta_key = '{$type}' AND  meta_value = 'yes' ORDER BY `post_id` DESC LIMIT 10", object);

	if (count($product_meta)) {

		foreach ($product_meta as $meta) {
			$data = plantapp_get_product_details_helper($meta->post_id, $userid);
			if ($data != []) {
				$product[] = $data;
			}
		}
	}

	return $product;
}

function plantapp_get_product_details_helper($product_id, $userid = null)
{
	global $product;
	global $wpdb;
	$product = wc_get_product($product_id);

	if ($product === false) {
		return [];
	}

	$temp = [
		'id'                    => $product->get_id(),
		'name'                  => $product->get_name(),
		'permalink'             => $product->get_permalink(),
		'type'                  => $product->get_type(),
		'status'                => $product->get_status(),
		'featured'              => $product->is_featured(),
		'plant_product_type' 	=> get_post_meta( $product_id, 'plant_product_type', true ),
		'description'           => wpautop( do_shortcode( $product->get_description() ) ),
		'short_description'     => apply_filters( 'woocommerce_short_description', $product->get_short_description() ),
		'price'                 => $product->get_price(),
		'regular_price'         => $product->get_regular_price(),
		'sale_price'            => $product->get_sale_price() ? $product->get_sale_price() : '',
		'on_sale'               => $product->is_on_sale(),
		'in_stock'              => $product->is_in_stock(),
		'images'                => plantapp_get_product_images_helper( $product ),
		'manage_stock'          => $product->managing_stock(),
		'stock_quantity'        => $product->get_stock_quantity(),
		'is_added_cart'			=> plantapp_is_product_wishlist_cart($product_id , $userid, 'cart'),
		'is_added_wishlist'		=> plantapp_is_product_wishlist_cart($product_id , $userid, 'wishlist'),
		'average_rating'        => wc_format_decimal( $product->get_average_rating(), 2 ),
		'rating_count'          => $product->get_rating_count(),
	];

	if($product->is_on_sale() && $temp['sale_price'] != null){
		$temp['discount_percentage'] = productDiscount($temp['regular_price'], $temp['sale_price'], 'percentage');
		$temp['discount_price'] = productDiscount($temp['regular_price'], $temp['sale_price'], 'price' );
	}
	return $temp;
}

function plantapp_get_product_list_helper ($product_id , $userid = null)
{
	global $product;
	global $wpdb;
	$product = wc_get_product($product_id);

	if ($product === false) {
		return [];
	}

	$temp = array(
		'id'                    => $product->get_id(),
		'name'                  => $product->get_name(),
		'slug'                  => $product->get_slug(),
		'permalink'             => $product->get_permalink(),
		'plant_product_type'	=> get_post_meta( $product_id, 'plant_product_type', true ),
		'date_created'          => wc_rest_prepare_date_response( $product->get_date_created() ),
		'date_modified'         => wc_rest_prepare_date_response( $product->get_date_modified() ),
		'type'                  => $product->get_type(),
		'status'                => $product->get_status(),
		'featured'              => $product->is_featured(),
		'catalog_visibility'    => $product->get_catalog_visibility(),
		'description'           => wpautop( do_shortcode( $product->get_description() ) ),
		'short_description'     => apply_filters( 'woocommerce_short_description', $product->get_short_description() ),
		'sku'                   => $product->get_sku(),
		'price'                 => $product->get_price(),
		'regular_price'         => $product->get_regular_price(),
		'sale_price'            => $product->get_sale_price() ? $product->get_sale_price() : '',
		'date_on_sale_from'     => $product->get_date_on_sale_from() ? date_i18n( 'Y-m-d', $product->get_date_on_sale_from()->getOffsetTimestamp() ) : '',
		'date_on_sale_to'       => $product->get_date_on_sale_to() ? date_i18n( 'Y-m-d', $product->get_date_on_sale_to()->getOffsetTimestamp() ) : '',
		'price_html'            => $product->get_price_html(),
		'on_sale'               => $product->is_on_sale(),
		'purchasable'           => $product->is_purchasable(),
		'total_sales'           => $product->get_total_sales(),
		'virtual'               => $product->is_virtual(),
		'downloadable'          => $product->is_downloadable(),
		'downloads'             => [],
		'download_limit'        => $product->get_download_limit(),
		'download_expiry'       => $product->get_download_expiry(),
		'download_type'         => 'standard',
		'external_url'          => $product->is_type( 'external' ) ? $product->get_product_url() : '',
		'button_text'           => $product->is_type( 'external' ) ? $product->get_button_text() : '',
		'tax_status'            => $product->get_tax_status(),
		'tax_class'             => $product->get_tax_class(),
		'manage_stock'          => $product->managing_stock(),
		'stock_quantity'        => $product->get_stock_quantity(),
		'in_stock'              => $product->is_in_stock(),
		'backorders'            => $product->get_backorders(),
		'backorders_allowed'    => $product->backorders_allowed(),
		'backordered'           => $product->is_on_backorder(),
		'sold_individually'     => $product->is_sold_individually(),
		'weight'                => $product->get_weight(),
		'dimensions'            => array(
			'length' => $product->get_length(),
			'width'  => $product->get_width(),
			'height' => $product->get_height(),
		),
		'shipping_required'     => $product->needs_shipping(),
		'shipping_taxable'      => $product->is_shipping_taxable(),
		'shipping_class'        => $product->get_shipping_class(),
		'shipping_class_id'     => $product->get_shipping_class_id(),
		'reviews_allowed'       => $product->get_reviews_allowed(),
		'average_rating'        => wc_format_decimal( $product->get_average_rating(), 2 ),
		'rating_count'          => $product->get_rating_count(),
		'related_ids'           => array_map( 'absint', array_values( wc_get_related_products( $product->get_id() ) ) ),
		'upsell_ids'            => array_map( 'absint', $product->get_upsell_ids() ),
		'cross_sell_ids'        => array_map( 'absint', $product->get_cross_sell_ids() ),
		'parent_id'             => $product->get_parent_id(),
		'purchase_note'         => wpautop( do_shortcode( wp_kses_post( $product->get_purchase_note() ) ) ),
		'categories'            => plantapp_get_taxonomy_terms_helper( $product ),
		'tags'                  => plantapp_get_taxonomy_terms_helper( $product, 'tag' ),
		'images'                => plantapp_get_product_images_helper( $product ),
		'attributes'            => plantapp_get_product_attributes( $product ),
		'default_attributes'    => plantapp_get_product_default_attributes( $product ),
		'variations'            => $product->get_children(),
		'grouped_products'      => [],
		'upsell_id'      		=> [],
		'menu_order'            => $product->get_menu_order(),

	);

	if($temp['plant_product_type'] == 'plant')
	{
		$temp['plantapp_plant_type']	= get_post_meta( $product_id, 'plantapp_plant_type', true);
		$temp['plantapp_temperature']	= get_post_meta( $product_id, 'plantapp_temperature', true);
		$temp['plantapp_fertile']		= get_post_meta( $product_id, 'plantapp_fertile', true);
		$temp['plantapp_water']			= get_post_meta( $product_id, 'plantapp_water', true);
		$temp['plantapp_light']			= get_post_meta( $product_id, 'plantapp_light', true);
		$temp['plantapp_life']			= get_post_meta( $product_id, 'plantapp_life', true);
	}

	$temp['is_added_cart'] = plantapp_is_product_wishlist_cart($product_id , $userid, 'cart');
	$temp['is_added_wishlist'] = plantapp_is_product_wishlist_cart($product_id , $userid, 'wishlist');
	
	$author_id = get_post_field( 'post_author', $product_id );

	if(isPTDokanActive() == true){
		$store = dokan()->vendor->get( $author_id );

		$store_address = $store->get_address();

		$temp['store'] = array(
			'id'        => $store->get_id(),
			'name'      => $store->get_name(),
			'shop_name' => $store->get_shop_name(),
			'url'       => $store->get_shop_url()
		);

		if ($store_address != []) {
			$temp['store']['address'] = $store_address;
		}
		$temp['store']['location'] = $store->get_location();
		$temp['store']['store_open_close'] =  [
			'enabled'      => $store->is_store_time_enabled(),
			'time'         => (object) $store->get_store_time(),
			'open_notice'  => $store->get_store_open_notice(),
			'close_notice' => $store->get_store_close_notice(),
		];
	}

	if (isset($temp['upsell_ids']) && count($temp['upsell_ids'])) {
		$upsell_products = [];

		foreach ($temp['upsell_ids'] as $key => $p_id) {

			$upsell_product = wc_get_product($p_id);

			if ($upsell_product != null) {
				$upsell_products[] = [
					'id'                    => $upsell_product->get_id(),
					'name'                  => $upsell_product->get_name(),
					'slug'                  => $upsell_product->get_slug(),
					'price'                 => $upsell_product->get_price(),
					'regular_price'         => $upsell_product->get_regular_price(),
					'sale_price'            => $upsell_product->get_sale_price() ? $upsell_product->get_sale_price() : '',
					'images'                => plantapp_get_product_images_helper( $upsell_product ),
				];
			}
		}

		if (count($upsell_products)) {
			$temp['upsell_id'] = $upsell_products;
		}
	}
	$temp['woofv_video_embed'] = plantapp_woo_featured_video($product->get_id());

	if($product->is_on_sale() && $temp['sale_price'] != null){
		$temp['discount_percentage'] = productDiscount($temp['regular_price'], $temp['sale_price'], 'percentage');
		$temp['discount_price'] = productDiscount($temp['regular_price'], $temp['sale_price'], 'price' );
	}
	return $temp;

}

function plantapp_is_product_wishlist_cart($product_id, $userid, $type = 'cart')
{
	global $wpdb;
	$return = false;
	if ($userid != null) {
		switch ($type)
		{
			case 'cart':
				$cart_item = $wpdb->get_row(" SELECT * FROM {$wpdb->prefix}plant_app_add_to_cart WHERE user_id='{$userid}' AND pro_id='{$product_id}'", OBJECT );

				if ($cart_item != null ) {
					$return = true;
				}
				break;
			case 'wishlist':
				$wishlist_item = $wpdb->get_row( "SELECT * FROM {$wpdb->prefix}plant_app_wishlist_product WHERE user_id='{$userid}' AND pro_id='{$product_id}'", OBJECT );
				if ($wishlist_item != null ) {
					$return = true;
				}
				break;
			default:
				$return = false;
				break;
		}
	}
	return $return;
}

function plantapp_woo_featured_video($product_id) {
	$woofv_video_embed = get_post_meta( $product_id, '_woofv_video_embed', true );
	if ( $woofv_video_embed == null ) {
		$woofv_video_embed = (object) [];
	}
	return $woofv_video_embed;
}


function plantapp_get_taxonomy_terms_helper( $product, $taxonomy = 'cat' ) {
	$terms = [];

	foreach ( wc_get_object_terms( $product->get_id(), 'product_' . $taxonomy ) as $term ) {
		$thumb_id = get_term_meta( $term->term_id, 'thumbnail_id', true );
        $term_img = wp_get_attachment_url(  $thumb_id );

		$terms[] = array(
			'id'   => $term->term_id,
			'name' => $term->name,
			'slug' => $term->slug,
			'image'=> ($term_img) ? $term_img : ''
		);
	}

	return $terms;
}

function plantapp_get_product_images_helper( $product ) {
	$images = [];
	$attachment_ids = [];

	if ( !$product ){
		return $images;
	}
	// Add featured image.
	if ( $product->get_image_id() ) {
		$attachment_ids[] = $product->get_image_id();
	}

	$attachment_ids = array_merge( $attachment_ids, $product->get_gallery_image_ids() );

	foreach ( $attachment_ids as $position => $attachment_id ) {
		$attachment_post = get_post( $attachment_id );
		if ( is_null( $attachment_post ) ) {
			continue;
		}

		$attachment = wp_get_attachment_image_src( $attachment_id, 'full' );
		if ( ! is_array( $attachment ) ) {
			continue;
		}

		$images[] = array(
			'id'            => (int) $attachment_id,
			'date_created'  => wc_rest_prepare_date_response( $attachment_post->post_date_gmt ),
			'date_modified' => wc_rest_prepare_date_response( $attachment_post->post_modified_gmt ),
			'src'           => current( $attachment ),
			'name'          => get_the_title( $attachment_id ),
			'alt'           => get_post_meta( $attachment_id, '_wp_attachment_image_alt', true ),
			'position'      => (int) $position,
		);
	}

	if ( empty( $images ) ) {
		$images[] = array(
			'id'            => 0,
			'date_created'  => wc_rest_prepare_date_response( current_time( 'mysql' ) ), // Default to now.
			'date_modified' => wc_rest_prepare_date_response( current_time( 'mysql' ) ),
			'src'           => wc_placeholder_img_src(),
			'name'          => __( 'Placeholder', 'woocommerce' ),
			'alt'           => __( 'Placeholder', 'woocommerce' ),
			'position'      => 0,
		);
	}

	return $images;
}

function plantapp_get_product_attributes( $product ) {
	$attributes = [];

	if ( $product->is_type( 'variation' ) ) {
		// Variation attributes.
		foreach ( $product->get_variation_attributes() as $attribute_name => $attribute ) {
			$name = str_replace( 'attribute_', '', $attribute_name );

			if ( ! $attribute ) {
				continue;
			}

			// Taxonomy-based attributes are prefixed with `pa_`, otherwise simply `attribute_`.
			if ( 0 === strpos( $attribute_name, 'attribute_pa_' ) ) {
				$option_term = get_term_by( 'slug', $attribute, $name );
				$attributes[] = array(
					'id'     => wc_attribute_taxonomy_id_by_name( $name ),
					'name'   => plantapp_get_product_attribute_taxonomy_label( $name ),
					'slug'	 => $name,
					'option' => $option_term && ! is_wp_error( $option_term ) ? $option_term->name : $attribute,
				);
			} else {
				$attributes[] = array(
					'id'     => 0,
					'name'   => $name,
					'slug'	 => $name,
					'option' => $attribute,
				);
			}
		}
	} else {
		foreach ( $product->get_attributes() as $key => $attribute ) {
			if ( $attribute['is_taxonomy'] ) {
				$attributes[] = array(
					'id'        => wc_attribute_taxonomy_id_by_name( $attribute['name'] ),
					'name'      => plantapp_get_product_attribute_taxonomy_label( $attribute['name'] ),
					'slug'		=> $key,//$attribute['name'],
					'position'  => (int) $attribute['position'],
					'visible'   => (bool) $attribute['is_visible'],
					'variation' => (bool) $attribute['is_variation'],
					'options'   => plantapp_get_product_attribute_options( $product->get_id(), $attribute ),
				);
			} else {
				$attributes[] = array(
					'id'        => 0,
					'name'      => $attribute['name'],
					'slug'		=> $key,
					'position'  => (int) $attribute['position'],
					'visible'   => (bool) $attribute['is_visible'],
					'variation' => (bool) $attribute['is_variation'],
					'options'   => plantapp_get_product_attribute_options( $product->get_id(), $attribute ),
				);
			}
		}
	}

	return $attributes;
}

function plantapp_get_product_attribute_taxonomy_label( $name ) {
	$tax    = get_taxonomy( $name );
	$labels = get_taxonomy_labels( $tax );

	return $labels->singular_name;
}

function plantapp_get_product_attribute_options( $product_id, $attribute ) {
	if ( isset( $attribute['is_taxonomy'] ) && $attribute['is_taxonomy'] ) {
		return wc_get_product_terms( $product_id, $attribute['name'], array( 'fields' => 'names' ) );
	} elseif ( isset( $attribute['value'] ) ) {
		return array_map( 'trim', explode( '|', $attribute['value'] ) );
	}

	return [];
}

function plantapp_get_product_default_attributes( $product ) {
	$default = [];

	if ( $product->is_type( 'variable' ) ) {
		foreach ( array_filter( (array) $product->get_default_attributes(), 'strlen' ) as $key => $value ) {
			if ( 0 === strpos( $key, 'pa_' ) ) {
				$default[] = array(
					'id'     => wc_attribute_taxonomy_id_by_name( $key ),
					'name'   => plantapp_get_product_attribute_taxonomy_label( $key ),
					'option' => $value,
				);
			} else {
				$default[] = array(
					'id'     => 0,
					'name'   => wc_attribute_taxonomy_slug( $key ),
					'option' => $value,
				);
			}
		}
	}

	return $default;
}

function plantapp_get_date_timestamp_helper($date)
{
	$new_date = null;

	if ($date != null) {
		$new_date = gmdate( 'Y-m-d H:i:s', $date->getTimestamp());
	}

	return $new_date;
}

function plantapp_throw_error($msg)
{
     $response = new WP_REST_Response(array(
        "code" => "Error",
        "message" => $msg,
        "data" => array(
            "status" => 404
        )
    )
);
    $response->set_status(404);
    return $response;
}

function allow_payment_without_login( $allcaps, $caps, $args ) {
    // Check we are looking at the WooCommerce Pay For Order Page
    if ( !isset( $caps[0] ) || $caps[0] != 'pay_for_order' )
        return $allcaps;
    // Check that a Key is provided
    if ( !isset( $_GET['key'] ) )
        return $allcaps;

    // Find the Related Order
    $order = wc_get_order( $args[2] );
    if( !$order )
        return $allcaps; # Invalid Order

    // Get the Order Key from the WooCommerce Order
    $order_key = $order->get_order_key();
    // Get the Order Key from the URL Query String
    $order_key_check = $_GET['key'];

    // Set the Permission to TRUE if the Order Keys Match
    $allcaps['pay_for_order'] = ( $order_key == $order_key_check );

    return $allcaps;
}
add_filter( 'user_has_cap', 'allow_payment_without_login', 10, 3 );

function get_enable_category($arr)
{
    $a = (array) $arr;

    $term_meta = get_option("enable_" . $a['term_id']);

    if(!empty($term_meta['enable']))
    {
        return $a;
    }

}

function get_category_child($arr)
{
    $a = (array) $arr;
    if($a)
    {
        $child_terms_ids = get_term_children( $a['term_id'], 'product_cat' );

        $temp = array_map('get_enable_subcategory',$child_terms_ids);

        $a['subcategory'] = plantapp_filter_array($temp);

        return $a;
    }
}

function plantapp_attach_category_image($arr)
{
    $a = (array) $arr;
    if($a)
    {
        $thumb_id = get_term_meta( $a['term_id'], 'thumbnail_id', true );
        $term_img = wp_get_attachment_url(  $thumb_id );

        if($term_img)
        {
            $a['image'] = $term_img;
        }
        else
        {
            $a['image'] = "";
        }
        return $a;
    }
}

function get_enable_subcategory($arr)
{
    $a = (array) $arr;
    foreach($a as $val)
    {
        $term_meta = get_option("enable_" . $val);
        if($term_meta)
        {
            return $val;
        }
    }
}

function plantapp_filter_array($arr)
{
    $res = [];
    foreach($arr as $key=>$val)
    {
        if($val != null)
        {
            array_push($res,$val);
        }
    }
    return $res;

}

function get_zone_type ($zone_locations) {
    $type = "";

    $types = $zone_locations->pluck('type')->unique()->toArray();

    if (in_array("state", $types) && in_array("postcode", $types)) {
        $type = "state_postcode";
    } elseif(in_array("country", $types) && in_array("postcode", $types)) {
        $type = "country_postcode";
    } elseif (in_array("state", $types)) {
        $type = "country_state";
    } elseif (in_array("country", $types)) {
        $type = "country";
    }

    return $type;
}

function plantapp_check_postcode($zone_locations,$parameters,$postcode){
    $codes = $zone_locations->where('type','postcode')->unique()->map( function ($pcode) use($parameters,$postcode) {

        if (strpos($pcode->code, '...') !== false) {

            $post_code = explode('...', $pcode->code);

            if ($post_code[0] <= $parameters['postcode'] && $post_code[1] >= $parameters['postcode'] ) {
                return $pcode;
            }else{
                return null;
            }
        } elseif (strpos($pcode->code, '*') !== false) {
            if ($pcode->code === $postcode) {
                return $pcode;
            }else{
                return null;
            }
        } elseif($pcode->code == $parameters['postcode']){
            return $pcode;
        }else{
            return null;
        }
    })->filter()->values()->count();

    return $codes;
}
function get_default_shipping_method($shipping_methods){
    $free_shipping = [];
    if(count($shipping_methods) > 0){
        foreach($shipping_methods as $method){
            array_push($free_shipping,$method);
        }
    }
    return array_values($free_shipping);
}

function plantapp_get_blogpost_data($wp_query = null, $user_id = null)
{
    $temp = [];
    global $post;
    global $wpdb;

	$image = wp_get_attachment_image_src(get_post_thumbnail_id($post->ID), [300, 300]);	
    $category = get_the_category($post->ID);
    $temp = [
        'ID'                => $post->ID,
        'image'             => !empty($image) ? $image[0] : null,
        'post_title'        => get_the_title(),
        'post_content'      => apply_filters( 'the_content', get_the_content(null,false,$post) ),
        'post_excerpt'      => esc_html(get_the_excerpt()),
        'post_date'         => $post->post_date,
        'post_date_gmt'     => $post->post_date_gmt,
        'readable_date'     => get_the_date(),
        'share_url'         => get_the_permalink(),
        'human_time_diff'   => human_time_diff(get_the_time('U'), current_time('timestamp')) . ' ' . __('ago'),
        'no_of_comments'    => get_comments_number(),
        'post_author_name'  => get_the_author( 'display_name' , $post->post_author ),
		'category' 		    => $category,
    ];
    return $temp;
}

function orderByArgument($orderby)
{
	switch ($orderby) {
		case 'recent':
			$key = 'ID';
			break;
		
		case 'discount':
			$key = 'plantapp_product_discount';
			break;
		case 'highest_rating':
			$key = 'meta_value_num';
			break;
		default:
		$key = 'ID';
			break;
	}

	return $key;
}

function productDiscount($regular_price, $sale_price, $type = null )
{
	$discount = 0;
	$regular_price = (float) $regular_price;
	$sale_price = (float) $sale_price;
	if($type == 'percentage')
	{
        $discount = round( 100 - ( $sale_price / $regular_price * 100 ), 3 ); // . '%';
	}

	if($type == 'price')
	{
        $discount = $regular_price - $sale_price;
	}
	return $discount;
}

function isPTDokanActive() {

    if (!function_exists('get_plugins')) {
        include_once ABSPATH . 'wp-admin/includes/plugin.php';
    }

    $plugins = get_plugins();
    
    foreach ($plugins as $key => $value) {
        if($value['TextDomain'] === 'dokan-lite') {
            return (is_plugin_active($key) ? true : false);
        }
    }
    return false ;
}

function plantapp_only_instock_products($query) {
	if ( defined( 'REST_REQUEST' ) && REST_REQUEST ) {
		$plantapp_option = get_option('plantapp_global_options');
		$exclude_outstock = ( !empty($plantapp_option) && isset($plantapp_option['exclude_outstock']) != null ) ? $plantapp_option['exclude_outstock'] : null; 

		if( $exclude_outstock != null && $exclude_outstock == 'true' && $query->get('meta_key') != '_customer_user'){

			$main_meta_query = $query->get('meta_query');
			if($query->get('post_type') == 'product')
			{
				$meta_query = array(
					$main_meta_query,
					array(
					'key'	=>'_stock_status',
					'value'	=>'outofstock',
					'compare'=>'!=',
					),
				);
				
				$query->set('meta_query',$meta_query);
			}
		}
	}
}

add_action( 'pre_get_posts', 'plantapp_only_instock_products' );

function get_discounttype_oparator($discount_type)
{
	$oparator = '=';
	switch ($discount_type) {
		case 'flat':
			$oparator = '=';
			break;
		case 'above':
			$oparator = '>=';
			break;
		case 'upto':
			$oparator = '<=';
			break;
		default:
			$oparator = '=';
			break;
	}
	
	return $oparator;
}