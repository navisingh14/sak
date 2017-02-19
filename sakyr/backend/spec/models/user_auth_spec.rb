require 'spec_helper'

describe UserAuth do
	#Tests for fields
	it {should respond_to :uid}
	it {should respond_to :provider}
	it {should respond_to :user_id}
	it {should respond_to :token}
	it {should respond_to :created_at}
	it {should respond_to :updated_at}

	#Tests for validations
	#it {should ensure_length_of(:uid).is_at_most(255)}
	#it {should ensure_length_of(:provider).is_at_most(255)}




end