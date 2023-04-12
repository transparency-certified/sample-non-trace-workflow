cd programs
R CMD BATCH master.R
echo $?
cat master.Rout
