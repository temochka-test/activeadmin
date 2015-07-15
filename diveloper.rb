require 'securerandom'
require 'net/http'
require 'uri'

class WebhookClient
  def initialize(url)
    @url = URI.parse(url)
    @http = Net::HTTP.new(@url.host, @url.port)
    @http.use_ssl = @url.port == 443
    @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  def fire
    @http.post(@url.path, nil)
  end
end

class Diveloper
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def commit
    `git add -A`
    `git commit -a -m "#{ARGV.first || generate_commit_message}"`
  end

  def push
    `git push origin master`
  end

  def remove_file
    File.delete(changeable_files.sample)
  end

  def change_file
    path = changeable_files.sample
    file = File.read(path)
    File.open(path, 'w') do |f|
      f.write(file.gsub(/\s/, "\\0\\0"))
    end
  end

  def create_file
    location = Dir[File.join(path, '**/*')].select { |f| File.directory?(f) }.sample
    ext = known_extensions.sample
    name = "#{SecureRandom.hex(8)}.#{ext}"
    File.open(File.join(location, name), 'w') do |f|
      f.write(sample_files[ext])
    end
  end

  private

  def changeable_files
    Dir[File.join(path, "**/*.{#{known_extensions.join(',')}}")].reject { |f| f.to_s.end_with?('diveloper.rb') }
  end

  def known_extensions
    %w(rb txt md js html css)
  end

  def sample_files
    {
      'rb' => "require 'json'\n",
      'txt' => "Hello, World!\n",
      'md' => "# Header\n# Header 2\n",
      'js' => "var foo = 42;\n",
      'html' => "<!doctype html>\n<html>\n<head><title>Title</title></head>\n<body><h1>Header</h1>\n</html>\n",
      'css' => ".foo { background: #ffffff }\n"
    }
  end

  def generate_commit_message
    verb = %w(Fix Introduce Add Delete).sample
    subject = ['a bug', 'a feature', 'an issue', 'a problem', 'functionality'].sample
    participle = %w(causes allows lets).sample
    feature = ['a duck to quack twice',
               'users to use IE',
               'people to die',
               'NPCs to go through the wall'].sample

    "#{verb} #{subject} that #{participle} #{feature}"
  end
end

puts "Diveloping..."
diveloper = Diveloper.new('.')
client = WebhookClient.new('https://artem.deploybot.vm/webhook/77ba84aed7f1605aa7bc8e039be39c2e47defc76af2ea36f')
1.times { diveloper.create_file }
5.times { diveloper.change_file }
1.times { diveloper.remove_file }
puts 'Committing...'
diveloper.commit
puts 'Pushing...'
diveloper.push
client.fire
