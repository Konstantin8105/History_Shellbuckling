BEGIN  {
        HOM   =  "/home/progs"
        OTH   =  "/home/progm"
        PRI   =  (HOM "/DIF")
        nd    =  0
        printf("echo \"\"  > %s\n", PRI)
}

$0 ~ /:$/ {
        lng  =  length(($1)) - 1
        dir  =  substr(($1), 1, lng)
        nd   =  nd + 1

        printf("echo \"\" >> %s\n", PRI)
        printf("echo \"==== differences for directory ( %s ) ====\" >> %s\n", dir, PRI)
        printf("echo \"\" >> %s\n", PRI)

	if (nd > 0) {
          printf("cd %s\n", HOM)
	}

        printf("cd %s\n", dir)
	next
}


NF > 0 {
        lng  =  length(($1))
        fil  =  substr(($1), 1, lng)

        printf("echo \"---- diff for file ( %s ) ----\" >> %s\n", fil, PRI)
        printf("diff %s %s/%s/%s >> %s\n", fil, OTH, dir, fil, PRI)
}


END {
          printf("cd %s\n", HOM)
}
