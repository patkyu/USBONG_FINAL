<?php

namespace Includes\Controllers\Api;
use WP_REST_Response;
use WP_REST_Server;
use WP_Query;
use WP_Post;
use Includes\baseClasses\PlantBase;

class PlantSliderController extends PlantBase {

    public $module = 'slider';

    public $nameSpace;

    function __construct() {

        $this->nameSpace = PLANTAPP_API_NAMESPACE;

        add_action( 'rest_api_init', function () {

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-slider', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_slider' ],
                'permission_callback' => '__return_true'
            ));

            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-blog', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'plantapp_get_blog' ],
                'permission_callback' => '__return_true'
            ));

         });

    }

    public  function plantapp_get_slider($request)
    {
        
        
    
        global $app_opt_name;
        $plantapp_option = get_option('plantapp_app_options');
        
        $array = array();
        $master = array();
    
        
    
        if (isset($plantapp_option['opt-slides']) && !empty($plantapp_option['opt-slides']))
        {
            foreach ($plantapp_option['opt-slides'] as $slide)
            {
                
                $array['image'] = $slide['image'];
                $array['thumb'] = $slide['thumb'];
                
                $array['url'] = $slide['url'];
    
                if (!empty($slide['image']))
                {
                    array_push($master, $array);
                }
    
            }
    
            
            
        }
    
        $response = new WP_REST_Response($master);
        $response->set_status(200);
    
        return $response;
    
    }

    public function plantapp_get_blog($request)
    {
       
       
        $masterarray = array();
        $array = array();
    
        $parameters = $request->get_params();
    
        $page = 1;
    
        if(isset($parameters['page']))
        {
            $page = $parameters['page'];
        }
    
        $args['post_type'] = 'post';
        $args['post_status'] = 'publish';
        $args['posts_per_page'] = 10;
        $args['paged'] = $page;
        
        $wp_query = new \WP_Query($args);
    
        $num_pages = 1;
        $num_pages = $wp_query->max_num_pages;  
    
        $out = '';
    
        global $post;
        if($wp_query->have_posts()) 
        {   
            while ( $wp_query->have_posts() ) 
            {
                    $wp_query->the_post();
                    $full_image = wp_get_attachment_image_src( get_post_thumbnail_id( $wp_query->ID  ), "full" );
                $array['num_pages'] = $num_pages;
                if($full_image[0])
                {
                    $array['image'] = $full_image[0];    
                }
                else
                {
                    $array['image'] = '';       
                }
                $array['image'] = $full_image[0];
                $array['title'] = get_the_title();
                $array['description'] = esc_html(get_the_content());
                $array['publish_date'] = get_the_date();
    
                array_push($masterarray, $array);
    
                $array = array();
    
            }
        }
    
         $response = new WP_REST_Response($masterarray);
    
            $response->set_status(200);
            return $response;
            
    }


}

