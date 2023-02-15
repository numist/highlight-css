#! /usr/bin/env ruby
#
# lol so much of this was written by ChatGPT, what a game changer for scripting stuff

require 'yaml'

script_dir = File.expand_path(File.dirname(__FILE__)) # get the directory of the current script
src_dir = File.expand_path("..", script_dir)          # move up one directory
Dir.chdir(src_dir)                                    # change the current working directory to the parent directory

file_path = "index.md"
styles_dir = "stylesheets"

def get_file_names_without_extensions(directory_path)
  # Get a list of all the files in the directory
  files = Dir.entries(directory_path)
  # Filter out directories and hidden files
  files = files.reject { |file| File.directory?(File.join(directory_path, file)) || file.start_with?('.') }
  # Remove file extensions from each file name
  files.map { |file| File.basename(file, '.*') }
end

def get_directory_names(directory_path)
  # Get a list of all the files in the directory
  files = Dir.entries(directory_path)
  # Filter out non-directories and hidden directories
  files.select { |file| File.directory?(File.join(directory_path, file)) && !file.start_with?('.') }
end

# Read the contents of the file into a string
markdown_content = File.read(file_path)

# Extract the front matter from the Markdown content
front_matter_regex = /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
front_matter_matches = front_matter_regex.match(markdown_content)
unless front_matter_matches
  puts "error: no front matter found in file: #{file_path}"
  exit 1
end
front_matter = YAML.load(front_matter_matches[1])

# Update front matter with lists of styles from the /stylesheets directory
front_matter["styles"] = {}
get_directory_names(styles_dir).each do | type |
  front_matter["styles"][type] = get_file_names_without_extensions(styles_dir+"/"+type)
end


# Convert the updated front matter back to YAML and replace the original
# front matter in the Markdown content
updated_front_matter = YAML.dump(front_matter).strip + "\n---\n\n"
markdown_content.sub!(front_matter_regex, updated_front_matter)
# Write the updated Markdown content back to the file
File.write(file_path, markdown_content)
