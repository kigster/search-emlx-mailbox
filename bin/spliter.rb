#!/usr/bin/env ruby

if ARGV.empty?
  puts 'Usage: splitter <mbox-path>'
  exit 0
end

mbox_file = ARGV.first
$mbox_path = File.dirname(mbox_file)

def new_file(index)
  File.open("#{$mbox_path}/#{index}.elmx", 'w')
end

def close_file(file)
  file.close
  printf '.'
end

last_line    = nil
counter      = 1
current_file = new_file(counter)

open(ARGV.first).each do |line|
  if line[/^From /]
    close_file(current_file)
    counter      += 1
    current_file = new_file(counter)
  end
  last_line = line
  current_file.print(line)
end

close_file(current_file)
