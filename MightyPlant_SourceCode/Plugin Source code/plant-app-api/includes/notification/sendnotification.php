<?php

$plantapp_option = get_option('plantapp_notification_options');

if(isset($plantapp_option['notification_switch']))
{
    if($plantapp_option['notification_switch'] == true)
    {
        add_action('draft_to_publish', 'plantapp_product_publish' );
        add_action('woocommerce_new_order', 'plantapp_create_invoice_for_wc_order',  1, 1  );
        add_action('woocommerce_order_status_changed', 'plantapp_order_status_change_custom', 10, 3);
    }
}

$one_app_id = ( !empty($plantapp_option) && $plantapp_option['one_app_id'] != null ) ? $plantapp_option['one_app_id'] : null;
$one_rest_api_key = ( !empty($plantapp_option) && $plantapp_option['one_rest_api_key'] != null ) ? $plantapp_option['one_rest_api_key'] : null;

function plantapp_product_publish( $post )
{
    if ( $post->post_type == "product" ) {
        $productId = $post->ID;
        $product = wc_get_product( $productId );
        $array['name'] = $product->get_name();

        $headings = [
            "en" => 'New Product Added'
        ];
        $content = [
            "en" => $array['name']
        ];

        $plantapp_option = get_option('plantapp_notification_options',null);
        $one_app_id = ( isset($plantapp_option) && $plantapp_option['one_app_id'] != null ) ? $plantapp_option['one_app_id'] : null;
        $one_rest_api_key = ( isset($plantapp_option) && $plantapp_option['one_rest_api_key'] != null ) ? $plantapp_option['one_rest_api_key'] : null;
        
        $fields = [
            'app_id' => $one_app_id,
            'included_segments' => [
                'All'
            ],
            'data' => [
                'type' => 'product',
                'product_id' => $product->get_id(),
            ],
            'headings' => $headings,
            'contents' => $content
        ];
        sendonesignalnotification($fields, $one_rest_api_key);
    }
}

function plantapp_create_invoice_for_wc_order( $order_id )
{
    $order = new \WC_Order( $order_id );
    
    $order_id = $order->get_id();

    $user_id = $order->get_user_id();

    $player_id = get_user_meta($user_id, 'plantapp_player_id');

    $headings = [
        "en" => 'Order confirmed.'
    ];
    $content = [
        "en" => 'Your order has been confirmed!'
    ];

    $plantapp_option = get_option('plantapp_notification_options',null);
    $one_app_id = ( isset($plantapp_option) && $plantapp_option['one_app_id'] != null ) ? $plantapp_option['one_app_id'] : null;
    $one_rest_api_key = ( isset($plantapp_option) && $plantapp_option['one_rest_api_key'] != null ) ? $plantapp_option['one_rest_api_key'] : null;

    if( !empty($player_id) ){
        $fields = array(
            'app_id' => $one_app_id,
            'include_player_ids' => $player_id,
            'data' => array(
                'type' => 'order',
                'order_id' => $order_id,
            ),
            'headings' => $headings,
            'contents' => $content,
            'web_buttons' => []
        );
        sendonesignalnotification($fields, $one_rest_api_key);
    }
}

function plantapp_order_status_change_custom($order_id,$old_status,$new_status)
{
    $order = new \WC_Order( $order_id );
    
    $order_id  = $order->get_id();

    $user_id   = $order->get_user_id();

    $player_id = get_user_meta($user_id, 'plantapp_player_id');

    $order_status  = $order->get_status();

    $headings      = array(
        "en" => 'Order Status'
    );
    $content = array(
        "en" => 'Your order status has been updated.'
    );

    $plantapp_option = get_option('plantapp_notification_options',null);
    $one_app_id = ( isset($plantapp_option) && $plantapp_option['one_app_id'] != null ) ? $plantapp_option['one_app_id'] : null;
    $one_rest_api_key = ( isset($plantapp_option) && $plantapp_option['one_rest_api_key'] != null ) ? $plantapp_option['one_rest_api_key'] : null;

    if( !empty($player_id) ){
        $fields = array(
            'app_id' => $one_app_id,
            'include_player_ids' => $player_id,
            'data' => array(
                'type' => 'order',
                'order_id' => $order_id,
            ),
            'headings' => $headings,
            'contents' => $content
        );
        sendonesignalnotification($fields, $one_rest_api_key);
    }
}

function sendonesignalnotification($fields, $one_rest_api_key)
{
    $fields = json_encode($fields);

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, "https://onesignal.com/api/v1/notifications");
    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
        'Content-Type: application/json; charset=utf-8',
        'Authorization: Basic '.$one_rest_api_key
    ));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
    curl_setopt($ch, CURLOPT_HEADER, FALSE);
    curl_setopt($ch, CURLOPT_POST, TRUE);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);

    $response = curl_exec($ch);
    curl_close($ch);

    // print_r($response);die;
}
?>
