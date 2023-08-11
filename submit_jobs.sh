problem_sizes=(1048576 2097152 4194304 8388608)
optimization_levels=(O0 O1 O2 O3)
for problem_size in "${problem_sizes[@]}"; do
    for OP in "${optimization_levels[@]}"; do
        for trial in $(seq 10); do
            sbatch gcc.sh ${problem_size} ${OP} ${trial}
        done
    done
done