#encoding: utf-8

require 'rspec'
require 'rubygems'
require 'selenium-webdriver'
require 'yaml'

require_relative "../tools/register_dialog"
require_relative "../tools/sign_in_github_dialog"
require_relative "../action/register_page"
require_relative "../action/new_app_page"
require_relative "../data/base_env"
require_relative "../lib/config_param"
require_relative "../lib/webdriver_helper"

describe "Register paid CCM account" do 
	include RegisterDialog
    include SignInGithubDialog
	include BaseEnv
	include ConfigParam
	include WebdriverHelper

	before(:all) do 
		init
		@order_it = WebdriverHelper::Counter.new
        @name_screenshot = "TC_006_IT_"
        @data_xpath = YAML::load(File.read(File.expand_path("../../data/data_xpath.yml",__FILE__)))
        @data_url = YAML::load(File.read(File.expand_path("../../data/data_url.yml",__FILE__)))
        @data_user = YAML::load(File.read(File.expand_path("../../data/data_user.yml",__FILE__)))
        @data_str = YAML::load(File.read(File.expand_path("../../data/data_str.yml",__FILE__)))
	end

	after(:all) do 
		private_resource = RestClient::Resource.new 'http://loc.build.phonegap.com/api/v1/apps' , {:user => @data_user[$lang][:ccm_acnt_001][:id] , :password => @data_user[$lang][:ccm_acnt_001][:password] , :timeout => 30}
        response = private_resource.get :accept => :json
        json =  JSON.parse(response)
        json['apps'].each do |i|
            url = @base_url + i['link']
            private_resource = RestClient::Resource.new url , {:user => @data_user[$lang][:ccm_acnt_001][:id] , :password => @data_user[$lang][:ccm_acnt_001][:password] , :timeout => 30}
            response = private_resource.delete 
            puts response.to_str
        end

        private_resource_2 = RestClient::Resource.new 'http://loc.build.phonegap.com/api/v1/apps' , {:user => @data_user[$lang][:ccm_acnt_002][:id] , :password => @data_user[$lang][:ccm_acnt_002][:password] , :timeout => 30}
        response_2 = private_resource_2.get :accept => :json
        json_2 =  JSON.parse(response_2)
        json_2['apps'].each do |i|
            url = @base_url + i['link']
            private_resource_2 = RestClient::Resource.new url , {:user => @data_user[$lang][:ccm_acnt_002][:id] , :password => @data_user[$lang][:ccm_acnt_002][:password] , :timeout => 30}
            response_2 = private_resource_2.delete 
            puts response_2.to_str
        end

        private_resource_3 = RestClient::Resource.new 'http://loc.build.phonegap.com/api/v1/apps' , {:user => @data_user[$lang][:ccm_acnt_003][:id] , :password => @data_user[$lang][:ccm_acnt_003][:password] , :timeout => 30}
        response_3 = private_resource_3.get :accept => :json
        json_3 =  JSON.parse(response_3)
        json_3['apps'].each do |i|
            url = @base_url + i['link']
            private_resource_3 = RestClient::Resource.new url , {:user => @data_user[$lang][:ccm_acnt_003][:id] , :password => @data_user[$lang][:ccm_acnt_003][:password] , :timeout => 30}
            response_3 = private_resource_3.delete 
            puts response_3.to_str
        end


	end

	before(:each) do
		@driver = browser
		@driver.manage.window.maximize
		@register_page = RegisterPage.new @driver
		@base_url = base_url

		@driver.get path_format_locale("/plans/paid") 
		sleep 5
        @driver.switch_to.frame(0)
        puts "+ after driver.switch_to.frame(0)..."
	end

	after(:each) do
		@name_screenshot += @order_it.inc.to_s

        if example.exception != nil
            # Failure only code goes here
            take_screenshot_with_name @name_screenshot
        end
        
		@driver.quit
	end

	context "Register Paid CCM account and create 2 private apps, with different account" do 
		it "with the first paid ccm account: dil40562+stagedeannual@adobetest.com" do 
			sleep 5
			adobe_id_frame_enter_email(@data_user[$lang][:ccm_acnt_001][:id])
	        adobe_id_frame_enter_password(@data_user[$lang][:ccm_acnt_001][:password])
	        adobe_id_frame_sign_in_btn.click
	        sleep 5
	        @driver.switch_to.default_content
	        wait_for_element_present(:xpath, @data_xpath[:register_page][:ccm_29_99_btn]) 
	        ccm_29_99_btn.click
	        wait_for_page_load("https://creative.adobe.com/plans")
	        @driver.get @base_url
	        sleep 40
	        # try to create 2 private apps 
	        
	        new_app_page.new_private_app_with_repo
	        sleep 40

	        new_app_page.new_private_app_with_repo
	        sleep 40

	        app_count_after = new_app_page.get_existing_app_num
            first_app_id_after = new_app_page.get_first_app_id
            puts "+ app_count_after: #{app_count_after}"
            puts "+ first_app_id_after: #{first_app_id_after}"

            app_count_after.should_not eql 0
		end

		it "with the second paid ccm account: dil40562+teamfra1128@adobetest.com" do 
			sleep 5
			adobe_id_frame_enter_email(@data_user[$lang][:ccm_acnt_002][:id])
	        adobe_id_frame_enter_password(@data_user[$lang][:ccm_acnt_002][:password])
	        adobe_id_frame_sign_in_btn.click
	        sleep 5
	        @driver.switch_to.default_content
	        puts "+ switch_to.default_content..."
	        wait_for_element_present(:xpath, @data_xpath[:register_page][:ccm_29_99_btn]) 
	        ccm_29_99_btn.click
	        wait_for_page_load("https://creative.adobe.com/plans")
	        @driver.get @base_url
	        sleep 40
	        # try to create 2 private apps 
	        
	        new_app_page.new_private_app_with_repo
	        sleep 40

	        new_app_page.new_private_app_with_repo
	        sleep 40

	        app_count_after = new_app_page.get_existing_app_num
            first_app_id_after = new_app_page.get_first_app_id
            puts "+ app_count_after: #{app_count_after}"
            puts "+ first_app_id_after: #{first_app_id_after}"

            app_count_after.should_not eql 0
		end

		it "with the third paid ccm account: dil40562+teamfrenuonly1128@adobetest.com" do 
			sleep 5
			adobe_id_frame_enter_email(@data_user[$lang][:ccm_acnt_003][:id])
	        adobe_id_frame_enter_password(@data_user[$lang][:ccm_acnt_003][:password])
	        adobe_id_frame_sign_in_btn.click
	        sleep 5
	        @driver.switch_to.default_content
	        puts "+ switch_to.default_content..."
	        wait_for_element_present(:xpath, @data_xpath[:register_page][:ccm_29_99_btn]) 
	        ccm_29_99_btn.click
	        wait_for_page_load("https://creative.adobe.com/plans")
	        @driver.get @base_url

	        sleep 40
	        # try to create 2 private apps 
	        
	        new_app_page.new_private_app_with_repo
	        sleep 40

	        new_app_page.new_private_app_with_repo
	        sleep 40

	        app_count_after = new_app_page.get_existing_app_num
            first_app_id_after = new_app_page.get_first_app_id
            puts "+ app_count_after: #{app_count_after}"
            puts "+ first_app_id_after: #{first_app_id_after}"

            app_count_after.should_not eql 0
		end
	end
end