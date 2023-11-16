<?php
$store_option = get_option('plantapp_notification_options');

?>
<div class="card p-0">
    <div class="card-header">
        <?php echo esc_html__('Notification', 'plant-app-api') ?>
    </div>
    <div class="card-body">
        <form name="plantapp-notification-options" id="plantapp-notification-options">
            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="enable">Enable Notification </label>
                <div class="col-sm-6">
                    <label class="switch">
                        <input name="notification_switch" type="checkbox" id="enable" value="true" <?php echo isset($store_option['notification_switch']) && $store_option['notification_switch'] === 'true' ? 'checked' : ''; ?>>
                        <span class="slider round"></span>
                    </label>
                    <small class="help-block">
                        <ul class="list-unstyled">
                            <li>Choose this option for Enable/Disable Push Notification</b></li>
                        </ul>
                    </small>
                </div>
            </div>

            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="one_app_id"><?php echo esc_html__('One Signal App ID', 'plant-app-api') ?></label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="one_app_id" name="one_app_id" value="<?php echo isset($store_option['one_app_id']) ? $store_option['one_app_id'] : null ; ?>">
                    <small class="help-block">
                        <ul class="list-unstyled">
                            <li>Enter Your <b>One Signal App ID</b></li>
                            <li> Get Your App ID <a href="<?= esc_url('https://www.onesignal.com/') ?>" target="_blank">Click Here</a></li>
                        </ul>
                    </small>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="one_rest_api_key"><?php echo esc_html__('One Signal REST API KEY', 'plant-app-api') ?></label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="one_rest_api_key" name="one_rest_api_key" value="<?php echo isset($store_option['one_rest_api_key']) ? $store_option['one_rest_api_key'] : null ; ?>">
                    <small class="help-block">
                        <ul class="list-unstyled">
                            <li>Enter Your <b>One Signal REST API KEY</b></li>
                            <li> Get Your REST API KEY <a href="<?= esc_url('https://www.onesignal.com/') ?>" target="_blank">Click Here</a></li>
                        </ul>
                    </small>
                </div>
            </div>

            <div class="form-group">
                <hr class="mb-3">
                <button type="button" class="btn btn-info mt-2" id="plantapp-notification-options-setting">
                    <?php echo esc_html__('Submit', 'plant-app-api') ?>
                </button>
            </div>
        </form>
    </div>
</div>