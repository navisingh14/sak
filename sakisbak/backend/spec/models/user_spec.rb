require 'spec_helper'

describe User do
	#Tests for fields
	it {should respond_to :email}
	it {should respond_to :encrypted_password}
	it {should respond_to :reset_password_token}
	it {should respond_to :reset_password_sent_at}
	it {should respond_to :remember_created_at}
	it {should respond_to :sign_in_count}
	it {should respond_to :current_sign_in_at}
	it {should respond_to :last_sign_in_at}
	it {should respond_to :current_sign_in_ip}
	it {should respond_to :last_sign_in_ip}
	it {should respond_to :firstname}
	it {should respond_to :lastname}
	it {should respond_to :created_at}
	it {should respond_to :updated_at}
	it {should respond_to :confirmation_token}
	it {should respond_to :confirmed_at}
	it {should respond_to :confirmation_sent_at}
	it {should respond_to :unconfirmed_email}

	#Tests for validations
	#it {should ensure_length_of(:email).is_at_most(255)}
	#it {should ensure_length_of(:encrypted_password).is_at_most(255)}
	#it {should ensure_length_of(:reset_password_token).is_at_most(255)}
	#it {should ensure_length_of(:current_sign_in_ip).is_at_most(255)}
	#it {should ensure_length_of(:last_sign_in_ip).is_at_most(255)}
	#it {should ensure_length_of(:firstname).is_at_most(255)}
	#it {should ensure_length_of(:lastname).is_at_most(255)}
	#it {should ensure_length_of(:confirmation_token).is_at_most(255)}
	#it {should ensure_length_of(:unconfirmed_email).is_at_most(255)}

	#its(:firstname){ should be_present }

end