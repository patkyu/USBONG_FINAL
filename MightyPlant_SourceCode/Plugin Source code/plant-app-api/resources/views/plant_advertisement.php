<?php
$store_option = get_option('plantapp_advertisement_options');
?>
<div class="card p-0">
    <div class="card-header">
        <?php echo esc_html__('Advertisement Images', 'plant-app-api') ?>
    </div>
    <div class="card-body">
        <form name="plantapp-advertisement-options" id="plantapp-advertisement-options"enctype="multipart/form-data">
            <div class="row">
                <div class="col-lg-2">
                    <?php echo esc_html__('Advertisement Images', 'plant-app-api') ?>
                </div>
                <div class="col-lg-10">
                    <div id="advertisement-banner-slide" class="plantapp-clone-master" data-accordion="true">
                    <?php
                        if (isset($store_option['banner']) && count($store_option['banner']) > 0) {
                            foreach ($store_option['banner'] as $i1 => $d1) {
                                ?>
                                <div class="card plantapp-clone-item">
                                    <div class="card-header plantapp-accordion-header collapsed"
                                         id="advertisement-banner-slide-<?php echo($i1 + 1); ?>"
                                         data-toggle="collapse"
                                         data-target="#advertisement-banner-slide-body-<?php echo($i1 + 1); ?>"
                                         aria-expanded="false"
                                         aria-controls="advertisement-banner-slide-body-<?php echo($i1 + 1); ?>">
                                        <span class="m-0 h6 text-center cursor-pointer plantapp-clone-header"
                                              data-title="Banner">
                                            <?php echo esc_html__('Banner', 'plant-app-api') . ' ' . ($i1 + 1); ?>
                                        </span>
                                        <button type="button"
                                                class="btn btn-outline-danger plantapp-clone-remove float-right mt-0">
                                            <i class="fa fa-times"></i>
                                        </button>
                                    </div>
                                    <div id="advertisement-banner-slide-body-<?php echo($i1 + 1); ?>"
                                        class="collapse plantapp-accordion-body"
                                        aria-labelledby="advertisement-banner-slide-<?php echo($i1 + 1); ?>"
                                        data-parent="#advertisement-banner-slide">
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <label>Title</label>
                                                    <input class="form-control" type="text" placeholder="Title" value="<?php isset($d1['title']) ? esc_html_e($d1['title']) : null ?>" name="title[]">
                                                </div>
                                                <div class="col-md-12 mt-3">
                                                    <label>URL</label>
                                                    <input class="form-control" type="text" placeholder="URL" value="<?php isset( $d1['url'] ) ? esc_html_e($d1['url']) : null ?>" name="url[]">
                                                </div>
                                                <div class="col-md-3 mt-3 d-grid">
                                                    <label>Image</label>
                                                    <?php
                                                    if (isset($d1['banner_slider']) && $attach = wp_get_attachment_image_src($d1['banner_slider'])) {
                                                        echo '<div class="plantapp-upload-img cursor-pointer"><img class="form-control img slide-image-preview" src="' . $attach[0] . '" /></div>
                                            <input type="hidden" name="banner_slider[]" value="' . $d1['banner_slider'] . '">
                                            <div class="plantapp-upload-img-rmv btn btn-outline-danger cursor-pointer mt-2" ><i class="fa fa-times"></i></div>';

                                                    } else {

                                                        echo '<div class="plantapp-upload-img btn btn-outline-secondary cursor-pointer">Upload image</div>
                                            <input type="hidden" name="banner_slider[]">
                                            <div class="plantapp-upload-img-rmv btn btn-outline-danger cursor-pointer mt-2" style="display:none"><i class="fa fa-times"></i></div>';
                                                    }
                                                    ?>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <?php
                            }
                        } else {
                            ?>
                            <div class="card plantapp-clone-item">
                                <div class="card-header plantapp-accordion-header collapsed" id="advertisement-banner-slide-1"
                                        data-toggle="collapse"
                                        data-target="#advertisement-banner-slide-body-1" aria-expanded="false"
                                        aria-controls="advertisement-banner-slide-body-1">
                                    <span class="m-0 h6 text-center cursor-pointer plantapp-clone-header" data-title="Banner">
                                        <?php echo esc_html__('Banner 1', 'plant-app-api'); ?>
                                    </span>
                                    <button type="button" class="btn btn-outline-danger plantapp-clone-remove float-right mt-0">
                                        <i class="fa fa-times"></i>
                                    </button>
                                </div>
                                <div id="advertisement-banner-slide-body-1" class="collapse plantapp-accordion-body" aria-labelledby="advertisement-banner-slide-1" data-parent="#advertisement-banner-slide">
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-12">
                                                <label>Title</label>
                                                <input class="form-control" type="text" placeholder="Title" value="" name="title[]">
                                            </div>
                                            <div class="col-md-12 mt-3">
                                                <label>URL</label>
                                                <input class="form-control" type="text" placeholder="URL" value="" name="url[]">
                                            </div>
                                            <div class="col-md-3 mt-3 d-grid">
                                                <label>Image</label>
                                                <div class="plantapp-upload-img btn btn-outline-secondary cursor-pointer">
                                                    Upload image
                                                </div>
                                                <input type="hidden" name="banner_slider[]">
                                                <div class="plantapp-upload-img-rmv btn btn-outline-danger cursor-pointer mt-2" style="display:none"><i class="fa fa-times"></i></div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        <?php } ?>
                    </div>
                    <button type="button" class="btn btn-outline-primary float-right plantapp-clone-add-more mt-2">
                        <?php echo esc_html__('Add New', 'plant-app-api') ?>
                    </button>
                </div>
                <div class="col-md-12">
                    <div class="form-group">
                        <hr class="mb-3">
                        <button type="button" class="btn btn-info mt-2" id="plantapp-advertisement-options-setting">
                            <?php echo esc_html__('Submit', 'plant-app-api') ?>
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>