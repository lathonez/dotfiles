proc getpass pwprompt {
	set oldmode [stty -echo -raw]
	send_user "\n     $pwprompt"
	set timeout -1
	expect_user -re "(.*)\n"
	send_user "\n"
	eval stty $oldmode
	return $expect_out(1,string)
}

proc utility_encrypt {pd filename} {
	global key HOME
	catch [exec des -e -k $key -b > [file join $HOME pwdir $filename] << $pd]
	return
}

proc utility_decrypt filename {
	global key HOME
	catch {exec cat $HOME/pwdir/$filename | des -d -b -k $key} dpd
	# Some people write the previous command as
	# catch {exec des -d -b -k $key < $HOME/pwdir/$filename} dpd
	return $dpd
}

proc foo_login_proc {device_name} {
	global key sid
	set spawn_id $sid($device_name)
	set decrypted_all [utility_decrypt foo_passwords.enc]
	for {set i 0} {$i <= [llength $decrypted_all]} {incr i} {
		set foo_pws($i) [lindex $decrypted_all $i]
	}

	#loop through foo_pws array using exp_send/expect until login successful...
	set i 0
	set pw $foo_pws($i)
	expect {
		"password for foo: "   {
			exp_send "$pw\n"
			exp_continue
		}
	 	"login successful"     {
			interact
		}
		"invalidd password"     {
			incr i
			set pw $foo_pws($i)
			exp_continue
		}
		"other stuff"          {
		} ;#eof, timeout, errors from device, etc.
	}
	exit
}

