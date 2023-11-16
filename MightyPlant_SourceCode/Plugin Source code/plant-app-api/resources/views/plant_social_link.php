<?php
$plantapp_option = get_option('plantapp_app_options');

?>
<div class="card p-0">
    <div class="card-header">
        <?php echo esc_html__('Social Links', 'plant-app-api') ?>
    </div>
    <div class="card-body">
        <form name="plantapp-admin-panel" id="plantapp-admin-panel">
            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="whatsapp"><?php echo esc_html__('WhatsApp', 'plant-app-api') ?></label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="whatsapp" name="whatsapp" value="<?php echo isset($plantapp_option['whatsapp']) ? $plantapp_option['whatsapp'] : null ; ?>">
                    <small class="help-block">
                        <ul class="list-unstyled">
                            <li><b>Please Enter Number With Country Code</b></li>
                            <li>For e.g. 919876543210</li>
                            <li>91 Is Country Code</li>
                        </ul>
                    </small>
                </div>
            </div>

            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="facebook"><?php echo esc_html__('Facebook', 'plant-app-api') ?></label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="facebook" name="facebook" value="<?php echo isset($plantapp_option['facebook']) ? $plantapp_option['facebook'] : null ; ?>">
                </div>
            </div>
            
            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="twitter"><?php echo esc_html__('Twitter', 'plant-app-api') ?></label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="twitter" name="twitter" value="<?php echo isset($plantapp_option['twitter']) ? $plantapp_option['twitter'] : null ; ?>">
                </div>
            </div>

            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="instagram"><?php echo esc_html__('Instagram', 'plant-app-api') ?></label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="instagram" name="instagram" value="<?php echo isset($plantapp_option['instagram']) ? $plantapp_option['instagram'] : null ; ?>">
                </div>
            </div>

            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="contact" name="contact"><?php echo esc_html__('Customer Care Number', 'plant-app-api') ?></label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="contact" name="contact" value="<?php echo isset($plantapp_option['contact']) ? $plantapp_option['contact'] : null ; ?>">
                </div>
            </div>

            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="website_url"><?php echo esc_html__('Website URL', 'plant-app-api') ?></label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="website_url" name="website_url" value="<?php echo isset($plantapp_option['website_url']) ? $plantapp_option['website_url'] : null ; ?>">
                </div>
            </div>

            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="refund_policy"><?php echo esc_html__('Refund Policy URL', 'plant-app-api') ?></label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="refund_policy" name="refund_policy" value="<?php echo isset($plantapp_option['refund_policy']) ? $plantapp_option['refund_policy'] : null ; ?>">
                </div>
            </div>

            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="shipping_policy"><?php echo esc_html__('Shipping Policy URL', 'plant-app-api') ?></label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="shipping_policy" name="shipping_policy" value="<?php echo isset($plantapp_option['shipping_policy']) ? $plantapp_option['shipping_policy'] : null ; ?>">
                </div>
            </div>

            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="privacy_policy"><?php echo esc_html__('Privacy Policy URL', 'plant-app-api') ?></label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="privacy_policy" name="privacy_policy" value="<?php echo isset($plantapp_option['privacy_policy']) ? $plantapp_option['privacy_policy'] : null ; ?>">
                </div>
            </div>

            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="term_condition"><?php echo esc_html__('Term & Condition URL', 'plant-app-api') ?></label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="term_condition" name="term_condition" value="<?php echo isset($plantapp_option['term_condition']) ? $plantapp_option['term_condition'] : null ; ?>">
                </div>
            </div>

            <div class="form-group row">
                <label class="col-sm-2 align-self-center mb-0" for="copyright_text"><?php echo esc_html__('Copyright Text', 'plant-app-api') ?></label>
                <div class="col-sm-6">
                    <textarea class="form-control" id="copyright_text" name="copyright_text"><?php echo isset($plantapp_option['copyright_text']) ? $plantapp_option['copyright_text'] : null ; ?></textarea>
                </div>
            </div>

            <div class="form-group">
                <hr class="mb-3">
                <button type="button" class="btn btn-info mt-2" id="plantapp-admin-setting">
                    <?php echo esc_html__('Submit', 'plant-app-api') ?>
                </button>
            </div>
        </form>
    </div>
</div>