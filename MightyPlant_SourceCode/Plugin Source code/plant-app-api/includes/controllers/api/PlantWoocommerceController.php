<?php

namespace Includes\Controllers\Api;
use WP_REST_Response;
use WP_REST_Server;
use WP_Query;
use WP_Post;
use Includes\baseClasses\PlantBase;
use WC_Shipping_Zones;
use WC_Shipping_Zone;
use WC_Order;
use Automattic\WooCommerce\Client;
use Automattic\WooCommerce\HttpClient\HttpClientException;

class PlantWoocommerceController extends PlantBase {

    public $module = 'woocommerce';

	public $nameSpace;

	function __construct() {

        $this->nameSpace = PLANTAPP_API_NAMESPACE;
        
        add_action( 'rest_api_init', function () {

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-product', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_product' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-product-details', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_product_details' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-sub-category', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_sub_category' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-product-attribute', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_product_attribute' ],
                'permission_callback' => '__return_true'
            ));


            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-dashboard', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_dashboard' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-checkout-url', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_checkout_url' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-product-attributes', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_product_attributes_with_terms' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-customer-orders', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_customer_orders' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-stripe-client-secret', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'getStripeClientSecret' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-shipping-methods', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_method' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-custom-dashboard', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_custom_dashboard' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-custom-dashboard-slider', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_custom_dashboard_slider' ],
                'permission_callback' => '__return_true'
            ));
            
            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-admin-dashboard', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_admin_dashboard' ],
                'permission_callback' => '__return_true'
            ));
            if(isPTDokanActive() == true)
            {
                register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-vendors', array(
                    'methods'             => WP_REST_Server::ALLMETHODS,
                    'callback'            => [ $this, 'plantapp_get_vendors' ],
                    'permission_callback' => '__return_true'
                ));
            
                register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-vendor-products', array(
                    'methods'             => WP_REST_Server::ALLMETHODS,
                    'callback'            => [ $this, 'plantapp_get_vendor_products' ],
                    'permission_callback' => '__return_true'
                ));

                register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-vendor-dashboard', array(
                    'methods'             => WP_REST_Server::ALLMETHODS,
                    'callback'            => [ $this, 'plantapp_get_vendor_dashboard' ],
                    'permission_callback' => '__return_true'
                ));
            }
            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-app-configuration', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_app_configuration' ],
                'permission_callback' => '__return_true'
            ));
        });
    }

    public function plantapp_get_app_configuration($request)
    {
        global $post;
        global $wpdb;
        $parameters    = $request->get_params();
        $plantapp_option = get_option( 'plantapp_app_options' );
        $advertisement_options = get_option( 'plantapp_advertisement_options' );
        $app_lang_option = get_option( 'plantapp_global_options' );
        $masterarray   = [];
        $dashboard     = [];
        $social        = [];

        $product_per_page = isset($parameters['product_per_page']) && !empty($parameters['product_per_page']) ? $parameters['product_per_page'] : 10;
        $data = plantAppValidationToken($request);
		$userid = null;
		if ($data['status']) {
			$userid = $data['user_id'];
		}

        $social['whatsapp'] = isset( $plantapp_option['whatsapp'] ) ? $plantapp_option['whatsapp'] : '';
        $social['facebook'] = isset( $plantapp_option['facebook'] ) ? $plantapp_option['facebook'] : '';
        $social['twitter'] = isset( $plantapp_option['twitter'] ) ? $plantapp_option['twitter'] : '';
        $social['instagram'] = isset( $plantapp_option['instagram'] ) ? $plantapp_option['instagram'] : '';
        $social['contact'] = isset( $plantapp_option['contact'] ) ? $plantapp_option['contact'] : '';
        $social['website_url'] = isset( $plantapp_option['website_url'] ) ? $plantapp_option['privacy_policy'] : '';
        $social['privacy_policy'] = isset( $plantapp_option['privacy_policy'] ) ? $plantapp_option['privacy_policy'] : '';
        $social['shipping_policy'] = isset( $plantapp_option['shipping_policy'] ) ? $plantapp_option['privacy_policy'] : '';
        $social['refund_policy'] = isset( $plantapp_option['refund_policy'] ) ? $plantapp_option['privacy_policy'] : '';
        $social['copyright_text'] = isset( $plantapp_option['copyright_text'] ) ? esc_html( $plantapp_option['copyright_text']) : '';
        $social['term_condition'] = isset( $plantapp_option['term_condition'] ) ? esc_html( $plantapp_option['term_condition']) : '';
        
        $dashboard['social_link'] = $social;
    
        $dashboard['app_lang'] = isset( $app_lang_option['app_lang'] ) ? $app_lang_option['app_lang'] : 'en';
        $dashboard['payment_method'] = isset( $app_lang_option['payment_method'] ) ? $app_lang_option['payment_method'] : '';
       
        $exclude_outstock = ( !empty($app_lang_option) && isset($app_lang_option['exclude_outstock']) != null ) ? $app_lang_option['exclude_outstock'] : null;
        $dashboard['exclude_outstock'] = (bool) $exclude_outstock;

        $enable_custom_dashboard = ( !empty($app_lang_option) && isset($app_lang_option['enable_custom_dashboard']) != null ) ? $app_lang_option['enable_custom_dashboard'] : null;
        $dashboard['enable_custom_dashboard'] = (bool) $enable_custom_dashboard;
        $dashboard['is_dokan_active'] = isPTDokanActive();
        $dashboard['banner'] = [];
    
        if ( isset( $advertisement_options['banner'] ) && ! empty( $advertisement_options['banner'] ) ) {
            $i = 1;
            foreach ( $advertisement_options['banner'] as $slide ) {
    
                $image = wp_get_attachment_image_src($slide['banner_slider'],'full');
                $thumb = wp_get_attachment_image_src($slide['banner_slider'],'thumbnail');
                $array['image'] = !empty($image) ? $image[0] : null;
                $array['thumb'] = !empty($thumb) ? $thumb[0] : null;
                $array['url']   = $slide['url'];
                $array['desc']  = $slide['title'];
    
                if ( ! empty( $slide['banner_slider'] ) ) {
                    $dashboard['banner'][] = $array;
                }
                $array = array();
                $i ++;
            }
    
        }    
        
        $dashboard['enable_coupons'] = wc_coupons_enabled();
    
        $dashboard['currency_symbol'] = [
            "currency_symbol" => get_woocommerce_currency_symbol(),
            "currency"        => get_woocommerce_currency()
        ];

        $taxonomy     = 'product_cat';
        $orderby      = 'name';
        $show_count   = 0; // 1 for yes, 0 for no
        $pad_counts   = 0; // 1 for yes, 0 for no
        $hierarchical = 1; // 1 for yes, 0 for no
        $title        = '';
        $empty        = 0;
    
        $args = array(
            'taxonomy'     => $taxonomy,
            'orderby'      => $orderby,
            'show_count'   => $show_count,
            'pad_counts'   => $pad_counts,
            'hierarchical' => $hierarchical,
            'title_li'     => $title,
            'hide_empty'   => $empty,
            'parent'       => 0,
            'number'       => 10
        );
        $all_categories = get_categories( $args );
    
        $a = array_map( 'get_category_child', $all_categories );
    
        $dashboard['category'] = array_map( 'plantapp_attach_category_image', $a );

		$args = [
			'post_type' 		=> 'post',
			'post_status' 		=> 'publish',
			'posts_per_page' 	=> (!empty($parameters['posts_per_page']) && isset($parameters['posts_per_page'])) ? $parameters['posts_per_page'] : 5,
            'paged' 			=> 1,
            'order'             => 'desc',
            'orderby'           => 'post_date'
        ];

        $masterarray = [];    
        $wp_query = new WP_Query( $args );

		if ($wp_query->have_posts()) {
			while ($wp_query->have_posts()) {
				$wp_query->the_post();
				array_push($masterarray, plantapp_get_blogpost_data($wp_query));
            }
        }
        $dashboard['blog'] = $masterarray;
        
        $dashboard['vendors'] = [];
        if(isPTDokanActive() == true)
        {
            $shops = dokan()->vendor->get_vendors( [
                'number' => 5
            ] );
        
            if (count($shops)) {
                foreach ($shops as $k => $shop) {
                    $shop_array = $shop->to_array();
        
                    $dashboard['vendors'][] = $shop_array;
                    if(empty($shop_array['social'])){
                        $dashboard['vendors'][$k]['social'] = (object) $shop_array['social'];
                    }
                    if(empty($shop_array['address'])){
                        $dashboard['vendors'][$k]['address'] = (object) $shop_array['address'];
                    }
                    if(empty($shop_array['store_open_close']['time'])){
                        $dashboard['vendors'][$k]['store_open_close']['time'] = (object) $shop_array['store_open_close']['time'];
                    }
                }
            }
        }
        return comman_custom_response($dashboard);
    }

    public function plantapp_get_product( $request ) {
        global $product;
    
        $parameters = $request->get_params();
    
        $array       = array();
        $masterarray = array();
    
        $meta      = array();
        $dummymeta = array();
        $taxargs   = array();
        $tax_query = array();
        $args      = array();
        $page      = 1;
        $product_per_page      = 15;
    
        $data = plantAppValidationToken($request);
		$userid = null;
		if ($data['status']) {
			$userid = $data['user_id'];
		}
    
        if ( ! empty( $parameters ) ) {
            foreach ( $parameters as $key => $data ) {
                $taxargs['relation'] = 'AND';
    
                if ( $key == "price" ) {
                    $meta['key']     = '_price';
                    $meta['value']   = $parameters['price'];
                    $meta['compare'] = 'BETWEEN';
                    $meta['type']    = 'NUMERIC';

                }
    
                if ( $key == "category" ) {
                    $tax_query['taxonomy'] = 'product_cat';
                    $tax_query['field']    = 'term_id';
                    $tax_query['terms']    = $parameters[ $key ];
                    $tax_query['operator'] = 'IN';
                    array_push( $taxargs, $tax_query );
                }
    
                if ( $key == "page" ) {
                    $page = $parameters[ $key ];
                }
                if( $key == "item_type" && !empty($parameters['item_type']) ){
                    $meta['key']     = 'plant_product_type';
                    $meta['value']   = $parameters['item_type'];
                    array_push( $dummymeta, $meta );
                }
    
            }
    
            if(isset($parameters['attribute']) && !empty($parameters['attribute']))
            {
                foreach($parameters['attribute'] as $key=>$val)
                {
                    foreach($val as $k => $v)
                    {
                        $tax_query['taxonomy'] = $k;
                        $tax_query['field']    = 'term_id';
                        $tax_query['terms']    = $v;
                        $tax_query['operator'] = 'IN';
                        array_push( $taxargs, $tax_query );
                    }
                }
            }
    
            if(isset($parameters['text']) && !empty($parameters['text']))
            {
                $args['plantapp_title_filter'] = $parameters['text'];
            }
    
            if(isset($parameters['product_per_page']) && !empty($parameters['product_per_page']))
            {
                $product_per_page = $parameters['product_per_page'];
            }
    
            if(isset($parameters['best_selling']) && !empty($parameters['best_selling']))
            {
                $args['meta_key'] = $parameters['best_selling'];
                $args['orderby'] = isset($parameters['meta_value_num']) ? $parameters['meta_value_num'] : 'DESC';
            }
    
            if(isset($parameters['on_sale']) && !empty($parameters['on_sale']))
            {
                $args['post__in'] = wc_get_product_ids_on_sale();    
            }
            if(isset($parameters['featured']) && !empty($parameters['featured']))
            {
                $tax_query['taxonomy'] = $parameters['featured'];
                $tax_query['field']    = 'name';
                $tax_query['terms']    = 'featured';
                $tax_query['operator'] = 'IN';
                array_push( $taxargs, $tax_query );
            }
    
            if(isset($parameters['newest']) && !empty($parameters['newest']))
            {
                $args['orderby'] = 'ID';
                $args['order'] = 'DESC';
    
            }
    
            if(isset($parameters['special_product']) && !empty($parameters['special_product']))
            {
                $dummymeta =
                    array(
                        array(
                            'key' => 'plantapp_'.$parameters['special_product'],
                            'value' => array('yes'),
                            'compare' => 'IN',
                        )
                    );
                array_push( $meta, $dummymeta );
            }    
        }

        $args['post_type']      = 'product';
        $args['post_status']    = 'publish';
        $args['posts_per_page'] = $product_per_page;
        $args['paged']          = $page;
    
        if ( ! empty( $meta ) ) {
            $args['meta_query'] = $dummymeta;
        }
        if ( ! empty( $taxargs ) ) {
            $args['tax_query'] = $taxargs;
        }

        $wp_query = new WP_Query( $args );
    
        $total     = $wp_query->found_posts;
        $num_pages = 1;
        $i       = 1;
        while ( $wp_query->have_posts() ) {
            $num_pages = $wp_query->max_num_pages;
            $wp_query->the_post();
            $masterarray [] = plantapp_get_product_details_helper( get_the_ID() ,$userid );
            $i ++;
        }
        $response = array(
                "num_of_pages" => $num_pages,
                "data" => $masterarray
            );
        return comman_custom_response($response);
    }

    public function plantapp_get_product_details( $request ) {

        global $product;
    
        $parameters = $request->get_params();
    
        $data = plantAppValidationToken($request);
		$userid = null;
		if ($data['status']) {
			$userid = $data['user_id'];
		}
    
        $json_response = [];
    
        $product_details = plantapp_get_product_list_helper( $parameters['product_id'] ,$userid );
    
        if ( $product_details != [] ) {
            $json_response[] = $product_details;
            if ( isset( $product_details['variations'] ) && count( $product_details['variations'] ) ) {
                foreach ( $product_details['variations'] as $variation ) {
                    $product = plantapp_get_product_list_helper( $variation ,$userid );
    
                    if ( $product != [] ) {
                        $json_response[] = $product;
                    }
                }
            }
        }
    
        return comman_custom_response ( $json_response );
    
    }

    public function plantapp_get_sub_category( $request ) {

        $parameters = $request->get_params();
    
        $taxonomy     = 'product_cat';
        $orderby      = 'name';
        $show_count   = 0; // 1 for yes, 0 for no
        $pad_counts   = 0; // 1 for yes, 0 for no
        $hierarchical = 1; // 1 for yes, 0 for no
        $title        = '';
        $empty        = 0;
    
    
        $args = array(
            'taxonomy'     => $taxonomy,
            'orderby'      => $orderby,
            'show_count'   => $show_count,
            'pad_counts'   => $pad_counts,
            'hierarchical' => $hierarchical,
            'title_li'     => $title,
            'child_of'     => $parameters['cat_id'],
            'hide_empty'   => $empty,
            'parent'       => $parameters['cat_id']
        );
    
        $all_categories = get_categories( $args );
    
        $a   = array_map( 'get_category_child', $all_categories );
        $arr = array_map( 'plantapp_attach_category_image', $a );
    
    
        return comman_custom_response ( plantapp_filter_array( $arr ) );
    
    }

    public function plantapp_get_product_attribute( $request ) {

        $masterarray = array();
        $parameters  = $request->get_params();
    
        $taxonomy     = 'product_cat';
        $orderby      = 'name';
        $show_count   = 0; // 1 for yes, 0 for no
        $pad_counts   = 0; // 1 for yes, 0 for no
        $hierarchical = 1; // 1 for yes, 0 for no
        $title        = '';
        $empty        = 0;
    
        $args           = array(
            'taxonomy'     => $taxonomy,
            'orderby'      => $orderby,
            'show_count'   => $show_count,
            'pad_counts'   => $pad_counts,
            'hierarchical' => $hierarchical,
            'title_li'     => $title,
            'hide_empty'   => $empty,
            'parent'       => 0
        );
        $all_categories = get_categories( $args );
    
        $a   = array_map( 'get_category_child', $all_categories );
        $arr = array_map( 'plantapp_attach_category_image', $a );
    
    
        $masterarray['categories'] = plantapp_filter_array( $arr );
    
        $size = array();
        if ( taxonomy_exists( 'pa_size' ) ) {
            $size = get_terms( array(
                'taxonomy'   => 'pa_size',
                'hide_empty' => false,
            ) );
    
        }
    
        $masterarray['sizes'] = $size;
    
        $brand = array();
    
        if ( taxonomy_exists( 'pa_brand' ) ) {
            $brand = get_terms( array(
                'taxonomy'   => 'pa_brand',
                'hide_empty' => false,
            ) );
        }
    
        $masterarray['brands'] = $brand;
    
        $color = array();
    
        if ( taxonomy_exists( 'pa_color' ) ) {
            $color = get_terms( array(
                'taxonomy'   => 'pa_color',
                'hide_empty' => false,
            ) );
    
        }
    
        $masterarray['colors'] = $color;
    
        if ( taxonomy_exists( 'pa_weight' ) ) {
            $size = get_terms( array(
                'taxonomy'   => 'pa_weight',
                'hide_empty' => false,
            ) );
    
        }
    
        $masterarray['pa_weight'] = $size;
    
        return comman_custom_response ( $masterarray );
    
    }


    public function plantapp_get_dashboard( $request )
    {
        global $post;
        global $wpdb;
        $parameters = $request->get_params();
 
        $masterarray   = [];
        $dashboard     = [];
        $product_per_page = isset($parameters['product_per_page']) && !empty($parameters['product_per_page']) ? $parameters['product_per_page'] : 10;
        $data = plantAppValidationToken($request);
		$userid = null;
		if ($data['status']) {
			$userid = $data['user_id'];
		}
    

        $masterarray = array();
    
        if ( $userid != null ) {
            $customer_orders = wc_get_orders( array(
                'meta_key'    => '_customer_user',
                'meta_value'  => $userid,
                'numberposts' => - 1
            ) );
            $count           = 0;
    
            $dashboard['total_order'] = count( $customer_orders );
        }
    
    
        // Best Selling Product
        $masterarray = array();
        $args        = array(
            'post_type'      => 'product',
            'post_status'    => 'publish',
            'posts_per_page' => $product_per_page,
            'paged'          => 1,
            'meta_key'       => 'total_sales',
            'orderby'        => 'meta_value_num'
        );
    
        $wp_query  = new WP_Query( $args );
        $total     = $wp_query->found_posts;
        $num_pages = 1;
        $num_pages = $wp_query->max_num_pages;
        $i         = 1;
        if ( $total == 0 ) {
            $masterarray = array();
        }
    
    
        while ( $wp_query->have_posts() ) {
            $wp_query->the_post();

            $masterarray[] = plantapp_get_product_details_helper( get_the_ID(), $userid );
    
        }
    
        $dashboard['best_selling_product'] = $masterarray;
    
        // Best Selling Product
    
        // Sale product Start
        $masterarray = array();
        $args        = array(
            'post_type'      => 'product',
            'post_status'    => 'publish',
            'posts_per_page' => $product_per_page,
            'paged'          => 1,
            'post__in'       => wc_get_product_ids_on_sale(),
        );
    
        $wp_query  = new WP_Query( $args );
        $total     = $wp_query->found_posts;
        $num_pages = 1;
        $num_pages = $wp_query->max_num_pages;
        $i         = 1;
        if ( $total == 0 ) {
            $masterarray = array();
        }
    
    
        while ( $wp_query->have_posts() ) {
            $wp_query->the_post();
    
            $masterarray[] = plantapp_get_product_details_helper( get_the_ID(), $userid );    
    
        }
    
        $dashboard['sale_product'] = $masterarray;
    
        // Sale product end
        // plantapp_featured Product start
        $masterarray = array();
    
        $args = array(
            'post_type'      => 'product',
            'post_status'    => 'publish',
            'posts_per_page' => $product_per_page,
            'paged'          => 1,
            'tax_query'      => array(
                array
                (
                    'taxonomy' => 'product_visibility',
                    'field'    => 'name',
                    'terms'    => 'featured'
                )
    
            )
    
        );
    
        $wp_query  = new WP_Query( $args );
        $total     = $wp_query->found_posts;
        $num_pages = 1;
        $num_pages = $wp_query->max_num_pages;
        $i         = 1;
        if ( $total == 0 ) {
            $masterarray = array();
        }
    
    
        while ( $wp_query->have_posts() ) {
            $wp_query->the_post();
    
            $masterarray[] = plantapp_get_product_details_helper( get_the_ID(), $userid );
    
        }
    
        $dashboard['featured'] = $masterarray;
        $masterarray           = array();
    
        // plantapp_featured Product End
    
        // plantapp_newest Product start
    
        $masterarray = array();
    
        $args = array(
            'post_type'      => 'product',
            'post_status'    => 'publish',
            'posts_per_page' => $product_per_page,
            'paged'          => 1,
            'orderby'        => 'ID',
            'order'          => 'DESC',
        );
    
        $wp_query  = new WP_Query( $args );
        $total     = $wp_query->found_posts;
        $num_pages = 1;
        $num_pages = $wp_query->max_num_pages;
        $i         = 1;
        if ( $total == 0 ) {
            $masterarray = array();
        }
    
    
        while ( $wp_query->have_posts() ) {
            $wp_query->the_post();
    
            $masterarray[] = plantapp_get_product_details_helper( get_the_ID(), $userid );
    
        }
    
        $dashboard['newest'] = $masterarray;
    
        // plantapp_newest Product End

        // plantapp_highest rating Product Start
        $masterarray = [];
        $args = array(
			'posts_per_page' => $product_per_page,
            'paged'          => 1,
			'post_status'    => 'publish',
			'post_type'      => 'product',
			'meta_key'       => '_wc_average_rating',
			'orderby'        => 'meta_value_num',
			'order'          => 'DESC',
		);
		
        $wp_query  = new WP_Query( $args );

        while ( $wp_query->have_posts() ) {
            $wp_query->the_post();
    
            $masterarray[] = plantapp_get_product_details_helper( get_the_ID(), $userid );
        }

        $dashboard['highest_rating'] = $masterarray;
        // plantapp_highest rating Product End

        // plantapp Discount Product Start
        $masterarray = [];
        $args = array(
			'posts_per_page'    => $product_per_page,
            'paged'             => 1,
			'post_status'       => 'publish',
			'post_type'         => 'product',
			'orderby'           => 'ID',
			'order'             => 'DESC',
            'post__in'          => wc_get_product_ids_on_sale(),
            'meta_query'        => array(
                array(
                    'key' => 'plantapp_product_discount',
                    'value' => array(0,20),
                    'compare' => 'BETWEEN',
                )
            )
		);
		
        $wp_query  = new WP_Query( $args );

        while ( $wp_query->have_posts() ) {
            $wp_query->the_post();
    
            $masterarray[] = plantapp_get_product_details_helper( get_the_ID(), $userid );
        }

        $dashboard['discount'] = $masterarray;
        
        // plantapp_highest rating Product End
        
        return comman_custom_response ( $dashboard );
    }

    public function plantapp_get_custom_dashboard( $request )
    {
        global $post;
        global $wpdb;
        $parameters    = $request->get_params();
        $custom_dashboard_option = get_option( 'plantapp_customdashboard_options');
        $masterarray = [];

        $data = plantAppValidationToken($request);
		$userid = null;
		if ($data['status']) {
			$userid = $data['user_id'];
		}
        if( !empty($custom_dashboard_option['slider']) && count($custom_dashboard_option['slider']) > 0 )
        {
            $slider_data = [];
            
            foreach( $custom_dashboard_option['slider'] as $slider )
            {
                $orderby = orderByArgument($slider['type']);
                $args = [
                    'post_type' 		=> 'product',
                    'post_status' 		=> 'publish',
                    'posts_per_page' 	=> (!empty($parameters['posts_per_page']) && isset($parameters['posts_per_page'])) ? $parameters['posts_per_page'] : 10,
                    'paged' 			=> 1,
                    'orderby'           => $orderby,
                    'order'             => $slider['order'],
                ];
                if($slider['type'] == 'discount')
                {
                    $discount_oparator = get_discounttype_oparator($slider['discount_type']);
                    $args['post__in'] = wc_get_product_ids_on_sale();
                    $args['meta_query'] = array(
                        array(
                            'key' => 'plantapp_product_discount',
                            'value' => $slider['discount'],
                            'type' => 'DECIMAL',
                            'compare' => $discount_oparator
                        )
                    );
                }

                if($slider['type'] == 'featured')
                {
                    $args['tax_query']  = array(
                        array
                        (
                            'taxonomy' => 'product_visibility',
                            'field'    => 'name',
                            'terms'    => 'featured'
                        )
                    );
                }

                if($slider['type'] == 'highest_rating')
                {
                    $args['meta_key'] = '_wc_average_rating';
                }
                
                $product_data = new WP_Query( $args );
                $sdata = [];
                if($product_data->have_posts()) {
                    while($product_data->have_posts()) {
                        $product_data->the_post();                        
                        $sdata[] = plantapp_get_product_details_helper( get_the_ID() ,$userid );
                    }
                }
                $args = [];
                $sliderdata = [
                    'title' => $slider['title'],
                    'view_all' =>  (bool) $slider['view_all'],
                    'category' => $slider['category'],
                    'type' => $slider['type'],
                    'discount_type' => $slider['discount_type'],
                    'orderby' => $slider['order'],
                    'data' =>  $sdata
                ];
                $slider_data[] = $sliderdata;
            }
            $masterarray = $slider_data;
        }

        return comman_custom_response($masterarray);
    }

    public function plantapp_get_checkout_url( $request ) {
        global $wpdb;
        $masterarray = array();
    
    
        $parameters = $request->get_params();
    
        if ( empty( $parameters['order_id'] ) ) {
            return comman_message_response ( __('Order Id Is Missing') , 400 );
        }
    
        $data = plantAppValidationToken($request);

		if (!$data['status']) {
			return comman_custom_response($data,401);
        }
        
        $userid = $data['user_id'];
        $table = $wpdb->prefix . 'plant_app_add_to_cart';
    
        $cart_items = $wpdb->delete( $table , array ('user_id' => $userid ) );
    
        $order = new WC_Order( $parameters['order_id'] );
    
    
        $payment_page = $order->get_checkout_payment_url();
    
        $masterarray['checkout_url'] = $payment_page;
    
        return comman_custom_response ( $masterarray );
    }
    
    public function plantapp_get_product_attributes_with_terms( $request ) {
        $masterarray = array();
        $attributes = wc_get_attribute_taxonomies();
        $attribute_data = array();
    
        if (count($attributes)) {
            foreach ($attributes as $attribute) {
    
                $temp = array(
                    'id' => $attribute->attribute_id,
                    'name' => $attribute->attribute_label,
                    'slug' => $attribute->attribute_name,
                    'type' => $attribute->attribute_type,
                    'order_by' => $attribute->attribute_orderby,
                    'has_archives' => $attribute->attribute_public,
                    'terms' => get_terms(wc_attribute_taxonomy_name($attribute->attribute_name), 'hide_empty=0'),
                );
    
                $attribute_data[] = $temp;
            }
        }
    
        $masterarray['attribute'] = $attribute_data;
    
        // Get all product categories...
        $taxonomy     = 'product_cat';
        $orderby      = 'name';
        $show_count   = 0;      // 1 for yes, 0 for no
        $pad_counts   = 0;      // 1 for yes, 0 for no
        $hierarchical = 1;      // 1 for yes, 0 for no
        $title        = '';
        $empty        = 0;
    
        $args = array(
            'taxonomy' => $taxonomy,
            'orderby' => $orderby,
            'show_count' => $show_count,
            'pad_counts' => $pad_counts,
            'hierarchical' => $hierarchical,
            'title_li' => $title,
            'hide_empty' => $empty,
            'category_parent' => 0
        );
    
        $all_categories = collect(get_categories($args))->map(function ($category) {
            $category->sub_categories = collect(get_categories(array(
                'category_parent' => $category->category_parent,
                'taxonomy' => 'product_cat',
                'child_of' => 0,
                'parent' => $category->term_id,
                'orderby' => 'name',
                'show_count' => 0,
                'pad_counts' => 0,
                'hierarchical' => 1,
                'title_li' => '',
                'hide_empty' => 0
            )));
            return $category;
        });
    
    
        $masterarray['categories'] = $all_categories;
    
        $response = new WP_REST_Response( $masterarray );
        $response->set_status( 200 );
    
        return $response;
    
    }
    
    public function plantapp_get_customer_orders($request) {
    
        $data = plantAppValidationToken($request);

		if (!$data['status']) {
			return comman_custom_response($data,401);
        }
        
        $userid = $data['user_id'];
    
        global $wpdb;
        $masterarray = array();
    
        $customer_orders = get_posts(array(
            'numberposts' => -1,
            'meta_key' => '_customer_user',
            'orderby' => 'date',
            'order' => 'DESC',
            'meta_value' => $userid,
            'post_type' => wc_get_order_types(),
            'post_status' => array_keys(wc_get_order_statuses()),
            //'post_status' => array('wc-processing', 'wc-pending'),
        ));
    
        if (count($customer_orders)) {
            foreach ($customer_orders as $order) {
                $details = new WC_Order( $order->ID );
                $temp = $details->get_data();
    
                $line_items = [];
                if (count($temp['line_items'])) {
                    foreach ($temp['line_items'] as $line) {
                        $line_data = $line->get_data();
    
                        if (isset($line_data['product_id'])) {
                            $product_id = $line_data['product_id'];
                            $product = wc_get_product( $product_id );
                            $line_data['product_images'] = plantapp_get_product_images_helper($product);
                        }
    
                        $line_items[] = $line_data;
                    }
                    $temp['line_items'] = $line_items;
                }
    
                $masterarray[] = $temp;
            }
        }
    
        return comman_custom_response ( $masterarray );
    
    }

    public function getStripeClientSecret ($request) {

        $master = [];
    
        $parameters = $request->get_params();
    
        $data = plantAppValidationToken($request);

		if (!$data['status']) {
			return comman_custom_response($data,401);
        }
        $status_code = 200;
        try {
    
            \Stripe\Stripe::setApiKey($parameters['apiKey']);
    
            $intent = \Stripe\PaymentIntent::create([
                'amount' => $parameters['amount'],
                'currency' => $parameters['currency'],
    
                'description' => isset($parameters['description']) ? $parameters['description'] : "",
                'shipping' => [
                    'name' => 'Jenny Rosen',
                    'address' => [
                        'line1' => '510 Townsend St',
                        'postal_code' => '98140',
                        'city' => 'San Francisco',
                        'state' => 'CA',
                        'country' => 'US',
                    ],
                ]
    
            ]);
    
            $master['client_secret'] = $intent->client_secret;
            $master['message'] = "Token generated";
    
        } catch (Exception $e) {
            $master['message'] = $e->getMessage();
            $master['client_secret'] = "";

            $status_code = 400;
        }
    
        return comman_custom_response( $master ,$status_code );
    }

    public function plantapp_get_vendors ($request)
    {
        $masterarray = [];
        $parameters = $request->get_params();
        if(isPTDokanActive() == true)
        {
            $shops = dokan()->vendor->get_vendors([
                'number' => (isset($parameters['vendor_per_page']) && $parameters['vendor_per_page'] != '' ) ? $parameters['vendor_per_page'] : 10,
                'paged' => (isset($parameters['page']) && $parameters['page'] != '' ) ? $parameters['page'] : 1
            ]);
        
            if (count($shops)) {
                foreach ($shops as $k => $shop) {
                    $shop_array = $shop->to_array();
                    $masterarray[] = $shop_array;
                    
                    if(empty($shop_array['social'])){
                        $masterarray[$k]['social'] = (object) $shop_array['social'];
                    }
                    if(empty($shop_array['address'])){
                        $masterarray[$k]['address'] = (object) $shop_array['address'];
                    }
                    if(empty($shop_array['store_open_close']['time'])){
                        $masterarray[$k]['store_open_close']['time'] = (object) $shop_array['store_open_close']['time'];
                    }
                }
            }
        }
        return comman_custom_response ( $masterarray );
    }

    public function plantapp_get_vendor_products ($request)
    {

        $masterarray = [];
    
        $parameters = $request->get_params();
    
        if ( empty( $parameters['vendor_id'] ) ) {

            return comman_message_response ( __('Vendor id is missing'), 400 );
        }
    
        $data = plantAppValidationToken($request);
		$userid = null;
		if ($data['status']) {
			$userid = $data['user_id'];
        }
        
        if(isPTDokanActive() == true)
        {
            $products = dokan()->product->all([
                'author' => $parameters['vendor_id']
            ])->posts;
        
            if (count($products)) {
                foreach ($products as $product) {
                    $masterarray[] =  plantapp_get_product_details_helper($product->ID , $userid);
                }
            }
        }
        return comman_custom_response ( $masterarray );
    }

    public function plantapp_get_method($request) {

        $parameters = $request->get_params();
    
        if (!isset($parameters['country_code']) && empty($parameters['country_code']))
        {
            return comman_message_response ( __('Country code is Required') , 400 );
        }
    
        if (!isset($parameters['state_code']) || $parameters['state_code'] === "") {
            $code = strtoupper($parameters['country_code']);
        } else {
            $code = strtoupper($parameters['country_code']) . ':' . strtoupper($parameters['state_code']);
        }
    
        $postcode = '';
        if (!empty($parameters['postcode'])) {
            $postcode = substr($parameters['postcode'], 0, 4) . '*';
        }
    
        $delivery_zones = collect(WC_Shipping_Zones::get_zones());
    
        $new_shipping_methods = collect([]);
    
        $default_zone = new WC_Shipping_Zone(0);
    
        $default_zone_shipping_methods = collect($default_zone->get_shipping_methods());
    
        $default_shiping_method = $default_zone_shipping_methods->where('enabled', 'yes');
        $default_shiping_methods = $default_shiping_method->unique('id')->map(function ($ship_method) {
            unset($ship_method->instance_form_fields);
            return $ship_method;
        });
    
        if (count($delivery_zones)) {
    
            foreach ($delivery_zones as $delivery_zone) {
    
                $zone_locations = collect($delivery_zone['zone_locations']);
                $all_shipping_methods = collect($delivery_zone['shipping_methods']);
                $shipping_methods = $all_shipping_methods->where('enabled', 'yes');
    
                $free_shipping = get_default_shipping_method($default_shiping_methods);
    
                $zone_type = get_zone_type($zone_locations);
    
                $exit = false;
    
                if ($zone_type !== "") {
    
                    switch ($zone_type) {
                        case "state_postcode":
                            $code_count = $zone_locations->where('code', $code)->count();
    
                            if ($code_count > 0) {
    
                                $codes = plantapp_check_postcode($zone_locations,$parameters,$postcode);
    
                                if ($codes > 0 ) {
                                    foreach ($shipping_methods as $method) {
                                        $new_shipping_methods->push($method);
                                    }
                                    $exit = true;
                                }
                            }
                            break;
                        case "country_postcode":
                            $code_count = $zone_locations->where('code', strtoupper($parameters['country_code']))->count();
    
                            if ($code_count > 0) {
                                $codes = plantapp_check_postcode($zone_locations,$parameters,$postcode);
    
                                if ($codes > 0) {
                                    foreach ($shipping_methods as $method) {
                                        $new_shipping_methods->push($method);
                                    }
                                    $exit = true;
                                }
                            }
                            break;
                        case "country_state":
                            $code_count = $zone_locations->where('code', $code)->count();
                            if ($code_count > 0) {
                                foreach ($shipping_methods as $method) {
                                    $new_shipping_methods->push($method);
                                }
                                $exit = true;
                            }
                            break;
                        case "country":
                            $code_count = $zone_locations->where('code', strtoupper($parameters['country_code']))->count();
                            if ($code_count > 0) {
                                foreach ($shipping_methods as $method) {
                                    $new_shipping_methods->push($method);
                                }
                                $exit = true;
                            }
                            break;
                        default:
                            $new_shipping_methods->push($free_shipping);
                    }
    
                    if ($exit)
                        break;
    
                }
            }
        }
    
        if(count($new_shipping_methods) == 0){
            $new_shipping_methods = $new_shipping_methods->merge($free_shipping);
        }
        $new_shipping_methods = $new_shipping_methods->unique('id')->map(function ($ship_method) {
            unset($ship_method->instance_form_fields);
            return $ship_method;
        })->filter()->values()->toArray();
    
        $response = new WP_REST_Response([
            'message' => 'Methods list.',
            'methods' => $new_shipping_methods
        ]);

        return comman_custom_response ( $response );
    
    }
    
    public function plantapp_get_admin_dashboard($request)
    {
        $data = plantAppValidationToken($request);

		if (!$data['status']) {
			return comman_custom_response($data,401);
        }
        
        $role = $data['role'];

        if ( $role != 'administrator'){
            return comman_message_response('Sorry, you are not allowed to access this.',401);
        }

        global $woocommerce;
        $parameters = $request->get_params();

        $masterarray = [];
        $dashboard = [];
        $commmet_args = [
            'paged' => 1,
            'number' => 5,
            'comment_status' => 'approve'
        ];

        $comment_data = get_comments($commmet_args);
        $dashboard['new_comment'] = $comment_data;       

        $woocommerce = new Client(
            get_home_url(),     // Your store URL
            $parameters['ck'],  // Your consumer key
            $parameters['cs'],  // Your consumer secret
            [
                'wp_api' => true, // Enable the WP REST API integration
                'version' => 'wc/v3', // WooCommerce WP REST API version
                'query_string_auth' => true
            ]
        );
        
        try {
            // Array of response results.
            $results = $woocommerce->get('');
        }catch (HttpClientException $e) {
            return comman_message_response($e->getMessage(), $e->getCode()); // Error message.
        }

        $new_order = $woocommerce->get('orders');
        $dashboard['new_order'] = $new_order;

        // sales report.
        $sale_query = [
            'date_min' => $parameters['date_min'], 
            'date_max' => $parameters['date_max']
        ];
        
        $sale_report = $woocommerce->get('reports/sales', $sale_query);
        $dashboard['sale_report'] = $sale_report;
        
        // list of top sellers report.
        $top_sale_query = [
            'period' => isset($parameters['period']) ? $parameters['period'] : 'week'
        ];

        $top_date_min = isset($parameters['top_date_min']) && $parameters['top_date_min'] != null ? isset($parameters['top_date_min']) : null;
        $top_date_max = isset($parameters['top_date_max']) && $parameters['top_date_max'] != null ? isset($parameters['top_date_max']) : null;

        if( $top_date_max != null && $top_date_min != null )
        {
            $top_sale_query['date_min'] = $top_date_min;
            $top_sale_query['date_max'] = $top_date_max;
        }

        $top_sale_report = $woocommerce->get('reports/sales', $top_sale_query);
        $dashboard['top_sale_report'] = $top_sale_report;

        // customers totals report.
        $customer_total = $woocommerce->get('reports/customers/totals');
        $dashboard['customer_total'] = $customer_total;

        // orders totals report.
        $order_total = $woocommerce->get('reports/orders/totals');
        $dashboard['order_total'] = $order_total;

        // products totals report.
        $products_total = $woocommerce->get('reports/products/totals');
        $dashboard['products_total'] = $products_total;

        // reviews totals report.
        $reviews_total = $woocommerce->get('reports/reviews/totals');
        $dashboard['reviews_total'] = $reviews_total;
        
        return comman_custom_response($dashboard);
    }

    public function plantapp_get_vendor_dashboard($request)
    {
        $data = plantAppValidationToken($request);

		if (!$data['status']) {
			return comman_custom_response($data,401);
        }
        
        $role = $data['role'];

        if ( $role != 'seller'){
            return comman_message_response('Sorry, you are not allowed to access this.',401);
        }

        $parameters = $request->get_params();

        $dashboard = [];

        $authorization = $request->get_header('Authorization');
        
        $order_list = wp_remote_get( get_home_url() . "/wp-json/dokan/v1/orders" , array(
            'headers' => array(
                'Authorization' => $authorization,
            )
        ));

		// $dashboard['order'] = json_decode($order_list['body']);
        $dashboard['order'] = json_decode(wp_remote_retrieve_body($order_list));
        $product_summary = wp_remote_get( get_home_url() . "/wp-json/dokan/v1/products/summary" , array(
            'headers' => array(
                'Authorization' => $authorization,
            )
        ));

		// $dashboard['product_summary'] = json_decode($product_summary['body']);
        $dashboard['product_summary'] = json_decode(wp_remote_retrieve_body($product_summary));

        $order_summary = wp_remote_get( get_home_url() . "/wp-json/dokan/v1/orders/summary" , array(
            'headers' => array(
                'Authorization' => $authorization,
            )
        ));
        
        // $dashboard['order_summary'] = json_decode($order_summary['body']);
        $dashboard['order_summary'] = json_decode(wp_remote_retrieve_body($order_summary));

        return comman_custom_response($dashboard);
    }

    public function plantapp_get_custom_dashboard_slider( $request )
    {
        global $post;
        global $wpdb;
        $parameters    = $request->get_params();
        $custom_dashboard_option = get_option( 'plantapp_customdashboard_options');
        $masterarray = [];

        $data = plantAppValidationToken($request);
		$userid = null;
		if ($data['status']) {
			$userid = $data['user_id'];
		}
        $slider_id = (!empty($parameters['slider_id']) && isset($parameters['slider_id'])) ? $parameters['slider_id'] : 0;
        if( !empty($custom_dashboard_option['slider']) && count($custom_dashboard_option['slider']) > 0 )
        {
            $slider_data = [];
            $slider = $custom_dashboard_option['slider'][$slider_id];
            // foreach( $custom_dashboard_option['slider'] as $slider ){
                $orderby = orderByArgument($slider['type']);
                $args = [
                    'post_type' 		=> 'product',
                    'post_status' 		=> 'publish',
                    'posts_per_page' 	=> (!empty($parameters['posts_per_page']) && isset($parameters['posts_per_page'])) ? $parameters['posts_per_page'] : 10,
                    'paged' 			=> 1,
                    'orderby'           => $orderby,
                    'order'             => $slider['order'],
                ];
                if($slider['type'] == 'discount')
                {
                    $discount_oparator = get_discounttype_oparator($slider['discount_type']);
                    $args['post__in'] = wc_get_product_ids_on_sale();
                    $args['meta_query'] = array(
                        array(
                            'key' => 'plantapp_product_discount',
                            'value' => $slider['discount'],
                            'type' => 'DECIMAL',
                            'compare' => $discount_oparator
                        )
                    );
                }

                if($slider['type'] == 'featured')
                {
                    $args['tax_query']  = array(
                        array
                        (
                            'taxonomy' => 'product_visibility',
                            'field'    => 'name',
                            'terms'    => 'featured'
                        )
                    );
                }

                if($slider['type'] == 'highest_rating')
                {
                    $args['meta_key'] = '_wc_average_rating';
                }

                $product_data = new WP_Query( $args );
                $sdata = [];
                if($product_data->have_posts()) {
                    while($product_data->have_posts()) {
                        $product_data->the_post();                        
                        $sdata[] = plantapp_get_product_details_helper( get_the_ID() ,$userid );
                    }
                }
                $args = [];
                $sliderdata = [
                    'title' => $slider['title'],
                    'view_all' =>  (bool) $slider['view_all'],
                    'category' => $slider['category'],
                    'type' => $slider['type'],
                    'discount_type' => $slider['discount_type'],
                    'orderby' => $slider['order'],
                    'data' =>  $sdata
                ];
                $slider_data[] = $sliderdata;
            // }
            $masterarray = $slider_data;
        }

        return comman_custom_response($masterarray);
    }
}