
# filter = { REF_NAME =~ *RAMB* }
proc report_cells_as_pydict {outfile filter} {
    set bram_cells [get_cells -hierarchical -filter $filter ]

    set re {\s+}
    set result {}
    puts $outfile "bram_cells = {"
    foreach bc $bram_cells {
        puts $outfile "    '$bc':{"
        set bcd [dict create]
        set props [report_property -return_string -regexp $bc "(.*ram.*)|(BEL)|(LOC)|(STATUS)|(FILE_NAME)|(LINE_NUMBER)|(NAME)|(PARENT)|(PRIMITIVE_TYPE)|(REF_NAME)|(READ.*)|(RTL_RAM.*)|(WRITE.*)"]
        set props [lrange [split $props "\n"] 1 end]
        foreach p $props {
            set prop [split [regsub -all $re $p " "] " "]
            dict set bcd [lindex $prop 0] [lindex $prop 3]
        }
        dict for {k v} $bcd {puts $outfile "        '$k':'$v',"}
        puts $outfile "    },"
    }
    puts $outfile "}"
}

