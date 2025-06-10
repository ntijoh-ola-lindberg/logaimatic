# test_gemini.rb
require 'gemini_craft'
require 'dotenv/load'

# Make sure your API key is correctly set in .env or hardcoded here for testing
GeminiCraft.configure do |config|
  config.model = 'gemini-1.5-flash'     # Default model
  config.timeout = 30                   # Request timeout in seconds
  config.max_retries = 3   

  config.api_key = ENV['GEMINI_API_KEY'] || "AIzaSyAwb93o2N876m4TdZD_MfMx44Y3jmk05cg" # Using ENV preferred, fallback to hardcoded
  puts "Configured API Key (first 5 chars): #{config.api_key[0, 5]}..." if config.api_key
end

puts "Initializing Gemini::Client..."
client = GeminiCraft::Client.new()
puts "Client initialized successfully."

puts "Calling generate_content..."
begin
  response = client.generate_content("Explain the concept of quantum entanglement in a single sentence.")

  puts response
  
rescue StandardError => e
  puts "Error during generate_content call: #{e.message}"
  puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
end

puts "Script finished."