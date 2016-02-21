class ContactController < ApplicationController
  # GET /contact-me
  def index
    @contact = Contact.new
  end

  # POST /contact-me
  def create
    @contact = Contact.create(contact_params)

    if @contact.persisted?
      ContactMailer.submit_contact(@contact).deliver_later
      redirect_to contact_path, notice: 'Your message has been sent to Eric Mulligan.'
    else
      flash.now[:alert] = @contact.errors.full_messages.join('<br />')
      render :index
    end
  end

  private

  def contact_params
    params.require(:contact).permit(
      :name,
      :email,
      :body
    )
  end
end
