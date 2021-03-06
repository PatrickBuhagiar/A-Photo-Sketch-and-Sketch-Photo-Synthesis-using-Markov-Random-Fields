%% Load sample image
disp(sprintf('This is a demo script for the PhD toolbox. It demonstrates how to use several \nfunctions from the toolbox to construct a PCA-based face recognition system \nand how to test it on the ORL database. At the end, some results are generated.'));
disp(' ')
disp('Step 1:')
disp('Load images from a database. In our case, from the ORL database')

proceed = 1;
data_matrix = [];
ids = [];

ids_train = [];
ids_test = [];
train_data = [];
test_data = [];
cont = 1;

train_path = 'warped_images3\';
train_list =  dir([train_path '*jpg']);
n_train = size(train_list, 1);

test_path = 'testing\';
test_list =  dir([test_path '*jpg']);
n_test = size(test_list, 1);

model_path = '..\02_data\02_Multi-PIE\01_AOMs\';
load([model_path 'AOM_MultiPIE_InTheWild']);


%try
   for i=1:n_train
       i
       filename = [train_path 'image_' num2str(i) '.jpg'];
       X = double((imread(filename)))./255;
       X =SubSample(X,160,160); %warped_img;%
       
       train_data = [train_data,X(:)];
       ids_train = [ids_train, i];
   end
   
   for j=1:n_test
       j
       filename = [test_path 'I_B_' num2str(j) '.jpg'];
       X = double(imread(filename))./255;
       X =SubSample(X,160,160);
       test_data = [test_data, X(:)];
       ids_test = [ids_test, j];
   end



if(proceed)
    disp('Finished with Step 1 (database loading).')
    %disp('Press any key to continue ...')
    %pause();

    %% Partitioning of the data
    disp(' ')
    disp('Step 2:')
    disp('Partition data into training and test sets. In our case, the first 3 images')
    disp('of each ORL subject will serve as the training/gallery/target set and the remaining')
    disp('images will serve as test/evaluation/query images.')

	%% Construct PCA subspace
    disp(' ')
    disp('Step 3:')
    disp('Compute training and test feature vectors using your method of choice. In our')
    disp('case we use PCA for feature extraction, and, therefore, first compute the PCA ')
    disp('subspace using the training data from the ORL database.')
    model = perform_pca_PhD(train_data,rank(train_data)-1);
    
    
    disp('Finished PCA subspace construction. Starting test image projection.')
    test_features = linear_subspace_projection_PhD(test_data, model, 1);
    disp('Finished with Step 3 (feature extraction).')   
    
    %% Compute similarity matrix
    disp(' ')
    disp('Step 4:')
    disp('Compute matching scores between gallery/training/target feature vectors and')
    disp('test/query feature vectors. In our case we use the Mahalanobis cosine similarity')
    disp('measure for that.')
    results = nn_classification_PhD(model.train, ids_train, test_features, ids_test, size(test_features,1), 'mahcos');
    disp('Finished with Step 4 (matching).')
  
    %% Evaluate similarity matrix
    disp(' ')
    disp('Step 5:')
    disp('Evaluate results and present performance metrics.')
    output = evaluate_results_PhD(results,'ID');
    figure(1)
    plot_CMC_PhD(output.CMC_rec_rates , output.CMC_ranks,'r',2);
    legend('PCA+MAHCOS')
    title('CMC curve for the PCA+MAHCOS technique on the ORL database.')
    try
        figure(3)    
        Plot_DET(output.DET_frr_rate, output.DET_far_rate, 'r', 2);
        title('DET curve for the PCA+MAHCOS technique on the ORL database.')
    catch
        close 3    
        disp('Tried to plot DET curve, but it seems you have not installed NISTs DETware.')
    end
    disp(' ')
    disp('=============================================================')
    disp('SOME PERFORMANCE METRICS:')
    disp(' ')
    disp('Identification experiments:')
    disp(sprintf('The rank one recognition rate equals (in %%): %3.2f%%', output.CMC_rec_rates(1)*100));
    disp(' ')
    disp('Verification/authentication experiments:')
    disp(sprintf('The equal error rate equals (in %%): %3.2f%%', output.ROC_char_errors.EER_er*100));
    disp(sprintf('The minimal half total error rate equals (in %%): %3.2f%%', output.ROC_char_errors.minHTER_er*100));
    disp(sprintf('The verification rate at 1%% FAR equals (in %%): %3.2f%%', output.ROC_char_errors.VER_1FAR_ver*100));
    disp(sprintf('The verification rate at 0.1%% FAR equals (in %%): %3.2f%%', output.ROC_char_errors.VER_01FAR_ver*100));
    disp(sprintf('The verification rate at 0.01%% FAR equals (in %%): %3.2f%%', output.ROC_char_errors.VER_001FAR_ver*100));
    disp('=============================================================')

    disp('Finished with Step 5 (evaluation).')
    
end
disp('Finished demo.')




















