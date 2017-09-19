#
#   makes the output nicer
#   
#   License: MIT  
/\t1\t/    { gsub(/\t1\t/,"\thttps://\t"); }
/\thttp\t/ { gsub(/\thttp\t/,"\thttp://\t"); }
/\t\t/     { gsub(/\t\t/,"\t"); }
/\/\/\t/   { gsub(/\/\/\t/,"//"); }
/\t$/      { gsub(/\t$/,""); }
//         { sub(/\t/,"\tDomain_grep\t"); }
# here you can change the separator 
#/\t/      { gsub(/\t/,"|"); }
//         { print $0 }
