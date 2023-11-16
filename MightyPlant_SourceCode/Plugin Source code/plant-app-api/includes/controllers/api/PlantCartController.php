<?php

namespace Includes\Controllers\Api;
use WP_REST_Response;
use WP_REST_Server;
use WP_Query;
use WP_Post;
use Includes\baseClasses\PlantBase;

class PlantCartController extends PlantBase {

    public $module = 'cart';

    public $nameSpace;

    function __construct() {

        $this->nameSpace = PLANTAPP_API_NAMESPACE;

        add_action( 'rest_api_init', function () {

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/add-cart', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_add_cart' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-cart', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_cart' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/update-cart', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_update_cart' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/delete-cart', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_delete_cart' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/clear-cart', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_clear_cart' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/add-from-guest-cart', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_add_from_guest_cart' ],
                'permission_callback' => '__return_true'
            ));

         });

    }

    public function plantapp_add_cart($request)
    {
        global $wpdb;
    
        $parameters = $request->get_params();
    
        $data = plantAppValidationToken($request);

		if (!$data['status']) {
			return comman_custom_response($data,401);
        }
        
        $userid = $data['user_id'];

        if (!isset($parameters['pro_id'])) {
            return comman_message_response( __('Product id is required'),400);
        }
    
        $cart_items = $wpdb->get_results("SELECT * FROM 
                    {$wpdb->prefix}plant_app_add_to_cart 
                        where 
                        user_id=" . $userid . " AND pro_id =" . $parameters['pro_id'] . "", OBJECT);
    
        if (!empty($cart_items))
        {
            return comman_message_response( __('Product Already in Cart'),400);
        }
    
    
        $cart_data = [
            'color'     => isset($parameters['color']) ? $parameters['color'] : null,
            'size'      => isset($parameters['size']) ? $parameters['size'] : null,
            'quantity'  => isset($parameters['quantity']) ? $parameters['quantity'] : 0,
            'pro_id'    => isset($parameters['pro_id']) ? $parameters['pro_id'] : null,
            'user_id'   => $userid,
            'created_at'=> current_time('mysql'),
        ];

        $table = $wpdb->prefix . 'plant_app_add_to_cart';
    
        $res = $wpdb->insert($table, $cart_data);
        $code = 200;
        if($res > 0)
        {
            $message =  __('Products has been succesfully added to cart');
        }
        else
        {
            $message = __("Product not added to cart");
            $code = 400;
        }

        return comman_message_response($message,$code);
        
    }

    public function plantapp_get_cart($request)
    {
        $data = plantAppValidationToken($request);

		if (!$data['status']) {
			return comman_custom_response($data,401);
        }
        
        $userid = $data['user_id'];

        global $wpdb;
        global $product;
        $masterarray = array();
        $datarray = array();
    
        $cart_items = $wpdb->get_results("SELECT * FROM 
                                                    {$wpdb->prefix}plant_app_add_to_cart 
                                                        where 
                                                            user_id=" . $userid . "", OBJECT);
    
        if( empty ($cart_items)) {
            return comman_message_response( __('Cart List Empty') );
        }

        $product_ids = collect($cart_items)->toArray();

        $response = [
            'total_quantity'    => 0,
            'data'              => []
        ];

        if(!empty($product_ids) && count($product_ids) > 0) {

            $masterarray = collect($product_ids)->map( function ($product_ids) {
            $products = wc_get_product($product_ids->pro_id);
            $exit = false;
            
            if (!empty($products) && $products->get_status() == 'publish')
            {
                $exit = true;
            }
            if ( $exit ){
                $datarray = [
                    'cart_id' => $product_ids->ID,
                    'pro_id' => $products->get_id(),
                    'name' => $products->get_name(),
                    'sku' => $products->get_sku(),
                    'price' => $products->get_price(),
                    'on_sale' => $products->is_on_sale(),
                    'regular_price' => $products->get_regular_price(),
                    'sale_price' => $products->get_sale_price(),
                    'stock_quantity' => $products->get_stock_quantity(),
                    'stock_status' => $products->get_stock_status(),
                    'shipping_class' => $products->get_shipping_class(),
                    'shipping_class_id' => $products->get_shipping_class_id(),
                    'plant_product_type' => get_post_meta( $products->get_id(), 'plant_product_type', true ),
                    'description' => $products->get_description(),
                ];

                $thumb = wp_get_attachment_image_src($products->get_image_id() , "thumbnail");
                $full = wp_get_attachment_image_src($products->get_image_id() , "full");
                
                $datarray['thumbnail'] = !empty($thumb) ? $thumb[0] : null;
                $datarray['full'] = !empty($full) ? $full[0] : null;
    
                $gallery = array();
                foreach ($products->get_gallery_image_ids() as $img_id) {
                    $g = wp_get_attachment_image_src($img_id, "full");
                    $gallery[] = $g[0];
                }
                $datarray['gallery'] = $gallery;
                $gallery = array();
    
                $datarray['created_at'] = $product_ids->created_at;
                $datarray['quantity'] = $product_ids->quantity;
                
                return $datarray;
            }
            });
            $response['total_quantity'] = $masterarray->sum('quantity');
            $response['data'] = plantapp_filter_array($masterarray);
        }
        
        return comman_custom_response($response);
    
    }

    public function plantapp_update_cart($request)
    {
        global $wpdb;
    
        $parameters = $request->get_params();
    
        $data = plantAppValidationToken($request);

		if (!$data['status']) {
			return comman_custom_response($data,401);
        }
        
        $userid = $data['user_id'];
        $table = $wpdb->prefix . 'plant_app_add_to_cart';
            $insdata = array();
    
            if(isset($parameters['color']))
            {
                $insdata['color'] = $parameters['color'];
            }
            if(isset($parameters['size']))
            {
                $insdata['size'] = $parameters['size'];
            }
            if(isset($parameters['quantity']))    
            {
                $insdata['quantity'] = $parameters['quantity'];
            }  
        
            $insdata['user_id']     = $userid;
            $insdata['created_at']  = current_time('mysql');
            $insdata['pro_id']      = $parameters['pro_id'];
            
            $cond = array(
                "ID" => $parameters['cart_id']
            );
    
            $res = $wpdb->update($table, $insdata, $cond);
    
    
        if($res > 0)
        {
           $message = __("Cart Updated Successfully");
           $status_code = 200;
        } else {
            $message = __("Cart Not Updated");
            $status_code = 400;
        }
       
        return comman_message_response ( $message, $status_code );
    }

    public function plantapp_delete_cart($request)
    {
        global $wpdb;
    
        $parameters = $request->get_params();
    
        $data = plantAppValidationToken($request);

		if (!$data['status']) {
			return comman_custom_response($data,401);
        }
        
        $userid = $data['user_id'];
        $table = $wpdb->prefix . 'plant_app_add_to_cart';
    
        $cart_items = $wpdb->delete( $table , array ('user_id' => $userid , 'pro_id' => $parameters['pro_id']) );

        return comman_message_response ( __('Product Deleted From Cart'), 200 );
    
    }

    public function plantapp_clear_cart($request)
    {
        global $wpdb;
    
        $parameters = $request->get_params();
    
        $data = plantAppValidationToken($request);

		if (!$data['status']) {
			return comman_custom_response($data,401);
        }
        
        $userid = $data['user_id'];
        $table = $wpdb->prefix . 'plant_app_add_to_cart';

        $cart_items = $wpdb->delete( $table , array ('user_id' => $userid ));

        return comman_message_response ( __('All Product Deleted From Cart'), 200 );
    
    }

    public function plantapp_add_from_guest_cart($request)
    {
        global $wpdb;
    
        $parameters = $request->get_params();
    
        $cart_data = $parameters['cart_data'];
        $data = plantAppValidationToken($request);

		if (!$data['status']) {
			return comman_custom_response($data,401);
        }
        
        $userid = $data['user_id'];

        if(!empty($cart_data) && count($cart_data) > 0 )
        {
            $table = $wpdb->prefix . 'plant_app_add_to_cart';
            foreach($cart_data as $cart)
            {
                $insdata = [
                    'ID'        => null,
                    'color'     => isset($cart['color']) ? $cart['color'] : null,
                    'size'      => isset($cart['size']) ? $cart['size'] : null,
                    'quantity'  => isset($cart['quantity']) ? $cart['quantity'] : 0,
                    'pro_id'    => isset($cart['pro_id']) ? $cart['pro_id'] : null,
                    'user_id'   => $userid,
                    'created_at'=> current_time('mysql'),
                ];
                
                $res = $wpdb->insert($table, $insdata);
                
            }
            $message = 'Products has been succesfully added to cart';
        } else {
            $message = 'Cart List Empty';
        }
    
        return comman_message_response( $message );
    }
}