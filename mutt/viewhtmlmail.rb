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
require 'pp'

def extract_parts(ary, parent)
  # collect all html messages. Dive into multipart/alternative to find html
  parent.parts.inject(ary) do |memo, part|
    if part.content_type =~ /text\/html/
      memo.push(part)
    elsif part.content_type =~ /multipart/
      # puts '--- multiparts ---'
      # pp part.parts
      extract_parts(memo, part)
    end
    memo
  end
end

def replace_images(mail, ary)
  ary.each_with_index do |part, index|
    # We need to replace the image src links with the local filename
    # src="cid:image003.jpg@01D0D911.F135CA10" => image003.jpg
    html = mail.attachments.inject(part.body.to_s) do |memo, attachment|

      filename = attachment.filename
      content_id = attachment.content_id[1...-1]

      # p filename
      # p content_id

      if memo.include? attachment.filename
        memo.gsub(/src="cid:#{filename}@[^"]*"/, "src=\"#{filename}\"")
      elsif memo.include? attachment.content_id[1...-1]
        memo.gsub(/src=.*#{content_id}"/, "src=\"#{filename}\"")
      else
        memo
      end

    end

    File.open("mail-#{index}.html", 'w') do |file|
      file.puts html
    end

  end
end

Dir.mktmpdir do |dir|
  Dir.chdir(dir) do 

    File.open('mail', 'w') { |file| file.puts STDIN.read }
    mail = Mail.read('mail')

    # puts "--- Attachments ---"
    # pp mail.attachments

    # Shamelessly stolen right out of the mail gem README
    mail.attachments.each do |attachment|
      if attachment.content_type =~ /image\//
        filename = attachment.filename
        begin
          File.open(filename, "w+b", 0644) { |f| f.write attachment.body.decoded }
        rescue => e
          puts "Unable to save data for #{filename}: #{e.message}"
        end
      end
    end

    # puts "--- mail.parts ---"
    # puts mail.parts.map(&:content_type).join("\n")

    parts = extract_parts([], mail)

    # puts '--- extracted parts ---'
    # pp parts

    if parts.empty?
      puts 'mail parts empty'
      File.open("mail.html", 'w') do |file|
        file.puts mail.body.to_s
      end
    else
      replace_images(mail, parts)
    end

    # Open all of the html pages we wrote out
    # puts '--- html files ---'
    # pp Dir['*html']

    Dir['*html'].each { |page| system("open #{page}") }

    # We need to wait a bit so the files are there when we try to open
    sleep 3

  end
end
