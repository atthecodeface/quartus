
proc sig_iter {sig nsigs fn args base_index} {
    if {$nsigs > 1} {
        for {set n 0} {$n < $nsigs} {incr n} {
            set sig_index [expr $n+$base_index]
            set sig_part "${sig}[$sig_index]"
            $fn $args $n $sig_part
        }
    } else {
        $fn $args 0 $sig
    }
}

proc arg_or_default {args n def} {
    set result $def
    if {[llength $args]>$n} {
        set result [lindex $args $n]
    }
    return $result
}

proc pin_io_signal_set {args n sig} {
    set pins     [arg_or_default $args 0 {}]
    set tag      [arg_or_default $args 1 ""]
    set data     [arg_or_default $args 2 {}]
    if {[llength $pins]>0} {
        set pin_name PIN_[lindex $pins $n]
        set_location_assignment $pin_name -to $sig
    }
    foreach {name value} $data {
        if {$tag != ""} {
            set_instance_assignment -name $name $value -to $sig -tag $tag
        } else {
            set_instance_assignment -name $name $value -to $sig
        }
    }
}
proc pin_lvttl_signal {pins sig {base_index 0}} {
    # slew rate is 1 by default; 0 slow, 1 medium, 2 fast???
    # current strength is 16mA by default
    sig_iter $sig [llength $pins] pin_io_signal_set [list $pins {} {IO_STANDARD "3.3-V LVTTL" SLEW_RATE 1 CURRENT_STRENGTH_NEW 16MA}] $base_index
}

proc pin_2_5v_signal {pins sig {base_index 0}} {
    sig_iter $sig [llength $pins] pin_io_signal_set [list $pins "" {IO_STANDARD "2.5 V"}] $base_index
}

proc io_signal {io tag sig nsig {base_index 0}} {
    sig_iter $sig $nsig pin_io_signal_set [list {} $tag {IO_STANDARD $io}] $base_index
}

proc diff_sstl_signal {tag sig nsig {base_index 0}} {
    sig_iter $sig $nsig pin_io_signal_set [list $tag {IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I"}] $base_index
}

proc sstl_signal {tag sig nsig {base_index 0}} {
    sig_iter $sig $nsig pin_io_signal_set [list $tag {IO_STANDARD "SSTL-15 CLASS I"}] $base_index
}

proc lvttl_signal {tag sig nsig {base_index 0}} {
    sig_iter $sig $nsig pin_io_signal_set [list $tag {IO_STANDARD "3.3-V LVTTL" SLEW_RATE 1 CURRENT_STRENGTH_NEW 16MA}] $base_index
}

proc term50 {tag sig nsig {base_index 0}} {
    sig_iter $sig $nsig pin_io_signal_set [list $tag {INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION"}] $base_index
}

