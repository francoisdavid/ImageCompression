function []= ImageCompression()
    
    % Read the image. 
    I = imread('lena_color.tiff');
    % Convert it to gray scale. 
    I = rgb2gray(I); 
    I = double(I);
    
   % Ask the user to select a macroblock size to divise the image
    prompt = 'What size of macroblock do you want? :';
    blockSize = input(prompt); 
    
    % Dividing the image into different block according to the user input. 
    blocks = mat2cell(I,blockSize*ones(1,size(I,1)/blockSize), blockSize*ones(1,size(I,2)/blockSize));

    % Moving the average to zero.
    nbOfBlocks = size(I,1)/blockSize ; 
    for i = 1:nbOfBlocks 
        for j = 1:nbOfBlocks
           blocks(i,j) = mat2cell(cell2mat(blocks(i,j))-128, blockSize, blockSize);
        end
    end
    
    % Calculate the discrete cosine transform matrix.
    D = dctmtx(blockSize);
    % Just initializing a matrix of matrix of the same size as I, which
    % will be overriden to contain the dct coefficients.
    dctCoefficients = mat2cell(I,blockSize*ones(1,size(I,1)/blockSize), blockSize*ones(1,size(I,2)/blockSize));
    for i = 1:nbOfBlocks 
        for j = 1:nbOfBlocks
           dctCoefficients(i,j) = mat2cell(round(D * (cell2mat(blocks(i,j))) * D'), blockSize, blockSize);
        end
    end
    % Matrices that will be overriden but with the good size. 
    Fhats = mat2cell(I,blockSize*ones(1,size(I,1)/blockSize), blockSize*ones(1,size(I,2)/blockSize));
    fhats = mat2cell(I,blockSize*ones(1,size(I,1)/blockSize), blockSize*ones(1,size(I,2)/blockSize));
    error = mat2cell(I,blockSize*ones(1,size(I,1)/blockSize), blockSize*ones(1,size(I,2)/blockSize));
   
    
    % Matrix given in the statement of A3. 
    D0 = [8 16 19 22 26 27 29 34,
            16 16 22 24 27 29 34 37,
            19 22 26 27 29 34 34 38,
            22 22 26 27 29 34 37 40,
            22 26 27 29 32 35 40 48,
            26 27 29 32 35 40 48 58,
            26 27 29 34 38 46 56 69,
            27 29 35 38 46 56 69 83
            ];
        
        % Changing the sinze of the given matrix. 
        D0 = imresize(D0, [blockSize, blockSize]);
        
   
    % C) 
    for i = 1:nbOfBlocks 
        for j = 1:nbOfBlocks
           Fhats(i,j) = mat2cell(round(cell2mat(dctCoefficients(i,j))./D0) .* D0, blockSize, blockSize);
           cell2mat(Fhats(i,j));
        end
    end
    
     % Ask the user to select a macroblock size to divise the image
    prompt = 'How much data do you want to send? :';
    data = input(prompt); 
    while data > blockSize * blockSize  && data > 0 
        prompt = 'You have to send less data  than the blockSize. How much data do you want to send? :';
        data = input(prompt); 
    end
    
        % Create the array that will be filled with block size.
      compressed = zeros(nbOfBlocks*nbOfBlocks, data); 
      counter = 1;
      % Compressing the zig zag values according to user input.
      for i = 1:nbOfBlocks
          for j = 1:nbOfBlocks
              z = zigzag(cell2mat(Fhats(i,j)));
              compressed(counter,:) = z(1:data);
              counter = counter + 1;
          end
      end
      
      %Decompress
     counter = 1 ;
     for i = 1:nbOfBlocks
         for j = 1:nbOfBlocks
             decompres = zeros(blockSize*blockSize,1);
             decompres(1:data) = compressed(counter, :);
             temp = izigzag(decompres, blockSize, blockSize);
             Fhats(i,j) = mat2cell(temp, blockSize, blockSize);
             counter = counter + 1;
         end
      end
      
      
    % Dequantisizing.
     for i = 1:nbOfBlocks 
        for j = 1:nbOfBlocks
           fhats(i,j) = mat2cell(round(D'* cell2mat(Fhats(i,j)) * D), blockSize, blockSize);
           
        end
     end
     % The Added 128 is added in the calculations of the erro matrice and
     % the show the matrice.
    
      
      % Error matrices.
      for i = 1:nbOfBlocks 
        for j = 1:nbOfBlocks
           error(i,j) = mat2cell((double(cell2mat(blocks(i,j))) - (double(cell2mat(fhats(i,j))) ) ), blockSize, blockSize);
        end
      end
  
    % MSE Calculations. 
     mse = 0 ;
     for i = 1:nbOfBlocks 
        for j = 1:nbOfBlocks
           
           mse = mse + sum(sum(double(cell2mat(error(i,j))) .* double(cell2mat(error(i,j)))));
        end
     end
     
     
     % Display the decompressed image and the original image. 
     figure;
     subplot(1,2,1);
     original = cell2mat(blocks)+128;
    
     imshow(original, []);
     title('Original Image')  ;
     subplot(1,2,2);
     imshow(cell2mat(fhats)+128,[]);
    
     title('Image After Compression and Decompression')  ;
    
     % MSE Calculations. 
     mse = mse/(512*512);
     % display to the screen
     mse
     
     %PSNR Calculations.
     psnr =10*log10(255^2/mse);
     %display to the screen
     psnr
     
end

