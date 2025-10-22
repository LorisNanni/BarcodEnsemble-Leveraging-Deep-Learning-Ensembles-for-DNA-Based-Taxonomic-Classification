clear all

UseSparse=1;%1 to extract the sparse image, otherwise the dense image
target_size = [224, 224]; % Define the target size for the generated images, e.g. the input size of your net

% Remember that this method is based on generating images from an input vector,
% which in our paper corresponds to the features extracted from the foundation model.
% In this example, we simply create a vector using the RAND function,
% since the goal is just to demonstrate how to use the function.
% Later, of course, instead of RAND, you will use the feature vector from your own approach.

network_features=rand(768,1);%it is our feature vector

%Now we initialize the structures used for image generation.
% Remember that the selection of wavelets is random,
% but it remains fixed for all images belonging to a given network.
% Therefore, to create an ensemble of different networks, a new initialization must be performed.
% During this initialization phase, the wavelets to be used for image generation are selected.

LoadDWT;%set of the discrete wavelet used in the following

if UseSparse==1
    %initialization: the first wavelet based approach, the sparse one
    initWaveSparse;
else
    %initialization: the latter approach based on wavelet, the dense one
    initWave;
end



if UseSparse==1
    %% the first wavelet based approach, the sparse one
    if length(network_features)<500
        ImageSparse=DWTsparse(network_features,SelectedWave,ord,app,target_size);
        %network_features, it is the feature vector
        %SelectedWave, id of the mother wavelet randomly selected
        %ord, shuffle of the features, it is different for each of the
        %three channels
        %app, name of the mother wavelet randomly selected
    elseif length(network_features)>=500 & length(network_features)<1500
        L=2;
        ImageSparse=DWTsparseL(network_features,SelectedWave,ord,app,L,target_size);
    else
        L=4;
        ImageSparse=DWTsparseL(network_features,SelectedWave,ord,app,L,target_size);
    end

else
    %% the latter approach based on wavelet, the dense one
    %image creation given a feature vector
    ImageDense=DWTdense(network_features,SelectedWave,target_size,ALL_PERMUTATIONS,app,random_flips);
    %network_features, it is the feature vector
    %SelectedWave, mother wavelet randomly selected
    %target_size, input size of your net
    %app, name of the mother wavelet randomly selected
    %ALL_PERMUTATIONS and random_flips, used for randomly shuffling, they are
    %create in initWave

end
