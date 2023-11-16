<?php

add_action('wp_ajax_post_plantapp_admin_data', 'postPlantAppAdminData');

/**************************************************************************************************************
 * Post Method Are Here
 */

function postPlantAppAdminData()
{
    $status = false;
    $fields = [];
    if (isset($_POST['action'])
        && isset($_POST['_ajax_nonce'])
        && wp_verify_nonce($_POST['_ajax_nonce'], 'get_plantapp_admin_settings')
        && 'post_plantapp_admin_data' === $_POST['action']) {

        $fields = isset($_POST['fields']) ? $_POST['fields'] : [];

        switch ($_POST['type']) {
            case 'global' : 
                $status = savePlantAppConfigData($fields ,'plantapp_global_options');
                break;
            case 'advertisement' : 
                    $field = arrangePlantData( $fields );
                    $status = savePlantAppConfigData($field ,'plantapp_advertisement_options');
                    break;
            case 'notification' : 
                    $status = savePlantAppConfigData($fields , 'plantapp_notification_options');
                    break;
            case 'social_link':
                $status = savePlantAppConfigData($fields , 'plantapp_app_options');
                break;
            case 'custom_dashboard' :
                $field = arrangePlantDashboardData( $fields );
                $status = savePlantAppConfigData($field ,'plantapp_customdashboard_options');
                break;
        }

    }
    wp_send_json(['status' => $status, 'data' => []]);
}

function arrangePlantDashboardData($data)
{
    $result = [];
    
    if (!empty($data['title']) && count($data['title']) > 0) {
        foreach ($data['title'] as $index => $title) {
            if (!empty($title)) {
                if (empty($result['slider'])) {
                    $result['slider'] = [];
                }
                $result['slider'][] = [
                    'title'     => $title, //isset($data['title']) && isset($data['title'][$index]) ? $data['title'][$index] : '',
                    'type'      => isset($data['type']) && isset($data['type'][$index]) ? $data['type'][$index] : '',
                    'category'  => !empty($data['category']) && !empty($data['category'][$index]) ? $data['category'][$index] : [],
                    'order'   => isset($data['order']) && isset($data['order'][$index]) ? $data['order'][$index] : '',
                    'discount'   => isset($data['discount']) && isset($data['discount'][$index]) ? $data['discount'][$index] : '',
                    'discount_type' => isset($data['discount_type']) && isset($data['discount_type'][$index]) ? $data['discount_type'][$index] : '',
                    'view_all'  => isset($data['view_all']) && isset($data['view_all'][$index]) ? $data['view_all'][$index] : '',
                ];
            }
        }
    }
    return $result;
}

function arrangePlantData($data)
{
    $result = [];

    if (!empty($data['banner_slider']) && count($data['banner_slider']) > 0) {
        foreach ($data['banner_slider'] as $index => $banner) {
            if (!empty($banner)) {
                if (empty($result['banner'])) {
                    $result['banner'] = [];
                }
                $result['banner'][] = [
                    'title' => isset($data['title']) && isset($data['title'][$index]) ? $data['title'][$index] : '',
                    'url' => isset($data['url']) && isset($data['url'][$index]) ? $data['url'][$index] : '',
                    'banner_slider' => isset($data['banner_slider']) && isset($data['banner_slider'][$index]) ? $data['banner_slider'][$index] : ''
                ];
            }
        }
    }

    if (!empty($data['slider']) && count($data['slider']) > 0) {
        foreach ($data['slider'] as $index => $banner) {
            if (!empty($banner)) {
                if (empty($result['slider'])) {
                    $result['slider'] = [];
                }
                $result['slider'][] = [
                    'title' => isset($data['title']) && isset($data['title'][$index]) ? $data['title'][$index] : '',
                    'start_date' => isset($data['start_date']) && isset($data['start_date'][$index]) ? $data['start_date'][$index] : '',
                    'end_date' => isset($data['end_date']) && isset($data['end_date'][$index]) ? $data['end_date'][$index] : '',
                    'slider' => isset($data['slider']) && isset($data['slider'][$index]) ? $data['slider'][$index] : ''
                ];
            }
        }
    }
    return $result;
}

function savePlantAppConfigData($data , $options)
{
    $status = false;
    $old_options = get_option($options);
    if ($data !== $old_options) {
        // update new settings
        $status = update_option($options, $data);
    } else if ($data === $old_options) {
        // for same data
        $status = true;
    }
    return $status;
}

function getPlantPaymentOptionList()
{
    $payment_option = [
        [
            'value' => 'native',
            'text' => esc_html__('Native')
        ],
        [
            'value' => 'webview',
            'text' => esc_html__('WebView')
        ]
    ];

    return collect($payment_option);
}

function getPlantAppTypeList()
{
    $type = [
        [
            'value' => 'recent',
            'text' => esc_html__('Recent')
        ],
        [
            'value' => 'featured',
            'text' => esc_html__('Featured')
        ],
        [
            'value' => 'highest_rating',
            'text' => esc_html__('Highest Rating')
        ],
        [
            'value' => 'discount',
            'text' => esc_html__('Discount')
        ]
    ];
    return collect($type);
}


function getPlantAppOrderByList()
{
    $orderby = [
        [
            'value' => 'desc',
            'text' => esc_html__('Descending')
        ],
        [
            'value' => 'asc',
            'text' => esc_html__('Ascending')
        ]
    ];

    return collect($orderby);
}

function getPlantAppAllProductCategory()
{
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
    );

    $categories = new WP_Term_Query($args);
    $all_categories = $categories->terms;

    return collect($all_categories)->map(function ($res, $key) {
        return [
            'value' => $res->term_id,
            'text' => $res->name
        ];
    });
}

function getPlantAppDiscountTypeList()
{
    $discount_type = [
        [
            'value' => '',
            'text' => esc_html__('None')
        ],
        [
            'value' => 'flat',
            'text' => esc_html__('Flat')
        ],
        [
            'value' => 'upto',
            'text' => esc_html__('Upto')
        ],
        [
            'value' => 'above',
            'text' => esc_html__('Above')
        ]
    ];
    return collect($discount_type);
}