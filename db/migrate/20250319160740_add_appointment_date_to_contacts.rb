class AddAppointmentDateToContacts < ActiveRecord::Migration[7.1]
  def change
    add_column :contacts, :appointment_date, :datetime
  end
end
