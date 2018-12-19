class ContactsController < ApplicationController
  def show
    @projects = resource.projects.by_last_updated.page(params[:page]).per(3)
  end

  def index
    @contact = Contact.new
    @contacts = Contact.by_name
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to contacts_path, notice: t(:contact_created)
    else
      @contacts = Contact.by_name
      render "contacts/index"
    end
  end

  def edit
    resource
  end

  def update
    if resource.update_attributes(contact_params)
      redirect_to contacts_path, notice: t(:contact_updated)
    else
      render :edit
    end
  end

  private

  def resource
    @contact ||= Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :position, :department, :phone, :email, :client_id)
  end
end
