<?php
$plantapp_option = get_option('plantapp_global_options');
$exclude_outstock = ( !empty($plantapp_option) && $plantapp_option['exclude_outstock'] != null ) ? $plantapp_option['exclude_outstock'] : null;
$enable_custom_dashboard = ( !empty($plantapp_option) && $plantapp_option['enable_custom_dashboard'] != null ) ? $plantapp_option['enable_custom_dashboard'] : null;
$payment_method = ( !empty($store_option) && $store_option['payment_method'] != null ) ? $store_option['payment_method'] : null; 
$payment_option = getPlantPaymentOptionList()->toArray();

?>
<div class="card p-0">
    <div class="card-header">
        <?php echo esc_html__('Global', 'plant-app-api') ?>
    </div>
    <div class="card-body">
        <form name="plantapp-global-options" id="plantapp-global-options">
            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="enable_custom_dashboard">Enable Custom Dashboard</label>
                <div class="col-sm-6">
                    <input type="checkbox" class="form-control" id="enable_custom_dashboard" name="enable_custom_dashboard" value="true" <?php echo isset($enable_custom_dashboard) && $enable_custom_dashboard == true ? 'checked' : null ;  ?>> <span class="small"><b>Enable this for custom dashboard</b></span>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="exclude_outstock">Exclude Outstock Plant/Accessories</label>
                <div class="col-sm-6">
                    <input type="checkbox" class="form-control" id="exclude_outstock" name="exclude_outstock" value="true" <?php echo isset($exclude_outstock) && $exclude_outstock == true ? 'checked' : null ;  ?>> <span class="small"><b>Enable this for exclude outstock product</b></span>
                </div>
            </div>

            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="payment_method">Select Payment Method</label>
                <div class="col-sm-6">
                    <select class="form-control ms-multiple-checkboxes" id="payment_method" data-live-search="true" name="payment_method" x-placement="Select Language">
                        <?php
                            foreach ($payment_option as $option) {
                                echo '<option value="' . $option['value'] . '" ' . ($option['value'] === $payment_method ? 'selected' : '') . '>' . $option['text'] . '</option>';
                            }
                        ?>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <hr class="mb-3">
                <button type="button" class="btn btn-info mt-2" id="plantapp-global-options-setting">
                    <?php echo esc_html__('Submit', 'plant-app-api') ?>
                </button>
            </div>
        </form>
    </div>
</div>