import argparse


def main():

    parser = argparse.ArgumentParser(
        description='LULESH job submission script generator.')
    parser.add_argument('-p', nargs="+", dest='mpi_ranks', type=int, action='store', default=[
                        8, 27, 64, 125, 216, 343], help='the number of MPI ranks used for job creation')
    parser.add_argument('-s', nargs="+", dest='size', type=int, action='store', default=[
                        10, 20, 30, 40, 50], help='the problem size, length of cube mesh along side')
    parser.add_argument('-r', dest='repetitions', type=int, action='store', default=1,
                        help='set the number of repetitions to run per application configuration')

    # get the command line arguments
    args = parser.parse_args()
    mpi_ranks = args.mpi_ranks
    repetitions = args.repetitions
    size = args.size

    rep = "1"
    if repetitions == 1:
        rep = "1"
    else:
        rep = "1-"+str(repetitions)

    text = ""
    file = open("submit_jobs.sh", "w")

    for p in mpi_ranks:
        for s in size:
            text += "echo \"Submitting LULESH job with p="+str(p)+" and s="+str(
                s)+"\"\nsbatch --array="+str(rep)+" job_p"+str(p)+"_s"+str(s)+".sh\nsleep 2s\n"

    file.write(text)
    file.close()


if __name__ == '__main__':
    main()
