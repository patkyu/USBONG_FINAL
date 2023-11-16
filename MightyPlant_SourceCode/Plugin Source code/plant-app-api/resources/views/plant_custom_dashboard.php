<?php
$plantapp_option = get_option('plantapp_customdashboard_options');
$getPlantAppTypeList = getPlantAppTypeList()->toArray();
$getPlantAppOrderByList = getPlantAppOrderByList()->toArray();
$categories = getPlantAppAllProductCategory()->toArray();
$getPlantAppDiscountTypeList = getPlantAppDiscountTypeList()->toArray();
?>
<div class="card p-0">
    <div class="card-header">
        <?php echo esc_html__('Custom Dashboard', 'plant-app-api') ?>
    </div>
    <div class="card-body">
        <form name="plantapp-custom-dashboard-options" id="plantapp-custom-dashboard-options"enctype="multipart/form-data">
            <div class="row">
                <div class="col-lg-2">
                    <?php echo esc_html__('Custom Dashboard', 'plant-app-api') ?>
                </div>
                <div class="col-lg-10">
                    <div id="customdashboard-slide" class="plantapp-clone-master" data-accordion="true">
                    <?php
                        if (isset($plantapp_option['slider']) && count($plantapp_option['slider']) > 0) {
                            foreach ($plantapp_option['slider'] as $i1 => $d1) {

                                $readonly = ( isset($d1['type']) && $d1['type'] != 'discount') ? 'readonly' : '';
                                $disabled = ( isset($d1['type']) && $d1['type'] != 'discount') ? 'disabled' : '';
                                ?>
                                <div class="card plantapp-clone-item">
                                    <div class="card-header plantapp-accordion-header collapsed"
                                         id="customdashboard-slide-<?php echo($i1 + 1); ?>"
                                         data-toggle="collapse"
                                         data-target="#customdashboard-slide-body-<?php echo($i1 + 1); ?>"
                                         aria-expanded="false"
                                         aria-controls="customdashboard-slide-body-<?php echo($i1 + 1); ?>">
                                        <span class="m-0 h6 text-center cursor-pointer plantapp-clone-header" data-title="Section">
                                            <?php echo esc_html__('Section', 'plant-app-api') . ' ' . ($i1 + 1); ?>
                                        </span>
                                        <button type="button" class="btn btn-outline-danger plantapp-clone-remove float-right mt-0">
                                            <i class="fa fa-times"></i>
                                        </button>
                                    </div>
                                    <div id="customdashboard-slide-body-<?php echo($i1 + 1); ?>"
                                        class="collapse plantapp-accordion-body"
                                        aria-labelledby="customdashboard-slide-<?php echo($i1 + 1); ?>"
                                        data-parent="#customdashboard-slide">
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="form-group">
                                                        <label class="form-control-label">Title</label>
                                                        <input class="form-control" type="text" placeholder="Title" value="<?php isset($d1['title']) ? esc_html_e($d1['title']) : null ?>" name="title[]">
                                                    </div>
                                                </div>
                                                <div class="col-lg-6">
                                                    <div class="form-group">
                                                        <label class="form-control-label">Type</label>
                                                        <select class="form-control plantapp-multiple-checkboxes plantapp_type" plantapp_type_row="<?= $i1 + 1?>"
                                                                data-live-search="true" data-size="10" name="type[]"
                                                                x-placement="Select Type">
                                                            <?php
                                                            foreach ($getPlantAppTypeList as $type) {
                                                                echo '<option value="' . $type['value'] . '" ' . ($type['value'] === $d1['type'] ? 'selected' : '') . '>' . $type['text'] . '</option>';
                                                            }
                                                            ?>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="form-control-label">Discount <b>%</b></label>
                                                        <input class="form-control discount" discount_row="<?= $i1 + 1 ?>" type="number"  name="discount[]" value="<?php isset($d1['discount']) ? esc_html_e($d1['discount']) : null ?>" <?= $readonly ?> placeholder="Discount" min=0 max=100 step='any' >
                                                    </div>
                                                </div>
                                                
                                                <div class="col-lg-6">
                                                    <div class="form-group">
                                                        <label class="form-control-label">Discount Type</label>
                                                        <select class="form-control plantapp-multiple-checkboxes discount_type" discount_type_row="<?= $i1 + 1?>" <?= $disabled ?>
                                                                data-live-search="true" data-size="10" name="discount_type[]"
                                                                x-placement="Select Discount Type">
                                                            <?php
                                                            foreach ($getPlantAppDiscountTypeList as $discount_type) {
                                                                echo '<option value="' . $discount_type['value'] . '" ' . ($discount_type['value'] === $d1['discount_type'] ? 'selected' : '') . '>' . $discount_type['text'] . '</option>';
                                                            }
                                                            ?>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="col-lg-6">
                                                    <div class="form-group">
                                                        <label class="form-control-label">Category</label>
                                                        <select class="form-control plantapp-multiple-checkboxes"
                                                                data-live-search="true" data-actions-box="true" data-size="10" name="category[]" multiple
                                                                x-placement="Select Category">
                                                            <?php
                                                            foreach ($categories as $category) {
                                                                echo '<option value="' . $category['value'] . '" ' . (in_array($category['value'], $d1['category']) ? 'selected' : '') . '>' . $category['text'] . '</option>';
                                                            }
                                                            ?>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="col-lg-6">
                                                    <div class="form-group">
                                                        <label class="form-control-label">Order By</label>
                                                        <select class="form-control plantapp-multiple-checkboxes"
                                                                data-live-search="true" data-size="10" name="order[]"
                                                                x-placement="Select Order">
                                                            <?php
                                                            foreach ($getPlantAppOrderByList as $order) {
                                                                echo '<option value="' . $order['value'] . '" ' . ($order['value'] === $d1['order'] ? 'selected' : '') . '>' . $order['text'] . '</option>';
                                                            }
                                                            ?>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="col-lg-6">
                                                    <div class="form-group">
                                                        <label class="form-control-label">View All</label>
                                                        <label class="switch d-block">
                                                            <input name="view_all[]" type="checkbox"
                                                                value="true" <?php echo $d1['view_all'] == 'true' ? 'checked' : ''; ?>>
                                                            <span class="slider round"></span>
                                                        </label>
                                                    </div>
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
                                <div class="card-header plantapp-accordion-header collapsed" id="customdashboard-slide-1"
                                        data-toggle="collapse"
                                        data-target="#customdashboard-slide-body-1" aria-expanded="false"
                                        aria-controls="customdashboard-slide-body-1">
                                    <span class="m-0 h6 text-center cursor-pointer plantapp-clone-header" data-title="Section">
                                        <?php echo esc_html__('Section 1', 'plant-app-api'); ?>
                                    </span>
                                    <button type="button" class="btn btn-outline-danger plantapp-clone-remove float-right mt-0">
                                        <i class="fa fa-times"></i>
                                    </button>
                                </div>
                                <div id="customdashboard-slide-body-1" class="collapse plantapp-accordion-body" aria-labelledby="customdashboard-slide-1" data-parent="#customdashboard-slide">
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="form-control-label">Title</label>
                                                    <input class="form-control" type="text" placeholder="Title" value="" name="title[]">
                                                </div>
                                            </div>
                                            <div class="col-lg-6">
                                                <div class="form-group">
                                                    <label class="form-control-label">Type</label>
                                                    <select class="form-control plantapp-multiple-checkboxes plantapp_type" plantapp_type_row="1"
                                                            data-live-search="true" data-size="10" name="type[]"
                                                            x-placement="Select Type">
                                                        <?php
                                                        foreach ($getPlantAppTypeList as $filter) {
                                                            echo '<option value="' . $filter['value'] . '" >' . $filter['text'] . '</option>';
                                                        }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-control-label">Discount <b>%</b></label>
                                                    <input class="form-control discount" name="discount[]" type="number" discount_row="1" placeholder="Discount" value="" min=0 step='any' readonly >
                                                </div>
                                            </div>

                                            <div class="col-lg-6">
                                                <div class="form-group">
                                                    <label class="form-control-label">Discount Type</label>
                                                    <select class="form-control plantapp-multiple-checkboxes discount_type" discount_type_row="1"
                                                            data-live-search="true" data-size="10" name="discount_type[]"
                                                            x-placement="Select Discount Type" disabled>
                                                        <?php
                                                        foreach ($getPlantAppDiscountTypeList as $discount_type) {
                                                            echo '<option value="' . $discount_type['value'] . '" >' . $discount_type['text'] . '</option>';
                                                        }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-lg-6">
                                                <div class="form-group">
                                                    <label class="form-control-label">Category</label>
                                                    <select class="form-control plantapp-multiple-checkboxes"
                                                            data-live-search="true" data-actions-box="true" data-size="10" name="category[]" multiple
                                                            x-placement="Select Category">
                                                        <?php
                                                        foreach ($categories as $category) {
                                                            echo '<option value="' . $category['value'] . '" >' . $category['text'] . '</option>';
                                                        }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-lg-6">
                                                <div class="form-group">
                                                    <label class="form-control-label">Order By</label>
                                                    <select class="form-control plantapp-multiple-checkboxes"
                                                            data-live-search="true" data-size="10" name="order[]"
                                                            x-placement="Select Order">
                                                        <?php
                                                        foreach ($getPlantAppOrderByList as $order) {
                                                            echo '<option value="' . $order['value'] . '" >' . $order['text'] . '</option>';
                                                        }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-lg-6">
                                                <div class="form-group">
                                                    <label class="form-control-label">View All</label>
                                                    <label class="switch d-block">
                                                        <input name="view_all[]" type="checkbox" value="true" checked>
                                                        <span class="slider round"></span>
                                                    </label>
                                                </div>
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
                        <button type="button" class="btn btn-info mt-2" id="plantapp-custom-dashboard-options-setting">
                            <?php echo esc_html__('Submit', 'plant-app-api') ?>
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>