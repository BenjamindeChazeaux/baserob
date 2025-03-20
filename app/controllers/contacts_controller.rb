class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      #ContactMailer.deliver_now(@contact)
      redirect_to welcome_index_path, notice: "Votre demande de contact a bien été prise en compte"
    else
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :phone, :message)
  end
end
