library(peer)
reads= read.csv('/home/ls/rachelcw/projects/PEER/20221113_data_for_peer.csv')
dim(reads)
reads= reads[-1] #drop x columns
model=PEER()
Nmax_iterations = 100
K=25

# set data and parameters
PEER_setNk(model, K) #number of factor for learning
PEER_setPhenoMean(model, as.matrix(reads)) # data for inference - note the as.matrix() !
# set priors (these are the default settings of PEER)
PEER_setPriorAlpha(model,0.001,0.1);
PEER_setPriorEps(model,0.1,10.);
PEER_setNmax_iterations(model,Nmax_iterations)
# perform inference
PEER_update(model)

#get corrected dataset:
factors = PEER_getX(model)
dim(factors)
reads_peer= PEER_getResiduals(model) 


Rscript /home/ls/rachelcw/projects/PEER/run_PEER.R /home/ls/rachelcw/projects/PEER/data_for_peer.tsv /home/ls/rachelcw/projects/PEER/run_peer 25
#   #   #   DOCKER  #   #   # 
docker pull gcr.io/broad-cga-francois-gtex/gtex_eqtl:V9
docker run -v /home/ls/rachelcw/projects/PEER/:/data --rm gcr.io/broad-cga-francois-gtex/gtex_eqtl:V9 Rscript /src/run_PEER.R /data/data_for_peer_20221221.tsv /data/peer_20221221 25 > peer_run.log