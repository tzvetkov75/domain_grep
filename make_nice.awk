#
#   makes the output nicer
#
#   Vesselin  
#
#   License: MIT  
/\t1\t/    { gsub(/\t1\t/,"\thttps://\t"); }
/\thttp\t/ { gsub(/\thttp\t/,"\thttp://\t"); }
/\t\t/     { gsub(/[\t]+/,"\t"); }
/\/\/\t/   { gsub(/\/\/\t/,"//"); }
/\t$/      { gsub(/\t$/,""); }
//         { sub(/\t/,"\tDomain_grep\t"); }
# uncomment to change the separator. Default separator is tab \t 
#/\t/      { gsub(/\t/,"|"); }
//         { print $0 }
