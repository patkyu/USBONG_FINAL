
<div class="row mr-lg-0" id="plantapp-admin-option-accordion">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <span class="h5"><?php echo esc_html__('PlantApp Plugin', 'plant-app-api') ?></span>
                <small class="text-muted ml-2"><?php echo esc_html__('v ' . PLANTAPP_API_VERSION, 'plant-app-api') ?></small>
            </div>
            <div class="card-body p-0 mt-2">
                <ul class="nav nav-pills nav-tabs nav-fill" id="plantapp-accordion-config" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="plantapp-accordion-global" data-toggle="tab" href="#tab-global"
                           role="tab" aria-controls="tab-global" aria-selected="true">
                            <?php echo esc_html__('Global ', 'plant-app-api') ?>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="plantapp-accordion-advertisement" data-toggle="tab" href="#tab-advertisement" role="tab"
                           aria-controls="tab-advertisement" aria-selected="false">
                            <?php echo esc_html__('Advertisement Images', 'plant-app-api') ?>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="plantapp-accordion-social-link" data-toggle="tab" href="#tab-social-link" role="tab"
                           aria-controls="tab-social-link" aria-selected="false">
                            <?php echo esc_html__('Social Links', 'plant-app-api') ?>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="plantapp-accordion-notification" data-toggle="tab" href="#tab-notification" role="tab"
                           aria-controls="tab-notification" aria-selected="false">
                            <?php echo esc_html__('Notification', 'plant-app-api') ?>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="plantapp-accordion-custom-dashboard" data-toggle="tab" href="#tab-custom-dashboard" role="tab"
                           aria-controls="tab-custom-dashboard" aria-selected="false">
                            <?php echo esc_html__('Custom Dashboard', 'plant-app-api') ?>
                        </a>
                    </li>
                </ul>
                <div class="tab-content" id="plantapp-accordion-config-panel">
                    <div class="tab-pane fade show active" id="tab-global" role="tabpanel"
                        aria-labelledby="plantapp-accordion-global">
                        <?php include PLANTAPP_API_DIR . 'resources/views/plant_admin_global.php'; ?>
                    </div>
                    <div class="tab-pane fade" id="tab-advertisement" role="tabpanel" aria-labelledby="plantapp-accordion-advertisement">
                        <?php include PLANTAPP_API_DIR . 'resources/views/plant_advertisement.php'; ?>
                    </div>
                    <div class="tab-pane fade" id="tab-social-link" role="tabpanel" aria-labelledby="plantapp-accordion-social-link">
                        <?php include PLANTAPP_API_DIR . 'resources/views/plant_social_link.php'; ?>
                    </div>
                    <div class="tab-pane fade" id="tab-notification" role="tabpanel" aria-labelledby="plantapp-accordion-notification">
                        <?php include PLANTAPP_API_DIR . 'resources/views/plant_notification.php'; ?>
                    </div>
                    <div class="tab-pane fade" id="tab-custom-dashboard" role="tabpanel" aria-labelledby="plantapp-accordion-custom-dashboard">
                        <?php include PLANTAPP_API_DIR . 'resources/views/plant_custom_dashboard.php'; ?>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
