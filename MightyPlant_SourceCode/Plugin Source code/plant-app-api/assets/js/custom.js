(function ($) {
    'use strict';
    $(document).ready(() => {
        /*********************
         * Home Setting Save
         * */
        $(document).on('click', '#plantapp-admin-setting', function () {

            let _this = $(this);
            let $inputs = $('form#plantapp-admin-panel :input');
            let dashboardPostData = getFormData($inputs);

            postAjax(_this, 'post_plantapp_admin_data', 'social_link', dashboardPostData, (success, response) => {
                if (response.status && response.status === true) {
                    Swal.fire("Social Links Data Saved Successfully", " ", "success",{
                        buttons: false,
                        timer: 1000,
                    });
                } else {
                    Swal.fire("Fail To Save", "Refresh your page and try again", "error",{
                        buttons: false,
                        timer: 1000,
                    });
                }
            });
        });

        $(document).on('click', '#plantapp-notification-options-setting', function () {

            let _this = $(this);
            let $inputs = $('form#plantapp-notification-options :input');
            let notificationPostData = getFormData($inputs);

            postAjax(_this, 'post_plantapp_admin_data', 'notification' , notificationPostData, (success, response) => {
                if (response.status && response.status === true) {
                    Swal.fire("Notification Data Saved Successfully", " ", "success",{
                        buttons: false,
                        timer: 1000,
                    });
                } else {
                    Swal.fire("Fail To Save", "Refresh your page and try again", "error",{
                        buttons: false,
                        timer: 1000,
                    });
                }
            });
        });

        $(document).on('click', '#plantapp-global-options-setting', function () {

            let _this = $(this);
            let $inputs = $('form#plantapp-global-options :input');
            let globalPostData = getFormData($inputs);

            postAjax(_this, 'post_plantapp_admin_data', 'global' , globalPostData, (success, response) => {
                if (response.status && response.status === true) {
                    Swal.fire("Global Data Saved Successfully", " ", "success",{
                        buttons: false,
                        timer: 1000,
                    });
                } else {
                    Swal.fire("Fail To Save", "Refresh your page and try again", "error",{
                        buttons: false,
                        timer: 1000,
                    });
                }
            });
        });
        
        $(document).find('.plantapp-multiple-checkboxes').selectpicker();

        $(document).on('click', '#plantapp-advertisement-options-setting', function () {
        
            let _this = $(this);
            let $inputs = $('form#plantapp-advertisement-options :input');
            let globalPostData = getFormData($inputs);

            postAjax(_this, 'post_plantapp_admin_data', 'advertisement' , globalPostData, (success, response) => {
                if (response.status && response.status === true) {
                    Swal.fire("Advertisement images Data Saved Successfully", " ", "success",{
                        buttons: false,
                        timer: 1000,
                    });
                } else {
                    Swal.fire("Fail To Save", "Refresh your page and try again", "error",{
                        buttons: false,
                        timer: 1000,
                    });
                }
            });
        });

        $(document).on('click', '#plantapp-custom-dashboard-options-setting', function () {
        
            let _this = $(this);
            let $inputs = $('form#plantapp-custom-dashboard-options :input');
            let globalPostData = getFormData($inputs);

            postAjax(_this, 'post_plantapp_admin_data', 'custom_dashboard' , globalPostData, (success, response) => {
                if (response.status && response.status === true) {
                    Swal.fire("Custom Dashboard Data Saved Successfully", " ", "success",{
                        buttons: false,
                        timer: 1000,
                    });
                } else {
                    Swal.fire("Fail To Save", "Refresh your page and try again", "error",{
                        buttons: false,
                        timer: 1000,
                    });
                }
            });
        });
        /****************
         * Add Clone
         */
        $(document).on('click', '.plantapp-clone-add-more', function () {
            $(document).find('.plantapp-multiple-checkboxes').selectpicker('destroy')
            let cloneMaster = $(this).parent().find('.plantapp-clone-master');
            if (cloneMaster.length > 0) {
                let cloneItems = cloneMaster.find('.plantapp-clone-item:first');
                if (cloneItems.length > 0) {
                    let newClone = cloneItems.clone();
                    let clone = resetFields(newClone);
                    if ("true" === cloneMaster.attr('data-accordion')) {
                        clone = resetAccordionValue(cloneMaster, clone);
                    }
                    cloneMaster.append(clone);
                    cloneMaster.find('.plantapp-clone-item:last .plantapp-accordion-header').trigger('click');
                    $(document).find('.plantapp-multiple-checkboxes').selectpicker();
                } else {
                    Swal.fire("No Item Found", "Refresh your page and try again.", "error");
                }
            }
        });

        $(document).on('change', 'select.plantapp_type', function () {
            let type = $(this).val();
            let current_row = $(this).attr('plantapp_type_row');

            if(type == 'discount')
            {
                $('.discount[discount_row="' + current_row + '"]').attr('readonly',false);
                $('.discount_type[discount_type_row="' + current_row + '"]').prop('disabled',false);
                $('.discount_type[discount_type_row="' + current_row + '"]').selectpicker('refresh');
            } else {
                $('.discount[discount_row="' + current_row + '"]').attr('readonly',true);
                $('.discount[discount_row="' + current_row + '"]').val('');
                $('.discount_type[discount_type_row="' + current_row + '"]').val('none');
                $('.discount_type[discount_type_row="' + current_row + '"]').prop('disabled',true);
                $('.discount_type[discount_type_row="' + current_row + '"]').selectpicker('refresh');
            }
        })
        
        /******************
         * Remove Clone
         */
        $(document).on('click', '.plantapp-clone-remove', function () {
            $(this).closest('.plantapp-clone-item').remove();
        })

        $(document).on('click', '.plantapp-upload-img', function (e) {

            e.preventDefault();

            let button = $(this),
                custom_uploader = wp.media({
                    title: 'Insert image',
                    library: {
                        type: 'image'
                    },
                    button: {
                        text: 'Use this image'
                    },
                    multiple: false
                }).on('select', function () {
                    let attachment = custom_uploader.state().get('selection').first().toJSON();
                    button.html('<img class="form-control img slide-image-preview" src="' + attachment.url + '">').removeClass('btn btn-outline-secondary').next().val(attachment.id).next().show();
                }).open();

        });

        // on remove button click
        $(document).on('click', '.plantapp-upload-img-rmv', function (e) {
            e.preventDefault();
            let button = $(this);
            button.hide().prev().val('').prev().html('Upload image').addClass('btn btn-outline-secondary');
        });

    });

    function getFormData($inputs) {
        let values = {};
        $inputs.each(function () {
            // console.log( this.type );
            if (this.name.includes('[]')) {
                let key = String(this.name).replace('[]', '');
                if(this.type === "checkbox"){
                    // console.log(this,$(this).is(':checked'));
                    if (!(key in values)) {
                        values[key] = [];
                    }
                    if($(this).is(':checked')){
                        values[key].push($(this).val());
                    }else{
                        values[key].push(null);
                    }
                }else{
                    if (!(key in values)) {
                        values[key] = [];
                    }
                    values[key].push($(this).val());
                }
            } else {
                if( this.type === "checkbox" ){
                    // console.log(this,$(this).is(':checked'));
                    if($(this).is(':checked')){
                        values[this.name] = $(this).val();
                    }else{
                        values[this.name] = null;
                    }
                }else {
                    values[this.name] = $(this).val();
                }
            }
        });
        return values;
    }

    /***************************
     * Post Ajax With Callback
     * @param _this
     * @param action
     * @param type
     * @param postData
     * @param callback
     */
    function postAjax(_this, action, type, postData, callback) {
        $.ajax({
            url: plantapp_localize.ajaxurl,
            type: "post",
            data: {
                action: action,
                _ajax_nonce: plantapp_localize.nonce,
                fields: postData,
                type: type
            },
            beforeSend: function () {
                _this.html(
                    '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 48 48"><circle cx="24" cy="4" r="4" fill="#fff"/><circle cx="12.19" cy="7.86" r="3.7" fill="#fffbf2"/><circle cx="5.02" cy="17.68" r="3.4" fill="#fef7e4"/><circle cx="5.02" cy="30.32" r="3.1" fill="#fef3d7"/><circle cx="12.19" cy="40.14" r="2.8" fill="#feefc9"/><circle cx="24" cy="44" r="2.5" fill="#feebbc"/><circle cx="35.81" cy="40.14" r="2.2" fill="#fde7af"/><circle cx="42.98" cy="30.32" r="1.9" fill="#fde3a1"/><circle cx="42.98" cy="17.68" r="1.6" fill="#fddf94"/><circle cx="35.81" cy="7.86" r="1.3" fill="#fcdb86"/></svg><span>Saving Data..</span>'
                );
            },
            success: function (response) {
                _this.html("Submit");
                if (typeof callback == "function") {
                    callback(true, response);
                }
            },
            error: function () {
                _this.html("Submit");
                if (typeof callback == "function") {
                    callback(false, null);
                }
            }
        });
    }

    /******************************
     *Reset Clone Fields
     * @param cloneHtml
     * @returns {*} html
     */
    function resetFields(cloneHtml) {
        cloneHtml.find("input").val("");
        cloneHtml.find('input[type="checkbox"]').val(true);
        cloneHtml.find(':selected').removeAttr('selected');
        // cloneHtml.find(':checked').removeAttr('checked');
        cloneHtml.find('img').attr('src', '');
        cloneHtml.find(".plantapp-upload-img-rmv").hide().prev().val('').prev().html('Upload image').addClass('btn btn-outline-secondary');
        return cloneHtml;
    }

    /******************************
     * Set Accordion On Clone
     * @param cloneMaster
     * @param cloneHtml
     * @returns {*} html
     */
    function resetAccordionValue(cloneMaster, cloneHtml) {
        let id = cloneMaster.attr('id');
        let lastCount = parseInt(cloneMaster.find('.plantapp-clone-item:last .plantapp-accordion-header').attr('id').replace(id+'-',''));
        let currentCloneCount = lastCount+1;
        cloneHtml.find('.plantapp-accordion-header').attr('id', id + '-' + currentCloneCount);
        cloneHtml.find('.plantapp-accordion-header').attr('data-target', '#' + id + '-body-' + currentCloneCount);
        cloneHtml.find('.plantapp-accordion-header').attr('aria-controls', id + '-body-' + currentCloneCount);
        cloneHtml.find('.plantapp-accordion-header').attr('aria-expanded', false);
        cloneHtml.find('.plantapp-accordion-header').addClass('collapsed');
        cloneHtml.find('.plantapp-clone-header').text(cloneHtml.find('.plantapp-clone-header').attr('data-title')+' '+currentCloneCount)
        cloneHtml.find('.plantapp-accordion-body .plantapp_type').attr('plantapp_type_row',currentCloneCount).val('recent');
        cloneHtml.find('.plantapp-accordion-body .discount').attr('discount_row',currentCloneCount).attr('readonly',true);
        cloneHtml.find('.plantapp-accordion-body .discount_type').attr('discount_type_row',currentCloneCount).val('');
        cloneHtml.find('.plantapp-accordion-body .discount_type').attr('discount_type_row',currentCloneCount).prop('disabled',true);
        cloneHtml.find('.plantapp-accordion-body').attr('id', id + '-body-' + currentCloneCount);
        cloneHtml.find('.plantapp-accordion-body').attr('aria-labelledby', id + '-' + currentCloneCount);
        cloneHtml.find('.plantapp-accordion-body').removeClass('show');
        return cloneHtml;
    }
})(jQuery);