ls | awk '{print "tar cjvf",$1".tar.bz2",$1"; rm -rf",$1"; mv",$1".tar.bz2 arch;"}' >> arch.sh; chmod +x arch.sh; echo 'sanity check this output before running arch.sh'

