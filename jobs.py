import argparse

def main():
	parser = argparse.ArgumentParser(description='LULESH job script generator.')
	parser.add_argument('--weak', dest='weak', action='store_true', default=True, help='use weak scaling')
	parser.add_argument('--strong', dest='strong', action='store_true', default=False, help='use strong scaling')
	parser.add_argument('-p', nargs="+", dest='mpi_ranks', type=int, action='store', default=[8,27,64,125,216], help='the number of MPI ranks used for job creation')
	parser.add_argument('-s', dest='size', type=int, action='store', default=30, help='the problem sixe, length of cube mesh along side')
 
	# get the command line arguments
	args = parser.parse_args()
	weak = args.weak
	strong = args.strong
	mpi_ranks = args.mpi_ranks
	size = args.size

	if strong:
		weak = False

	# use weak scaling
	if weak:
  
		for p in mpi_ranks:
			
			file = open("job_p"+str(p)+".sh","w")
			text = """#!/bin/bash
         
#!/bin/bash
#SBATCH --time=00:10:00
#SBATCH --output=output.p"""+str(p)+""".r%a.out
#SBATCH --error=error.p"""+str(p)+""".r%a.out
#SBATCH --mail-type=END
#SBATCH --mail-user=ritter5@llnl.gov
#SBATCH --exclusive
#SBATCH --ntasks """+str(p)+"""
#SBATCH -J lulesh

ml gcc

srun ./build/lulesh2.0 -s """+str(size)+"""
"""
			file.write(text)
			file.close()
	
	# use strong scaling
	else:
		
		# get the base problem size of the smallest number of MPI ranks
		base_size = size
		# calculate the total number of elements for this configuration
		total_elements = calculate_total_elements(base_size, min(mpi_ranks))
		
		for p in mpi_ranks:
			
			# calculate the size so that we use strong scaling
			size = calculate_size(p, total_elements)

			file = open("job_p"+str(p)+".sh","w")
			text = """#!/bin/bash
         
#!/bin/bash
#SBATCH --time=00:10:00
#SBATCH --output=output.p"""+str(p)+""".r%a.out
#SBATCH --error=error.p"""+str(p)+""".r%a.out
#SBATCH --mail-type=END
#SBATCH --mail-user=ritter5@llnl.gov
#SBATCH --exclusive
#SBATCH --ntasks """+str(p)+"""
#SBATCH -J lulesh

ml gcc

srun ./build/lulesh2.0 -s """+str(size)+"""
"""
			file.write(text)
			file.close()

def calculate_total_elements(s, p):
	total_elements = p * (s**3)
	return total_elements

def calculate_size(p, total_elements):
	s = (total_elements/p)**(1/3)
	#print(s)
	# because size parameter for LULESH needs to be an integer value
	s = round(s)
	#print(s)
	return s

if __name__=="__main__":
	main()
