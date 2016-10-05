require 'digest'
require 'fileutils'
require 'open-uri'
require 'yaml'

Dir.chdir(__dir__)

dependencies = YAML.load_file('dependencies.yml')

src_directory = 'compiler-src'

FileUtils.mkdir_p(src_directory)

dependencies.each do |name, info|
  archive_file_name = info['archive_name'].gsub('$VERSION', info['version'])

  archive_file_path = File.join(src_directory, archive_file_name)

  if File.exist?(archive_file_path)
    puts "Checking #{name} archive."

    File.open(archive_file_path, 'rb') do |archive_file|
      checksum = Digest::SHA512.hexdigest(archive_file.read)

      if checksum != info['checksum']
        raise "Existing copy of #{archive_file_name} is invalid. Expected checksum to be #{info['checksum']} but got #{checksum}. Delete it and try again."
      end
    end

    puts "Finished checking #{name} archive."
  else
    base_url = info['base_url'].gsub('$VERSION', info['version'])

    url = "#{base_url}#{archive_file_name}"

    puts "Downloading #{name} #{info['version']} from #{url}."

    remote_file_content_length = 0

    content_length_proc = -> (content_length) {
      remote_file_content_length = content_length
    }

    progress_proc = -> (size) {
      print "\r#{size} / #{remote_file_content_length} bytes"

      $stdout.flush
    }

    File.open(archive_file_path, 'wb') do |local_archive_file|
      open(url, 'rb', content_length_proc: content_length_proc, progress_proc: progress_proc) do |remote_archive_file|
        local_archive_file.write(remote_archive_file.read)
      end
    end

    puts

    puts "Finished downloading #{name} #{info['version']}."

    puts "Checking #{name} #{info['version']} archive."

    File.open(archive_file_path, 'rb') do |archive_file|
      checksum = Digest::SHA512.hexdigest(archive_file.read)

      if checksum != info[:checksum]
        raise "Error downloading #{archive_file_name}. Expected checksum to be #{info['checksum']} but got #{checksum}."
      end
    end
  end

  Dir.chdir(src_directory) do
    puts "Extracting #{name} #{info['version']} archive."

    FileUtils.rm_rf(archive_file_name.gsub(/\.tar\.(gz|lz)\z/, ''))

    case info['extract_command']
    when 'tar'
      unless system("tar -xzf #{archive_file_name}")
        raise "Error extracting #{archive_file_name}."
      end
    when 'lzip'
      FileUtils.rm_rf(archive_file_name.gsub(/\.lz\z/, ''))

      unless system("lzip -d -k #{archive_file_name}") && system("tar -xf #{archive_file_name.gsub(/\.lz\z/, '')}")
        raise "Error extracting #{archive_file_name}."
      end
    else
      raise 'Unknown extract command.'
    end
  end

  puts "Finished extracting #{name} #{info['version']} archive."
end
