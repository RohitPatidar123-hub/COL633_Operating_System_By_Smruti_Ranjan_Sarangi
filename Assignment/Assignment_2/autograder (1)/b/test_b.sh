#!/usr/bin/expect -f

set force_conservative 0  ;# set to 1 to force conservative mode even if
			  ;# script wasn't run conservatively originally
if {$force_conservative} {
	set send_slow {1 .1}
	proc send {ignore arg} {
		sleep .1
		exp_send -s -- $arg
	}
}

#
# 2) differing output - Some programs produce different output each time
# they run.  The "date" command is an obvious example.  Another is
# ftp, if it produces throughput statistics at the end of a file
# transfer.  If this causes a problem, delete these patterns or replace
# them with wildcards.  An alternative is to use the -p flag (for
# "prompt") which makes Expect only look for the last line of output
# (i.e., the prompt).  The -P flag allows you to define a character to
# toggle this mode off and on.
#
# Read the man page for more info.
#
# -Don


set timeout 10
set passed true;
set err 'NO';
set submission_name [lindex $argv 0]
set csv_file [lindex $argv 1]
# set testname [lindex $argv 0];

spawn /bin/sh
expect "$ "


# startup

puts "STARTUP"
send "make clean\r"
sleep 2

send "make qemu-nox\r"
sleep 10


# echo 
puts "TESTING ECHO"
send "echo Hello1\r"
sleep 2
expect {
    "Hello1" {}
    timeout {puts "Failed : Echo not works"}
}

set result [catch {
    # test ctrl+b
    puts "TESTING CTRL+B"
    send "tom\r"
    sleep 2
    expect {
        "This is normal code running" {}
        timeout {set passed false; error  "Failed : user program not works"}
    }
    send "\x02"
    expect {
        "Ctrl-B is detected by xv6" {}
        timeout {set passed false; error  "Failed : Correct format not followed"}
    }
    sleep 2
    send "echo Hello3\r"
    sleep 2
    expect {
        "Hello3" {}
        timeout {set passed false; error  "Failed : Echo not works after Ctrl+B"}
    }
} errMsg]
sleep 2

# Write results to CSV regardless of pass/fail
set fp [open "../$csv_file" a]
if {$result != 0} {
    puts $fp "$submission_name,$passed,$errMsg"
} else  {
    puts $fp "$submission_name,$passed,NO"
}
close $fp

# finishing test
puts "Passed"
send "\x01"; send "x"
expect "QEMU: Terminated\r"
expect "$ "
send "exit\r"
expect eof