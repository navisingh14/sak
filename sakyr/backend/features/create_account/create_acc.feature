Feature: Create account
	
	Scenario: create user account
		When I open saif home page
		And I click on sign up
		And I fill basic detail:
		| firstname		|	nayan95							|
		| lastname		|	jain							|
		| email			|	nayan.jain95@navyuginfo.com		|
		| pass			|	new life						|
		| confirm_pass	|	new life						|
		And I Hit the check box
		And I click on create button
		Then I should see some error msg "Please provide all details to sign up."
		Then I should be signed in
		And I logout from account
		Then I should see login page

	Scenario: creating user account_test_cases
		When I open saif home page
		And I click on sign up
		And I give firstname "nayan305"
		And I give lastname "jain"
		And I give user_id "nayan.jain@navyuginfo.com"
		And I give password "life"
		And I give confirm_password "life"
		And I Hit the check box
		And I click on create button
		Then I should see some error msg "Password should be atleast 8 characters."
		And I give password "new life"
		And I give confirm_password "new life"
		And I click on create button
		Then I should see some error msg "Sorry this email has already been taken. Please sign up with a different email."
		And I give user_id "nayan.jain305@navyuginfo.com"
		And I click on create button
		Then I should be signed in
		And I logout from account
		Then I should see login page
		


