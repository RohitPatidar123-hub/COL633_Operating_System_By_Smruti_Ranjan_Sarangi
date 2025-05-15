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

spawn /bin/sh
expect "$ "


# # startup
puts "STARTUP"
send "make clean\r"
sleep 1
send "make qemu-nox\r"
sleep 3
# expect {
#     "$" {}
#     timeout {puts "Wrong Startup"; exit 1}
# }
set timeout 20

# echo 
puts "TESTING ECHO"
send "echo Hello1\r"
sleep 2
expect {
    "Hello1" {}
    timeout {puts "Echo not works"}
}
expect {
     -re "PID: (\\d+)\r\nTAT: (\\d+)\r\nWT: (\\d+)\r\nRT: (\\d+)\r\n#CS: (\\d+)" {}
    timeout {puts "Echo metrics not printed."}
}

# expect {
#     -re "PID: (\\d+)\r\nTAT: (\\d+)\r\nWT: (\\d+)\r\nRT: (\\d+)\r\n#CS: (\\d+)" {}
#     timeout { puts "$submission_name,Timed out at last line."; exit 1 }
# }


set timeout 160
set timedout false;
set submission_name [lindex $argv 0]
set csv_file [lindex $argv 1]

puts "TESTING SCHEDULER"
# spawn make qemu-nox
# expect {
#     "$ " {}
#     timeout { puts "$submission_name,Build failed"; exit 1 }
# }

send "test_sched\r"
sleep 2

# Initialize storage
set child_data {}

set expected_child_count 4
set matched_start 0
set matched_exit 0

# expect {
#     "All child processes created with start_later flag set." {}
#     timeout { puts "$submission_name,Child processes creation Failed"; exit 1 }
# }
# expect {
#     -re "PID: (\\d+)\r\nTAT: (\\d+)\r\nWT: (\\d+)\r\nRT: (\\d+)\r\n#CS: (\\d+)" {
#         set pid $expect_out(1,string)
#         set tat $expect_out(2,string)
#         set wt  $expect_out(3,string)
#         set rt  $expect_out(4,string)
#         set cs  $expect_out(5,string)
#         lappend child_data "$pid,$tat,$wt,$rt,$cs"
#         incr matched_start
#         if {$matched_start < 2} {
#             exp_continue
#         }
#     }
#     timeout { puts "$submission_name,Timed out during child exit phase"; exit 1 }
# }
# expect {
#     "Calling sys_scheduler_start() to allow execution." {}
#     timeout { puts "$submission_name,sys_scheduler_start() not called"; exit 1 }
# }

# expect {
#     -re "Child (\\d+) \\(PID: (\\d+)\\) started but should not run yet.\r\n" {
#         exp_continue
#     }
#     timeout {}
# }

expect {
    -re "PID: (\\d+)\r\nTAT: (\\d+)\r\nWT: (\\d+)\r\nRT: (\\d+)\r\n#CS: (\\d+)(\r\n)*" {
        set pid $expect_out(1,string)
        set tat $expect_out(2,string)
        set wt  $expect_out(3,string)
        set rt  $expect_out(4,string)
        set cs  $expect_out(5,string)
        lappend child_data "$pid,$tat,$wt,$rt,$cs"
        incr matched_exit
        if {$matched_exit < 4} {
            exp_continue
        }
    }
    timeout { puts "$submission_name,Timed out during child exit phase"
                set timedout TLE
                incr matched_exit
                lappend child_data "$timedout, $timedout, $timedout,$timedout,$timedout"
                if {$matched_exit < 4} {
                    exp_continue
                }}
}

# expect {
#     "All child processes completed." {}
#     timeout { puts "$submission_name, child process not completed."; exit 1 }
# }
# expect {
#     -re "PID: (\\d+)\r\nTAT: (\\d+)\r\nWT: (\\d+)\r\nRT: (\\d+)\r\n#CS: (\\d+)" {}
#     timeout { puts "$submission_name,Timed out at last line."; exit 1 }
# }
# Format output for CSV
set csv_line "$submission_name"
foreach child $child_data {
    append csv_line ",$child"
}
# Fill remaining columns with blanks if < 3 children
for {set i $matched_exit} {$i < 4} {incr i} {
    append csv_line ",-1,-1,-1,-1,-1"
}
# Open the file in append mode
set fh [open "../$csv_file" "a"]
puts $fh $csv_line
close $fh


send "\x01"; send "x"
expect "QEMU: Terminated"
send "exit\r"
expect eof