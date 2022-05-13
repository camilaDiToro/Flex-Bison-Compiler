cmake -S . -B bin
cd bin
make
cd .. 
cat program.json | bin/Compiler # run program 
echo 'TLA Compiler - DONE'

