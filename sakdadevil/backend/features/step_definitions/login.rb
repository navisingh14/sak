require 'debugger'

When(/^I click on login$/) do
	page.find(:xpath, "//a[@id='loginbutton']").click
end

When(/^I fill user_id "(.*?)"$/) do |uname|
	sleep(2)
	@user_name=uname
	page.find(:xpath,"//form[@id='login-form']//input[@class='ember-view ember-text-field inputemailLogin floatLT']").set"#{@user_name}"
end

When(/^I fill password "(.*?)"$/) do |pass|
	sleep(2)
	@password=pass
	page.find(:xpath,"//form[@id='login-form']//input[@class='ember-view ember-text-field inputpasswordLogin floatLT']").set"#{@password}"
end

When(/^I click on login button$/) do
	page.find(:xpath, "//input[@id='login-modal-login-button']").click
end


When(/^I click on forget password option$/) do
  page.find(:xpath,"//a[@id='forgot-password-btn']").click
end

Then(/^I should see some message "(.*?)"$/) do |message|
  page.find(:xpath,"//form[@id='login-form']//div[@class='login-modal-loader floatLT']").should have_content(message)
end

When(/^I click on change password option$/) do
	sleep(3)
	page.find(:xpath,"//a[@id='change-password-button']").click
end

When(/^I change my password "(.*?)"$/) do |new_password|
	sleep(1)
	page.find(:xpath,"//input[@id='oldPasswordInput']").set"#{@password}"
	@password=new_password
	sleep(1)
	page.find(:xpath,"//input[@id='newPasswordInput']").set"#{@password}"
	sleep(1)
	page.find(:xpath,"//input[@id='confirmPasswordInput']").set"#{@password}"
	page.find(:xpath,"//input[@id='change-password-button']").click
end