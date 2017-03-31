addpath ~/Emiliani_Posada/Lab7_BSDS500/BSR/bench_fast/benchmarks

imgDir = '~/Emiliani_Posada/Lab7_BSDS500/BSR/BSDS500/data/images/test';
gtDir = '~/Emiliani_Posada/Lab7_BSDS500/BSR/BSDS500/data/groundTruth/test';
inDir = '~/Emiliani_Posada/Lab7_BSDS500/ResultsF/KMS';
outDir = '~/Emiliani_Posada/Lab7_BSDS500/ResultsF/kmeans_eval'

%inDir = '~/Emiliani_Posada/Lab7_BSDS500/ResultsF/GMM'
%outDir = '~/Emiliani_Posada/Lab7_BSDS500/ResultsF/gmm_eval'

mkdir(outDir);
nthresh = 99;

tic;
allBench_fast(imgDir, gtDir, inDir, outDir, nthresh);
toc;