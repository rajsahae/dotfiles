#!/usr/bin/env ruby
# encoding: UTF-8
#
# by Raj Sahae
# Aug 2015

# Inspired by viewhtmlmail.py python script
#   https://github.com/akkana/scripts/blob/master/viewhtmlmail

# Overview:
#   Take an mbox email message from mutt
#   Split out attachments that are images, write to temp dir
#   Split out the html part and write it to an html file in temp dir
#   Open the html pages in browser
#
# Uses the ruby mail gem by Mikel Lindsaar
#   https://github.com/mikel/mail
#
# Add macros to your .muttrc file to use this, for example:
#  macro  index  \Cv  ": unset pipe_decode\n<pipe-message>viewhtmlmail.rb\n: set pipe_decode\n" "View HTML in browser"
#  macro  pager  \Cv  ": unset pipe_decode\n<pipe-message>viewhtmlmail.rb\n: set pipe_decode\n" "View HTML in browser"
 

require 'mail'
require 'tmpdir'

Dir.mktmpdir do |dir|
  Dir.chdir(dir) do 

    str = STDIN.read
    File.open('mail', 'w') { |file| file.puts str }
    mail = Mail.read('mail')

    # Shamelessly stolen right out of the mail gem README
    mail.attachments.each do |attachment|
      if attachment.content_type.start_with?('image/')
        filename = attachment.filename
        begin
          File.open(filename, "w+b", 0644) { |f| f.write attachment.body.decoded }
        rescue => e
          puts "Unable to save data for #{filename}: #{e.message}"
        end
      end
    end

    if mail.parts.empty?
      File.open("mail.html", 'w') do |file|
        file.puts mail.body.to_s
      end
    else

      mail.parts.each_with_index do |part, index|
        next unless part.content_type.start_with? 'text/html'

        # We need to replace the image src links with the local filename
        # src="cid:image003.jpg@01D0D911.F135CA10" => image003.jpg
        html = mail.attachments.inject(part.body.to_s) do |memo, attachment|
          filename = attachment.filename
          content_id = attachment.content_id[1...-1]

          if memo.include? attachment.filename
            memo.gsub(/src="cid:#{filename}@[^"]*"/, "src=\"#{filename}\"")
          elsif memo.include? attachment.content_id[1...-1]
            memo.gsub(/src=.*#{content_id}"/, "src=\"#{filename}\"")
          end

        end

        File.open("mail-#{index}.html", 'w') do |file|
          file.puts html
        end
      end

    end

    # Open all of the html pages we wrote out
    Dir['*html'].each { |page| system("open #{page}") }

    # We need to wait a bit so the files are there when we try to open
    sleep 1

  end
end
