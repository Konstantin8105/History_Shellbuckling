# bosorplot.awk splits the {case}.PLT2 file into separate plot files.

BEGIN {
   split(ARGV[1], a, ".")
}

{ 
  if ($1 == "$END") {
    close("temp")
    s1 = "/bin/ls | grep " name " > /dev/null"
    status = system(s1)
    if (!status) {
      s2 = "/bin/mv " name " " name "_A"
      system(s2)
      s3 = "/bin/mv temp " name "_B"
      system(s3)
    } else
      system("/bin/mv temp " name)
    next
  }

  if ($1 == "*") {
    name = fixname(prev)
    name = a[1] ".." name
  }

  prev = $0
  print $0 > "temp"

} # MAIN BODY

# Get rid of whitespace in s.
function fixname(s) {
  while (index(s, "= "))
    sub(/\= /, "=", s)
  end
  while (index(s, "  "))
    sub(/  /, " ", s)
  end
  gsub(/ /, "_", s)
  return s
}
