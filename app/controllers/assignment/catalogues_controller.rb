class Assignment::CataloguesController < ApplicationController

  include Token::JsonWebTokenValidation
  include CurrentUser

  before_action :validate_json_web_token
  before_action :current_user

  ## to get current_user use @current_user instance variable

  def create
    ## to add user_id in permit used merged or intialize user_id for catalogue
    # catalogue = Catalogue.new(catalogue_params.merge(user_id: @current_user.id))
    catalogue = Catalogue.new(catalogue_params)
    catalogue.user_id = @current_user.id
    if catalogue.save
      render json: catalogue, status: :created
    else
      render json: catalogue.errors.full_messages.join(', '), status: :unprocessable_entity
    end
  end

  def index
    # scope :hide_catalogues, -> { where(hide_catalogues: true) }
    catalogues = Catalogue.where(user_id: @current_user.id)
    if params[:hidden_catalogues].present?
      catalogues = catalogues.where("hide_days >= ?", Time.now)
    else
      catalogues = catalogues.where("hide_days IS NULL OR hide_days <= ?", Time.now)
    end

     if params[:sort_by] == "asc"
      catalogues = catalogues.order("id ASC")
     else 
      catalogues = catalogues.order("id DESC")
     end

     page_details, catalogues = pagy(catalogues, items: params[:per_page], page: params[:page])
     render json: {
      data: catalogues,
      meta: {
        current_page_no: page_details.page, # gives record of users in current page
        total_page_no: page_details.pages, # Total count of pages
        next_page_no: page_details.next, # for next page no (or nil if there’s no next)
        total_count: page_details.count, # for total count of users
        previous_page: page_details.prev # for previous page
      }
    }, status: :ok
  end

  def hide_catalogues
    catalogues = Catalogue.where(id: params[:catalogue_ids], user_id: @current_user.id)
    if catalogues.blank?
      return render json: {errors: [message: "Selected catalogue not found"]}, status: :not_found
    end

    if params[:hide_days].blank? || !(params[:hide_days].positive?)
      return render json: {
        errors: [message: "Hide days must be present"]
      }, status: :unprocessable_entity
    end
     catalogues.update_all(hide_days: Time.now + params[:hide_days].days)
     render json: { message: "Selected catalogue is hidden till #{Time.now + params[:hide_days].days} "}
  end

  def unhide_catalogues
    catalogues = Catalogue.where(id: params[:catalogue_ids])
    if catalogues.blank?
     return render json: {errors: [message: "Selected catalogue not found"]}, status: :not_found
    end
    catalogues.update_all(hide_days: nil)
    render json: { message: "Selected catalogue is unhide"}
  end

  private

  def catalogue_params
    params.require(:catalogue).permit(:name, :description)
  end
end
