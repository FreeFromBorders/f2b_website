RSpec.configure do |config|
	config.include FactoryGirl::Syntax::Methods
	config.inlcude Devise::TestHelpers, :type=> :controller
end