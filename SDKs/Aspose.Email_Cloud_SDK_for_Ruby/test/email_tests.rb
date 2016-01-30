require "minitest/autorun"
require "minitest/unit"

require_relative '../lib/aspose_email_cloud'

class EmailTests < Minitest::Test
	include MiniTest::Assertions
	include AsposeEmailCloud
	include AsposeStorageCloud
	
	def setup
        #Get App key and App SID from https://cloud.aspose.com
        AsposeApp.app_key_and_sid("", "")
		@email_api = EmailApi.new
	end

	def teardown
	end

	def upload_file(file_name)
        @storage_api = StorageApi.new
		response = @storage_api.put_create(file_name, File.open("data/" << file_name,"r") { |io| io.read } )
		assert(response, message="Failed to upload {file_name} file.")
	end

	def test_get_document
        file_name = "email_test.eml"
    	upload_file(file_name)

        response = @email_api.get_document(file_name)
	 	assert(response, message="Failed to get mail common info.")
	end

	def test_get_document_with_format
        file_name = "email_test.eml"
    	upload_file(file_name)

        response = @email_api.get_document_with_format(file_name, "msg")
	 	assert(response, message="Failed to get mail in specified format")
	end

    def test_put_create_new_email
        file_name = "email_test2.eml"
    	upload_file(file_name)

    	email_document = EmailDocument.new
    
    	email_body = EmailProperty.new
        email_to = EmailProperty.new
        email_from = EmailProperty.new
	    
        email_body.name = "Body"
        email_body.value = "This is body"
	    
        email_to.name = "To"
        email_to.value = "developer@aspose.com"
	    
        email_from.name = "From"
        email_from.value = "sales@aspose.com"
	    
        email_properties = EmailProperties.new
        email_properties.list = [email_body, email_to, email_from]
	    
        email_document.document_properties = email_properties
        email_document.format = "eml"

        response = @email_api.put_create_new_email(file_name, email_document)
     	assert(response, message="Failed to add new email.")
    end

	def test_get_email_attachment
        file_name = "email_test2.eml"
    	upload_file(file_name)
    	attach_name = "README.TXT"

        response = @email_api.get_email_attachment(file_name, attach_name)
	 	assert(response, message="Failed to get email attachment by name.")
	end

    def test_post_add_email_attachment
        file_name = "email_test.eml"
    	upload_file(file_name)
    	attach_name = "README.TXT"
    	upload_file(attach_name)

        response = @email_api.post_add_email_attachment(file_name, attach_name)
     	assert(response, message="Failed to add email attachment.")
    end

    def test_get_email_property
        file_name = "email_test.eml"
    	upload_file(file_name)

    	property_name = "Body"
        response = @email_api.get_email_property(property_name, file_name)
     	assert(response, message="Failed to read document property by name.")
    end

    def test_put_set_email_property
        file_name = "email_test.eml"
    	upload_file(file_name)
    	property_name = "Subject"
    	email_property = EmailProperty.new
    	email_property.name = "Subject"
    	email_property.value = "This is a new subject"

        response = @email_api.put_set_email_property(file_name, property_name, email_property)
     	assert(response, message="Failed to set document property.")
    end
    
end