# gawk program for parsing ring location data files.

    BEGIN {p = 0}

# Begin first pass through file.
(pass == 1) {
    if (p == 1) {
      if ($1 == "1") {
	printf "\"Model Geometry\n+linestyle(continuous)\n"
	previous_segment = $4
      }
      if (previous_segment != $4) {
	printf "\n+linestyle(continuous)\n"
	previous_segment = $4
      }
      print $2, $3
    }
    if ($0 == "*") {
      getline
      p = 1
    }
}

# Begin second pass through file.
(pass == 2) {
    if (p == 1) {
      if ($1 == "1") {
        printf "\n\"Ring Locations\n"
        printf "+markeron\n"
        printf "+setmarker(4)\n"
        printf "+linestyle(none)\n"
      }
      if ($5 == "1") print $6, $7
    }
    if ($0 == "*") {
      getline
      p = 1
    }
}

# end
