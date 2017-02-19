Feature: Login
	Scenario: login_cases
		When I open saif home page
		And I click on login

		And I click on login button
		Then I should see some error msg "It seems you have missed some fields.Please make sure all the above fields are filled and correct."

		And I fill user_id "nayan.jain@navyuginfo.com"
		And I click on login button
		Then I should see some error msg "It seems you have missed some fields.Please make sure all the above fields are filled and correct."
		
		And I fill password "new life"
		And I click on login button
		Then I should see some error msg "It seems you have missed some fields.Please make sure all the above fields are filled and correct."

		And I fill user_id "nayan.jain@navyuginfo.com"
		And I fill password "love life"
		And I click on login button
		Then I should see some error msg "Password invalid"

		
		And I fill user_id "nayan.jain1001@navyuginfo.com"
		And I fill password "new life"
		And I click on login button
		Then I should see some error msg "Sorry this User does not exist."		

		And I fill user_id "pankaj.biswas@gmail.com"
		And I fill password "new life123"
		And I click on login button
		Then I should be signed in
		And I logout from account
		Then I should see login page	
		

	Scenario: forget password
		When I open saif home page
		And I click on login
		And I click on forget password option
		Then I should see some error msg "Please make sure you provide the correct email address"

		And I fill user_id "nayan.jain1001@navyuginfo.com"
		And I click on forget password option
		Then I should see some error msg "User does not exist."

		And I fill user_id "pankaj.biswas@gmail.com"
		And I click on forget password option
		Then I should see some message "sending password reset instructions..."

	Scenario: change password
		When I open saif home page
		And I click on login
		And I fill user_id "pankaj.biswas@gmail.com" 
		And I fill password "new life123"
		And I click on login button
		And I click on change password option
		And I change my password "new life 123"
		Then I should see some error msg "Password change successful. Please login again with new password."