#!/usr/bin/ruby

# Find all instances of MAC addresses in files in the current directory
# (or in any subdirectories). Output them to a file, one per line.
# Optional: Output only unique MAC addresses, with counts of how
# many times they occurred.

require "tempfile"

def full_path(dir, f)
  [dir, f].join("/")
end

def is_mac?(s)
  s =~ /\b([0-9a-fA-F]{12})\b/
end

def get_macs(dir)
  macs = Array.new
  Dir.foreach(dir) do |f|
    next if [".", ".."].include?(f) # skip local dirs
    next if f.start_with?(".") # skip hidden files
    path = full_path(dir, f)
    if File.directory?(path)
      get_macs(path).map { |mac| # recurse
        macs << mac
      }
    elsif File.ftype(path) == "file"
      scan_macs([dir,f].join("/")).map {|mac|
        macs << mac
      }
    end
  end
  macs
end

def scan_macs(file)
  macs = Array.new
  File.open(file) do |f|
    f.each_line do |line|
      if is_mac?(line)
        macs << line.chomp
      end
    end
  end
  macs
end

summary = Hash.new { |h,k| h[k] = 0 }

macs = get_macs("./data")

macs.each do |mac|
  summary[mac] += 1
end

# write summary to macs.out
File.open("macs.out", "w") do |f|
  summary.each_pair do |mac, count|
  line = "%-10s%4d\n" %  [mac, count]
    printf(line)
    f.write(line)
    
  end
  f.flush
end
