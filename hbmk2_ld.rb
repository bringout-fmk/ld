files=Dir["*.prg"]

line = ""
files.each do |f|

 line += " " + f
end

cmd = "hbmk2 -b -old.exe /ufmk_std.ch " + line

puts cmd
system(cmd)

