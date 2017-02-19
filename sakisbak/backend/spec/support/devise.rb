module ControllerMacros
  # helper to login automatically before each test and logout after each test
  # this helper should be called in test file to achieve the same
  # @param
  def handle_session
    before(:each) do
      #@request.env["HTTP_ACCEPT"] = 'application/json'
      @user = User.new
      @user.firstname = "firstname"
      @user.lastname = "lastname"
      @user.email = "kapil.kumar@navyuginfo.com"

      @user.password='new life'
      @user.skip_confirmation!
      @user.save
      @user.confirm
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
      expect(subject.current_user).not_to eql(nil)
    end
    after(:each) do
      sign_out @user
    end
	end
end