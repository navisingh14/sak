require 'debugger'

When(/^I open saif home page$/) do
  visit ("https://localhost:3000")
  page.driver.browser.manage.window.maximize
end

When(/^I click on sign up$/) do
	page.find(:xpath, "//a[@id='registerbutton']").click
end

When(/^I fill basic detail:$/) do |table|
  sleep(2)
  i = 0
  @row=table.rows_hash
  @row_value=table.rows_hash.values
  size=@row_value.size
  while (i<size)
    page.all(:xpath,"//form[@id='sign-up-form']//input")[i].set"#{@row_value[i]}"
    clickonCreate()
    error_message(@error_msg)
    i += 1
  end
end

Then(/^I Hit the check box$/) do
  page.all(:xpath,"//form[@id='sign-up-form']//input")[5].click
end

When(/^I click on create button$/) do
  click_on('Create An Account')
end

Then(/^I should see some error msg "(.*?)"$/) do |arg1|
  @error_msg=arg1
end

Then(/^I should be signed in$/) do
	sleep(10)
	page.find(:xpath,"//span[@id='user-name-top']").should have_content("Hello")
end

Then(/^I logout from account$/) do
  page.find(:xpath,"//a[@id='logoutbutton']").click
end

Then(/^I should see login page$/) do
  sleep(4)
  page.should have_xpath(".//div[@class='ember-view login-bar']")
end

def clickonCreate()
   click_on('Create An Account') 
end

def error_message(msg)
  sleep(1)
  page.find(:xpath, "//div[@id='alertBox']").should have_content("#{msg}")
end


When(/^I give firstname "(.*?)"$/) do |fname|
  sleep(1)
  page.all(:xpath,"//form[@id='sign-up-form']//input")[0].set"#{fname}"
end

When(/^I give lastname "(.*?)"$/) do |lname|
  sleep(1)
  page.all(:xpath,"//form[@id='sign-up-form']//input")[1].set"#{lname}"
end

When(/^I give user_id "(.*?)"$/) do |email_id|
  sleep(1)
  page.all(:xpath,"//form[@id='sign-up-form']//input")[2].set"#{email_id}"
end

When(/^I give password "(.*?)"$/) do |pass|
  sleep(1)
  page.all(:xpath,"//form[@id='sign-up-form']//input")[3].set"#{pass}"
end

When(/^I give confirm_password "(.*?)"$/) do |confirm_password|
  sleep(1)
  page.all(:xpath,"//form[@id='sign-up-form']//input")[4].set"#{confirm_password}"
end
