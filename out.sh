mkdir OUT_FILES
cd OUT_FILES
echo 1 | gmx trjconv -f ../md2.xtc -n ../system.ndx -o out.xtc -pbc nojump
echo 1 | gmx trjconv -s ../eq.pdb -n ../system.ndx -o out.pdb -f ../eq.pdb 
 
