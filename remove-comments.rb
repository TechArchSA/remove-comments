#!/usr/bin/env ruby 
# TechArch: www.techarch.com.sa
# Sabri   : @KINGSABRI
#
# Source Code comments removal
# 

=begin
Language to support
- Auto detect
  - Java
  - ASP.net
  - JavaScript
  - Ruby
  - Python
  - Go
=end


require 'optparse'
require 'pp'

class String
  def red; colorize(self, "\e[1m\e[31m"); end
  def green; colorize(self, "\e[1m\e[32m"); end
  def dark_green; colorize(self, "\e[32m"); end
  def bold; colorize(self, "\e[1m"); end
  def underline; colorize(self, "\e[4m"); end
  def colorize(text, color_code) "#{color_code}#{text}\e[0m" end
end

options = {}
option_parser = OptionParser.new
option_parser.release = '0.0.1'
option_parser.release
option_parser.banner = "#{'comments removal'.bold} - code comments removal."
option_parser.set_summary_indent '   '
option_parser.separator "\nHelp menu:".underline
option_parser.on('-d', '--dest <FILE | DIRECTORY>', 'Destination file or directory') {|o| options[:destination] = o}
option_parser.on('-l', '--language LANG', 'Force specific language', Array, '(supported languages: java,aspx,javascript,ruby,python,c)') {|o| options[:language] = o}
option_parser.on('-h', '--help', 'Show this help message')
option_parser.on_tail "\nUsage:\n".underline + "ruby #{__FILE__} -d <FILE|DIRECTORY> [OPTIONS]"
option_parser.parse ARGV

# comment regex store for all supported language
def regex
  {
      'java'       => /(\/\*+([^\*]|\*(?!\/))*(\*\/))|(\/{2}.*)/, # (\/\*([\s\S]*?)\*\/)|(\/\/(.*)$)
      'aspx'       => //,
      'javascript' => //,
      'js'         => //,
      'ruby'       => //,
      'python'     => //,
      'c'          => /((?:\/\*(?:[^*]|(?:\*+[^*\/]))*\*+\/)|(?:\/\/.*))/,
  }
end

# clean, remove comments base on given regex then rewrite the file
def clean(file, regex)
  full_code = File.read(file).scrub
  code      = full_code.gsub(regex, '')
  File.open(file, 'w') {|file| file.print code}

  return full_code.scan(regex).count
end

def remove_comments(destination, language=nil)
  count = 0
  if language
    language.each do |lang|
      if File.directory? destination
        dst_dir = Dir.glob("#{destination}/**/*.#{lang}")
        dst_dir.each do |file|
          count += clean(file, regex[lang])
        end
        puts "[+] Total Removed comments: #{count}"
      elsif File.file? destination
        clean(destination, regex[lang])
        count += clean(destination, regex[lang])
        puts "[+] Total Removed comments: #{count}"
      else
        puts 'sorry......'
      end
    end

  else  # no specific language given
    if File.directory? destination
      dst_dir = Dir.glob("#{destination}/**/*.*")
      dst_dir.each do |file|
        extension = file.split('.').last.downcase     # auto detect
        puts "[+] Language detected by file extension: #{extension}"
        count += clean(file, regex[extension])
      end
      puts "[+] Total Removed comments: #{count}"
    elsif File.file? destination
      extension = destination.split('.').last.downcase
      puts "[+] Language detected by file extension: #{extension}"
      count += clean(destination, regex[extension])
      puts "[+] Removed comments: #{count}"
    else
      puts 'sorry......'
    end
  end
end





# def remove_comments(destination, language=nil?)
#   begin
#
#     count = 0
#     if File.directory? destination
#       dst_dir = Dir.glob("#{ARGV[0]}/**/*.java")
#       dst_dir.each do |java_file|
#         full_code = File.read(java_file).scrub
#         code      = full_code.gsub(Regex::Java, '')
#         count    += full_code.scan(Regex::Java).count
#         puts "[->] #{java_file}"
#         File.open(java_file, 'w') {|file| file.print code}
#       end
#       puts "[+] Total Removed comments: #{count}"
#     elsif File.file? destination
#       full_code = File.read(destination).scrub
#       code      = full_code.gsub(Regex::Java, '')
#       count     = full_code.scan(Regex::Java).count
#       puts "[+] #{destination}"
#       puts "[+] Removed comments: #{count}"
#       File.open(destination, 'w') {|file| file.print code }
#     else
#       puts 'sorry......'
#     end
#
#   rescue Exception => e
#     puts e
#     puts e.backtrace
#     puts e.backtrace_locations
#   end
#
# end



case
when options[:destination] && options[:language]
  remove_comments(options[:destination], options[:language].map(&:downcase))
when options[:destination]
  remove_comments(options[:destination])
else
  puts option_parser
end


























