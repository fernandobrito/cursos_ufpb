require 'dropbox_sdk'

# Store files on cloud
module FileStorage
  def self.store(filename, file)
    client = DropboxClient.new(ENV['DROPBOX_ACCESS_TOKEN'])
    client.put_file(filename, file)
  end
end
