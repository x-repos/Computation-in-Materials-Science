# MATLAB

Run Makepath.m to get paths.dat (1) and coorSiO.dat (2)

(1) paths.dat is used for run c file in terminal
(2) coorSiO.dat contains coordinate of Si and O atoms for future calculation

# cd C

# Remove ojbective files if executive file and objective files exist
# Remove is optional

ben@Ben ./remove.sh

# Makefile - generate objective files and executive file

ben@Ben make

# C

Run C with systax:

./countrings2 -c < paths.dat 12

Results will display on screen (1) or in the rings.dat (2)


(1) That is default feature
(2) Edit file countrings2.c. Use fprintf(file) in instead of using printf(screen)


# Make the fullsize rings distrubution
- calculate ring statistics with possible maxsize -> rings.dat
- copy rings.dat -> ringsCombine.dat
- resize ring size and calcuate ring statistic -> rings.dat
- copy the remainging value in rings.dat -> ringsCombine.dat