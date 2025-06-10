require 'gemini_craft'
require 'file-tail'
require 'dotenv/load'

GeminiCraft.configure do |config|
  config.api_key = ENV['GEMINI_API_KEY']
  config.model = 'gemini-1.5-flash'
  config.timeout = 30
  config.max_retries = 3 
end

class LogAiMatic

  def initialize
    @client = GeminiCraft::Client.new()
  end

  #fswatch

  def start_watching
    puts "Starting to watch for errors in logs/error.log..."

    prompt = <<~PROMPT
      You are a teacher working with students learning how to program.
      The students ruby file is: #{File.read("App.rb")}.
      Print the line with the error from the students code. Explain the problem and don't give a solution.
      Enhance response for readability in terminal.
    PROMPT

    File.open("logs/error.log") do |log|
      log.extend(File::Tail)
      log.interval = 10
      log.tail do |line|
        if line.downcase.include?("error")
          puts "\n- - -\nDetected error in log line: #{line.strip}"
          begin
            response = @client.generate_content(
              "Explain this log line:\n#{line}",
              prompt
            )

            if response
              puts "\nLogAiMatic\n #{response}"
              puts "\nPress Enter to continue watching logs..."
              $stdin.gets
            end
          rescue StandardError => e
            puts "Error calling Gemini API: #{e.message}"
          end
        end
      end
    end
  end
end


if __FILE__ == $0
  watcher = LogAiMatic.new
  watcher.start_watching
end