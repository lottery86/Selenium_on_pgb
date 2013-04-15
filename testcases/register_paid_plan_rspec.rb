#encoding: utf-8

require 'rubygems'
require 'rspec'
require 'selenium-webdriver'
require 'yaml'

require_relative "../tools/register_dialog"
require_relative "../tools/sign_in_github_dialog"
require_relative "../action/register_page"
require_relative "../data/base_env"
require_relative "../lib/config_param"

describe "Register -> create an Adobe ID with provided email" do 
	include RegisterDialog
    include SignInGithubDialog
	include BaseEnv
	include ConfigParam

	before(:all) do 
		init
		@driver = browser
		@register_page = RegisterPage.new @driver
		# @base_url = base_url
        @data_xpath = YAML::load(File.read(File.expand_path("../../data/data_xpath.yml",__FILE__)))
        @data_url = YAML::load(File.read(File.expand_path("../../data/data_url.yml",__FILE__)))
        @data_user = YAML::load(File.read(File.expand_path("../../data/data_user.yml",__FILE__)))
        @data_str = YAML::load(File.read(File.expand_path("../../data/data_str.yml",__FILE__)))

        @driver.get path_format_locale("/plans/free-adobeid") 
        @driver.switch_to.frame(0)
        enter_email(@data_user[$lang][:adobe_id_free_001][:id])
    	enter_password(@data_user[$lang][:adobe_id_free_001][:password])
    	sign_in_btn.click
    end

    after(:all) do 
        @register_page.close_current_page
    end


end