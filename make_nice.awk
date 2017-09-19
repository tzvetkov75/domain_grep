/\t1\t/ { gsub(/\t1\t/," https://"); print $0}
/\thttp\t/ { gsub(/\thttp\t/," http://"); print $0}
/\t/ { gsub(/\t/g,""); print $0}


