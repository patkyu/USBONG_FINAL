<?php

namespace Includes\Controllers\Api;

use WP_REST_Response;
use WP_REST_Server;
use WP_Query;
use WP_Post;
use Includes\baseClasses\PlantBase;

class PlantBlogController extends PlantBase {

    public $module = 'blog';

    public $nameSpace;

    function __construct() {

        $this->nameSpace = PLANTAPP_API_NAMESPACE;;

        add_action( 'rest_api_init', function () {

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-blog-detail', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'get_blog_detail' ],
				'permission_callback' => '__return_true',
            ));
            
            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-blog-list', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'get_blog_list' ],
				'permission_callback' => '__return_true',
			));
        });

    }

    public function get_blog_list ($request) {

        $parameters = $request->get_params();

		$args = [
			'post_type' 		=> 'post',
			'post_status' 		=> 'publish',
			'posts_per_page' 	=> (!empty($parameters['posts_per_page']) && isset($parameters['posts_per_page'])) ? $parameters['posts_per_page'] : 5,
            'paged' 			=> (!empty($parameters['paged']) && isset($parameters['paged'])) ? $parameters['paged'] : 1,
            's' 				=> (isset($parameters['search']) && $parameters['search'] != '' ) ? $parameters['search'] : ''
			
        ];

        $masterarray = [];    
        $wp_query = new WP_Query( $args );

		if ($wp_query->have_posts()) {
			while ($wp_query->have_posts()) {
				$wp_query->the_post();
				array_push($masterarray, plantapp_get_blogpost_data($wp_query));
            }
            
			$dashborad['num_of_pages'] = $wp_query->max_num_pages;
			$dashborad['data'] = $masterarray;
		} else {
			$dashborad['num_of_pages'] = $wp_query->max_num_pages;
			$dashborad['data'] = $masterarray;

		}

        return comman_custom_response($dashborad);

    }

    public function get_blog_detail ($request) {

		global $post;
		global $wpdb;

		$parameters = $request->get_params();

        $post_id = (isset($parameters['post_id']) && $parameters['post_id'] != '' ) ? $parameters['post_id'] : null;

		$args['p'] = $post_id;
		$wp_query = new WP_Query( $args );
		$post_data_array = [];
		if ($wp_query->have_posts()) {
			while ($wp_query->have_posts())
			{
				$wp_query->the_post();
				array_push($post_data_array, plantapp_get_blogpost_data($wp_query));
			}
		}
		$post_data = $post_data_array['0'];
		
		return comman_custom_response($post_data);
	}
}