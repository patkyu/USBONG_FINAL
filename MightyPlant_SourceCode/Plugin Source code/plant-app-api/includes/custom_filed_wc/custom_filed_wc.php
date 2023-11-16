<?php
add_filter('woocommerce_product_data_tabs', function($tabs) {
	$tabs['additional_info'] = [
		'label' => __('PlantApp Information', 'woocommerce'),
		'target' => 'additional_product_data',
		'priority' => 25
	];
	return $tabs;
});

add_action('woocommerce_product_data_panels', function() {
	?>
    <div id="additional_product_data" class="panel woocommerce_options_panel hidden">
        <?php
            global $woocommerce, $post;
            echo '<div class="options_group">';
        
            woocommerce_wp_select(array(
                'id' => 'plant_product_type', 
                'label' => __('Select Item Type', 'woocommerce'), 
                'placeholder' => '',
                'desc_tip'    => 'true',
                'description' => __( 'Select plant for add the plant and accessories for the add plant\'s accessories.', 'woocommerce' ),
                'options' => array(
                    '' => __('Select item', 'woocommerce'), 
                    'plant' => __('Plant', 'woocommerce'), 
                    'accessories' => __('Accessories', 'woocommerce'), 
                )
            ));

            woocommerce_wp_select(array(
                'id' => 'plantapp_plant_type', 
                'label' => __('Select Plant Type', 'woocommerce'), 
                'placeholder' => '',
                'desc_tip'    => 'true',
                'description' => __( 'Select plant\'s type', 'woocommerce' ),
                'options' => array(
                    '' => __('Select type', 'woocommerce'), 
                    'indoor' => __('Indoor', 'woocommerce'), 
                    'outdoor' => __('Outdoor', 'woocommerce'), 
                )
            ));
            
            woocommerce_wp_text_input(array(
                'id' => 'plantapp_temperature',
                'label' => __('Temprature °', 'woocommerce'),
                'placeholder' => '0-100 F / 0-100 C',
                'desc_tip' => 'true',
                'description' => __('Add temperature in the fahrenheit / celsius.', 'woocommerce'),
            ));

            woocommerce_wp_text_input(array(
                'id' => 'plantapp_light',
                'label' => __('Light', 'woocommerce'),
                'placeholder' => '',
                'desc_tip' => 'false',
                'description' => __('','woocommerce')
            ));

            woocommerce_wp_text_input(array(
                'id' => 'plantapp_water',
                'label' => __('Water', 'woocommerce'),
                'placeholder' => '',
                'desc_tip' => 'false',
                'description' => __('','woocommerce')
            ));

            woocommerce_wp_text_input(array(
                'id' => 'plantapp_fertile',
                'label' => __('Fertile', 'woocommerce'),
                'placeholder' => '',
                'desc_tip' => 'false',
                'description' => __('','woocommerce')
            ));

            woocommerce_wp_text_input(array(
                'id' => 'plantapp_life',
                'label' => __('Life', 'woocommerce'),
                'placeholder' => '',
                'desc_tip' => 'false',
                'description' => __('','woocommerce')
            ));

            echo '</div>';
        ?>
    </div>
<?php
});

add_action( 'woocommerce_process_product_meta', 'plant_add_custom_general_fields_save' );

function plant_add_custom_general_fields_save($post_id ){
	
    if ( defined( 'DOING_AUTOSAVE' ) && DOING_AUTOSAVE ) {
        return $post_id;
    }
    $post_type = get_post_type($post_id);
    if ( 'product' !== $post_type ) return $post_id;

    if (isset($_POST['plant_product_type'])) {
        update_post_meta( $post_id, 'plant_product_type', $_POST['plant_product_type'] );
    } else {
        delete_post_meta( $post_id, 'plant_product_type' );
    }

    if (isset($_POST['plantapp_plant_type'])) {
        update_post_meta( $post_id, 'plantapp_plant_type', $_POST['plantapp_plant_type'] );
    } else {
        delete_post_meta( $post_id, 'plantapp_plant_type' );
    }

    if (isset($_POST['plantapp_temperature'])) {
        update_post_meta( $post_id, 'plantapp_temperature', $_POST['plantapp_temperature'] );
    } else {
        delete_post_meta( $post_id, 'plantapp_temperature' );
    }
    if (isset($_POST['plantapp_light'])) {
        update_post_meta( $post_id, 'plantapp_light', $_POST['plantapp_light'] );
    } else {
        delete_post_meta( $post_id, 'plantapp_light' );
    }

    if (isset($_POST['plantapp_water'])) {
        update_post_meta( $post_id, 'plantapp_water', $_POST['plantapp_water'] );
    } else {
        delete_post_meta( $post_id, 'plantapp_water' );
    }

    if (isset($_POST['plantapp_fertile'])) {
        update_post_meta( $post_id, 'plantapp_fertile', $_POST['plantapp_fertile'] );
    } else {
        delete_post_meta( $post_id, 'plantapp_fertile' );
    }

    if (isset($_POST['plantapp_life'])) {
        update_post_meta( $post_id, 'plantapp_life', $_POST['plantapp_life'] );
    } else {
        delete_post_meta( $post_id, 'plantapp_life' );
    }

}

add_action( 'save_post_product', 'save_plantapp_product_discount' );
add_action( 'woocommerce_update_product', 'save_plantapp_product_discount', 10, 1 );
function save_plantapp_product_discount($post_id)
{
    $product = wc_get_product( $post_id );
    if($product->is_on_sale()){
        $discount = productDiscount($product->get_regular_price(), $product->get_sale_price(), 'percentage');
        // discount in percentage       
        update_post_meta( $post_id, 'plantapp_product_discount', round($discount) );
    } else {
        delete_post_meta( $post_id, 'plantapp_product_discount' );
    }
}
?>