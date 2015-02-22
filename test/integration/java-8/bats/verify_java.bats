@test "that java is install" {
	run test -f /usr/bin/java 
	[ "$status" -eq 0 ]
}

@test "that java libs is installed" {
	run test -d /usr/lib/jvm 
	[ "$status" -eq 0 ]
}


