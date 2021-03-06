class Businesses::RegistrationsController < Devise::RegistrationsController
  # GET /resource/sign_up
  layout :change_layout
  def new
    @plan_id = params[:plan]
    @plan = Plan.find_by_id(@plan_id)
    resource = build_resource({})
    respond_with resource

  end

  # POST /resource
  def create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end


  def change_layout
    if params[:action] == 'edit' || params[:action] == 'update'
      'business'
    else
      'home'
    end
  end
end
