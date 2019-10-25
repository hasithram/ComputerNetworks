set ns [new Simulator]
set nf [open out.nam w]
$ns namtrace-all $nf                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
set tra1 [open out.tr w]
$ns trace-all $tra1


proc finish {} {
	global ns nf
	$ns flush-trace
		#CLOSE THE TRACE FILE
	close $nf
		#EXECUTE NAM ON THE TRACE FILE
	exec nam out.nam &
	exit 0
}


set S1 [$ns node]
set S2 [$ns node]
set S3 [$ns node]
set S4 [$ns node]
set R1 [$ns node]
set R2 [$ns node]
set d1 [$ns node]
set d2 [$ns node]
set d3 [$ns node]
set d4 [$ns node]


$ns duplex-link $S1 $R1 1Mb 10ms DropTail
$ns duplex-link $S2 $R1 1Mb 10ms DropTail
$ns duplex-link $S3 $R1 1Mb 10ms DropTail
$ns duplex-link $S4 $R1 1Mb 10ms DropTail
$ns duplex-link $R1 $R2 1Mb 10ms DropTail
$ns duplex-link $d1 $R2 1Mb 10ms DropTail
$ns duplex-link $d2 $R2 1Mb 10ms DropTail
$ns duplex-link $d3 $R2 1Mb 10ms DropTail
$ns duplex-link $d4 $R2 1Mb 10ms DropTail


set tcp0 [new Agent/TCP]
$ns attach-agent $S1 $tcp0


set tcp1 [new Agent/TCP]
$ns attach-agent $S3 $tcp1


set udp0 [new Agent/UDP]
$ns attach-agent $S2 $udp0


set udp1 [new Agent/UDP]
$ns attach-agent $S4 $udp1


set tcpsink0 [new Agent/TCPSink]
$ns attach-agent $d1 $tcpsink0


set tcpsink1 [new Agent/TCPSink]
$ns attach-agent $d1 $tcpsink1


set null0 [new Agent/Null]
$ns attach-agent $d3 $null0


$ns connect $udp0 $null0
$ns connect $udp1 $null0
$ns connect $tcp0 $tcpsink0
$ns connect $tcp1 $tcpsink1


set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0


set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1


set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0


set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1


$ns at 0.5 "$ftp0 start"
$ns at 4.5 "$ftp0 stop"
$ns at 0.5 "$ftp1 start"
$ns at 4.5 "$ftp1 stop"
$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"
$ns at 0.5 "$cbr1 start"
$ns at 4.5 "$cbr1 stop"
$ns at 5.0 "finish"
$ns run

