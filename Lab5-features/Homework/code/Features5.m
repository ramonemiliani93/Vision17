tic
if isunix
addpath('/datos1/vision/Emiliani_Posada/Lab5_features/example')
addpath('/datos1/vision/Emiliani_Posada/Lab5_features/functions')
addpath('/datos1/vision/Emiliani_Posada/Lab5_features/test')
addpath('/datos1/vision/Emiliani_Posada/Lab5_features/train')
end

rateTrain = 10;
rateTest = 1;

%Size images
filas = 480;
columnas = 640;

%%Create a filter bank with deafult params
[fb] = fbCreate;

%Set number of clusters
k = 50;

%Load training images and apply filter bank
trainImages = dir('train/*.jpg');
nTrainImages = length(trainImages);

samplingTrain = 1:rateTrain:nTrainImages;

Image = zeros(1,filas*columnas*size(samplingTrain,2));


for i=1:size(samplingTrain,2)
   currentfilename = trainImages(samplingTrain(i)).name;
   currentImage = im2double(imread(['train' filesep currentfilename]));
   index = (i-1)*filas*columnas+1;
   Image(1,index:index+filas*columnas-1) = reshape(currentImage,1,filas*columnas);
end

Image = reshape(Image,filas,columnas*size(samplingTrain,2));
time_a = toc;
disp('Concatenacion Imagenes')
filterResponse = fbRun(fb,Image);
[map,textons] = computeTextons(filterResponse,k);
time_b = toc;
disp('Calculo de textones')

directory = datestr(now, 'dd.HH.MM.SS');
mkdir(strtrim(directory))
cd(directory)
csvwrite('map.csv',map)
csvwrite('textons.csv',textons)
cd('..')

%Result histogram matrix
X = zeros(size(samplingTrain,2), k);
Y = zeros(size(samplingTrain,2),1);

for i=1:size(samplingTrain,2)
   currentfilename = trainImages(samplingTrain(i)).name;
   currentImage = im2double(imread(['train' filesep currentfilename]));
   Image = assignTextons(fbRun(fb,currentImage),textons');
   X(i,:) = histc(Image(:),1:k)/numel(Image);
   Y(i,1) = str2double(currentfilename(2:3));
   disp(['Asignacion de texton a train:' num2str(i)])
end
time_c = toc;
disp('Finaliza signacion de textones a train')
func = @chiSqrDist;
%@(x,Z)chiSqrDist(x,Z)

minDist = @(x,Z)(1-sum(bsxfun(@min,x,Z),2));
%@(x,Z)minDist(x,Z)

%B = TreeBagger(150,X,Y, 'Method', 'classification', 'MinLeafSize', 2);

Mdl = fitcknn(X,Y,'Distance',@(x,Z)func(x,Z));
time_d = toc;
disp('Calculo KNN')
%Load test images and apply filter bank
testImages = dir('test/*.jpg');
nTestImages = length(testImages);

samplingTest = 1:rateTest:nTestImages;

confusionMatrix = zeros(size(samplingTest,2),2);

for i=1:size(samplingTest,2)
   currentfilename = testImages(samplingTest(i)).name;
   currentImage = im2double(imread(['test' filesep currentfilename]));
   Image = assignTextons(fbRun(fb,currentImage),textons');
   %temp = B.predict((histc(Image(:),1:k)/numel(Image))');
   %confusionMatrix(i,2) = str2double(temp{1});
   confusionMatrix(i,2) = predict(Mdl,(histc(Image(:),1:k)/numel(Image))');
   confusionMatrix(i,1) = str2double(currentfilename(2:3));
   disp(['Asignacion de texton a test:' num2str(i)])
end

time_e = toc;
disp('Finaliza asignacion de textones a test')
cd(directory)

csvwrite('results.csv',confusionMatrix)

targets = zeros(25,250);
for i = 1: length(confusionMatrix(:,1))
targets(confusionMatrix(i,1),i) = 1;
end

outputs = zeros(25,250);
for i = 1: length(confusionMatrix(:,2))
outputs(confusionMatrix(i,2),i) = 1;
end

csvwrite('targets.csv',targets)
csvwrite('outputs.csv',outputs)

tiempos = [time_a;time_b;time_c;time_d;time_e];
csvwrite('tiempos.csv',tiempos)